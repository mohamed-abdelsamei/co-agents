#!/usr/bin/env bash
set -euo pipefail

# ─── Co-Agents Installer ─────────────────────────────────────────────────────
# Installs co-agents for editors WITHOUT a native plugin system (GitHub Copilot).
# Claude Code installs via the plugin marketplace instead — see --claude.
#
# Self-bootstrapping: run it from a clone, or one-line over curl (it clones
# itself to a temp dir when no repo is alongside it). Needs python3 + git.
#
#   # one-liner (clones itself):
#   bash <(curl -fsSL https://raw.githubusercontent.com/mohamed-abdelsamei/co-agents/main/install.sh) .
#
#   # from a clone:
#   ./install.sh <target-project-path> [options]
#
# Options:
#   --copilot     Install the GitHub Copilot layout (.github/) — the default
#   --claude      Print how to install the Claude Code plugin, then exit
#   --ssh         When self-cloning, clone via SSH instead of HTTPS
#   --dry-run     Show what would happen without making changes
#   --force       Overwrite existing files (default: skip)
#   --no-memory   Skip creating .co-agents/ skeleton
#   --help        Show this help message
# ─────────────────────────────────────────────────────────────────────────────

REPO_HTTPS="https://github.com/mohamed-abdelsamei/co-agents.git"
REPO_SSH="git@github.com:mohamed-abdelsamei/co-agents.git"
REPO="mohamed-abdelsamei/co-agents"

DRY_RUN=false
FORCE=false
SKIP_MEMORY=false
WANT_CLAUDE=false
WANT_COPILOT=false
USE_SSH=false
TARGET=""

# ─── Colors ───────────────────────────────────────────────────────────────────

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
BOLD=$'\033[1m'
NC=$'\033[0m'

log()   { echo -e "${GREEN}→${NC} $*"; }
warn()  { echo -e "${YELLOW}⚠${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*" >&2; }
info()  { echo -e "${BLUE}ℹ${NC} $*"; }
dry()   { echo -e "${YELLOW}[dry-run]${NC} $*"; }

# ─── Usage ────────────────────────────────────────────────────────────────────

usage() {
  cat <<EOF
${BOLD}Co-Agents Installer${NC}

Installs co-agents for GitHub Copilot (needs python3 + git). Claude Code uses
the plugin marketplace — run with --claude for steps.

${BOLD}Usage:${NC}
  bash <(curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh) <target>
  ./install.sh <target-project-path> [options]

${BOLD}Options:${NC}
  --copilot     Install the GitHub Copilot layout (.github/) — the default
  --claude      Print how to install the Claude Code plugin, then exit
  --ssh         When self-cloning, clone via SSH instead of HTTPS
  --dry-run     Show what would happen without making changes
  --force       Overwrite existing files (default: skip existing)
  --no-memory   Skip creating .co-agents/ skeleton
  --help        Show this help message

${BOLD}What gets installed (Copilot):${NC}
  .github/copilot-instructions.md, .github/agents, .github/prompts,
  .github/instructions, .github/skills
  Shared:  docs/ (skeleton) and .co-agents/ (project memory)

${BOLD}After installation:${NC}
  1. Edit .github/copilot-instructions.md to match the project's stack
  2. Run /co-init to scan the codebase, populate project memory, and define principles
EOF
  exit 0
}

claude_instructions() {
  echo ""
  echo -e "${BOLD}Install co-agents for Claude Code (plugin):${NC}"
  echo ""
  echo -e "  ${GREEN}/plugin marketplace add ${REPO}${NC}"
  echo -e "  ${GREEN}/plugin install co-agents${NC}"
  echo ""
  echo -e "Then, inside your project, run ${GREEN}/co-setup${NC} (new project) or ${GREEN}/co-init${NC}"
  echo "(existing project) — the command creates .co-agents/, docs/, and CLAUDE.md for you."
  echo ""
  echo "No file copying is needed for Claude Code, so this installer makes no changes."
  exit 0
}

# ─── Parse Args ───────────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
  case "$1" in
    --claude)     WANT_CLAUDE=true; shift ;;
    --copilot)    WANT_COPILOT=true; shift ;;
    --ssh)        USE_SSH=true; shift ;;
    --dry-run)    DRY_RUN=true; shift ;;
    --force)      FORCE=true; shift ;;
    --no-memory)  SKIP_MEMORY=true; shift ;;
    --help|-h)    usage ;;
    -*)           error "Unknown option: $1"; echo ""; usage ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$1"
      else
        error "Unexpected argument: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

# Claude uses the plugin marketplace, not file copying — handle before any clone.
if $WANT_CLAUDE; then
  claude_instructions
fi

if [[ -z "$TARGET" ]]; then
  error "Missing target project path"
  echo ""
  usage
fi

# Resolve target to absolute path (while cwd is still the caller's directory).
if [[ ! -d "$TARGET" ]]; then
  error "Target directory does not exist: $TARGET"
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

# ─── Locate the repo (clone it if we're running standalone) ──────────────────

CLEANUP_DIR=""
cleanup() { [[ -n "$CLEANUP_DIR" ]] && rm -rf "$CLEANUP_DIR"; }
trap cleanup EXIT

REPO_DIR=""
if SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" \
   && [[ -f "$SELF_DIR/adapters/__main__.py" ]]; then
  REPO_DIR="$SELF_DIR"   # running from a clone
fi

if [[ -z "$REPO_DIR" ]]; then
  # Standalone (e.g. curl) — clone the repo to a temp dir and work from there.
  command -v git >/dev/null 2>&1 || { error "git is required to self-clone."; exit 1; }
  $USE_SSH && REPO_URL="$REPO_SSH" || REPO_URL="$REPO_HTTPS"
  CLEANUP_DIR="$(mktemp -d)"
  log "Fetching co-agents..."
  if ! git clone --depth 1 --branch main "$REPO_URL" "$CLEANUP_DIR/co-agents" 2>/dev/null; then
    error "Failed to clone from $REPO_URL"
    ! $USE_SSH && info "For private access, try --ssh."
    exit 1
  fi
  REPO_DIR="$CLEANUP_DIR/co-agents"
fi

if [[ "$TARGET" == "$REPO_DIR" ]]; then
  error "Cannot install into the co-agents repo itself"
  exit 1
fi

DIST="$REPO_DIR/dist"
SHARED="$DIST/shared"

# ─── Helpers ──────────────────────────────────────────────────────────────────

copied=0
skipped=0
created_dirs=0

rel_path() { echo "${1#$TARGET/}"; }

ensure_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    if $DRY_RUN; then dry "mkdir -p $(rel_path "$dir")"; else mkdir -p "$dir"; fi
    created_dirs=$((created_dirs + 1))
  fi
}

copy_file() {
  local src="$1" dest="$2" rel
  rel="$(rel_path "$dest")"
  if [[ -f "$dest" ]] && ! $FORCE; then
    warn "Skipping (exists): $rel"
    skipped=$((skipped + 1))
    return
  fi
  if $DRY_RUN; then
    [[ -f "$dest" ]] && dry "overwrite $rel" || dry "copy → $rel"
  else
    ensure_dir "$(dirname "$dest")"
    cp "$src" "$dest"
  fi
  copied=$((copied + 1))
}

copy_tree() {
  local src_dir="$1" dest_dir="$2"
  while IFS= read -r -d '' src_file; do
    local rel="${src_file#$src_dir/}"
    copy_file "$src_file" "$dest_dir/$rel"
  done < <(find "$src_dir" -type f -print0)
}

# ─── Preflight ────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Co-Agents Installer${NC}"
echo -e "Source: ${BLUE}$REPO_DIR${NC}"
echo -e "Target: ${BLUE}$TARGET${NC}"
echo -e "Tool:   ${BLUE}copilot${NC}"
$DRY_RUN && echo -e "Mode:   ${YELLOW}dry-run${NC}" || echo -e "Mode:   ${GREEN}install${NC}"
$FORCE && echo -e "Force:  ${YELLOW}overwrite existing files${NC}"
echo ""

# Only the Claude plugin (dist/claude/) is committed; the Copilot layout and
# shared payload are built on demand from src/.
if [[ ! -d "$DIST/copilot/.github" || ! -d "$SHARED" ]]; then
  if command -v python3 >/dev/null 2>&1; then
    log "Building Copilot layout from src/ (python3 -m adapters copilot)..."
    ( cd "$REPO_DIR" && python3 -m adapters copilot >/dev/null )
  else
    error "GitHub Copilot install needs python3 to build the layout from src/."
    error "Install python3 and retry. (The Claude Code plugin needs nothing extra — see --claude.)"
    exit 1
  fi
fi
if [[ ! -d "$DIST/copilot/.github" || ! -d "$SHARED" ]]; then
  error "Build did not produce the expected output under $DIST."
  exit 1
fi

# ─── Install Copilot layout ──────────────────────────────────────────────────

log "Installing GitHub Copilot layout (.github/)..."
copy_tree "$DIST/copilot/.github" "$TARGET/.github"

# ─── Docs Skeleton (shared) ──────────────────────────────────────────────────

log "Setting up docs/..."
[[ -d "$SHARED/docs" ]] && copy_tree "$SHARED/docs" "$TARGET/docs"

# ─── Project Memory Skeleton (shared) ────────────────────────────────────────

if ! $SKIP_MEMORY; then
  log "Setting up project memory (.co-agents/)..."
  MEMORY_DIR="$TARGET/.co-agents"
  ensure_dir "$MEMORY_DIR"
  [[ -d "$SHARED/memory" ]] && copy_tree "$SHARED/memory" "$MEMORY_DIR"
  for subdir in requirements tasks reviews research experiments; do
    ensure_dir "$MEMORY_DIR/$subdir"
    gitkeep="$MEMORY_DIR/$subdir/.gitkeep"
    if [[ ! -f "$gitkeep" ]]; then
      $DRY_RUN && dry "touch $(rel_path "$gitkeep")" || touch "$gitkeep"
    fi
  done
else
  info "Skipping project memory skeleton (--no-memory)"
fi

# ─── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Summary${NC}"
echo "  Copied:   $copied files"
echo "  Skipped:  $skipped files (already exist)"
echo "  Created:  $created_dirs directories"
echo ""

if $DRY_RUN; then
  info "Dry run complete. Run without --dry-run to apply changes."
else
  echo -e "${GREEN}${BOLD}✓ Installation complete${NC}"
  echo ""
  echo -e "${BOLD}Next steps:${NC}"
  echo "  1. cd $TARGET"
  echo "  2. Edit .github/copilot-instructions.md to match your stack"
  echo "  3. Run /co-init to scan the codebase, populate project memory, and define principles"
  echo ""
fi
