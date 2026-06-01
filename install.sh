#!/usr/bin/env bash
set -euo pipefail

# ─── Co-Agents Installer ─────────────────────────────────────────────────────
# File-copy installer for editors WITHOUT a native plugin system (GitHub Copilot
# today; more later). Claude Code installs via the plugin marketplace instead —
# see --claude below.
#
# Usage:
#   ./install.sh <target-project-path> [options]
#
# Options:
#   --copilot     Install the GitHub Copilot layout (.github/) — the default
#   --claude      Print how to install the Claude Code plugin, then exit
#   --dry-run     Show what would happen without making changes
#   --force       Overwrite existing files (default: skip)
#   --no-memory   Skip creating .co-agents/ skeleton
#   --help        Show this help message
# ─────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST="$SCRIPT_DIR/dist"
SHARED="$DIST/shared"
REPO="mohamed-abdelsamei/co-agents"

DRY_RUN=false
FORCE=false
SKIP_MEMORY=false
WANT_CLAUDE=false
WANT_COPILOT=false
TARGET=""

# ─── Colors ───────────────────────────────────────────────────────────────────

# ANSI-C quoting ($'...') stores real escape bytes, so colors render in both
# `echo -e` and `cat <<EOF` heredocs.
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

File-copy installer for editors without a native plugin system (GitHub Copilot).
Claude Code installs via the plugin marketplace — run with --claude for steps.

${BOLD}Usage:${NC}
  $(basename "$0") <target-project-path> [options]

${BOLD}Options:${NC}
  --copilot     Install the GitHub Copilot layout (.github/) — the default
  --claude      Print how to install the Claude Code plugin, then exit
  --dry-run     Show what would happen without making changes
  --force       Overwrite existing files (default: skip existing)
  --no-memory   Skip creating .co-agents/ skeleton
  --help        Show this help message

${BOLD}What gets installed (Copilot):${NC}
  .github/copilot-instructions.md, .github/agents, .github/prompts,
  .github/instructions, .github/skills
  Shared:  docs/ (skeleton) and .co-agents/ (project memory)

${BOLD}Examples:${NC}
  $(basename "$0") ~/Work/my-app                # GitHub Copilot
  $(basename "$0") ~/Work/my-app --dry-run
  $(basename "$0") --claude                     # Claude plugin instructions

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

# Claude uses the plugin marketplace, not file copying.
if $WANT_CLAUDE; then
  claude_instructions
fi

if [[ -z "$TARGET" ]]; then
  error "Missing target project path"
  echo ""
  usage
fi

# Resolve target to absolute path
if [[ ! -d "$TARGET" ]]; then
  error "Target directory does not exist: $TARGET"
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"

# Don't install into ourselves
if [[ "$TARGET" == "$SCRIPT_DIR" ]]; then
  error "Cannot install into the source directory itself"
  exit 1
fi

# ─── Helpers ──────────────────────────────────────────────────────────────────

copied=0
skipped=0
created_dirs=0

rel_path() {
  echo "${1#$TARGET/}"
}

ensure_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    if $DRY_RUN; then
      dry "mkdir -p $(rel_path "$dir")"
    else
      mkdir -p "$dir"
    fi
    created_dirs=$((created_dirs + 1))
  fi
}

copy_file() {
  local src="$1"
  local dest="$2"
  local rel
  rel="$(rel_path "$dest")"

  if [[ -f "$dest" ]] && ! $FORCE; then
    warn "Skipping (exists): $rel"
    skipped=$((skipped + 1))
    return
  fi

  if $DRY_RUN; then
    if [[ -f "$dest" ]]; then
      dry "overwrite $rel"
    else
      dry "copy → $rel"
    fi
  else
    ensure_dir "$(dirname "$dest")"
    cp "$src" "$dest"
  fi
  copied=$((copied + 1))
}

# Recursively copy a source tree's contents into a destination directory.
copy_tree() {
  local src_dir="$1"
  local dest_dir="$2"

  while IFS= read -r -d '' src_file; do
    local rel="${src_file#$src_dir/}"
    copy_file "$src_file" "$dest_dir/$rel"
  done < <(find "$src_dir" -type f -print0)
}

# ─── Preflight ────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Co-Agents Installer${NC}"
echo -e "Source: ${BLUE}$SCRIPT_DIR${NC}"
echo -e "Target: ${BLUE}$TARGET${NC}"
echo -e "Tool:   ${BLUE}copilot${NC}"
$DRY_RUN && echo -e "Mode:   ${YELLOW}dry-run${NC}" || echo -e "Mode:   ${GREEN}install${NC}"
$FORCE && echo -e "Force:  ${YELLOW}overwrite existing files${NC}"
echo ""

if [[ ! -d "$DIST/copilot/.github" ]]; then
  error "Copilot build missing: $DIST/copilot/.github"
  error "Run 'python3 scripts/build.py' first to generate dist/ from src/."
  exit 1
fi
if [[ ! -d "$SHARED" ]]; then
  error "Shared payload missing: $SHARED (run 'python3 scripts/build.py')"
  exit 1
fi

# ─── Install Copilot layout ──────────────────────────────────────────────────

log "Installing GitHub Copilot layout (.github/)..."
copy_tree "$DIST/copilot/.github" "$TARGET/.github"

# ─── Docs Skeleton (shared) ──────────────────────────────────────────────────

log "Setting up docs/..."
if [[ -d "$SHARED/docs" ]]; then
  copy_tree "$SHARED/docs" "$TARGET/docs"
fi

# ─── Project Memory Skeleton (shared) ────────────────────────────────────────

if ! $SKIP_MEMORY; then
  log "Setting up project memory (.co-agents/)..."

  MEMORY_DIR="$TARGET/.co-agents"
  ensure_dir "$MEMORY_DIR"

  if [[ -d "$SHARED/memory" ]]; then
    copy_tree "$SHARED/memory" "$MEMORY_DIR"
  fi

  for subdir in requirements tasks reviews research experiments; do
    ensure_dir "$MEMORY_DIR/$subdir"
    gitkeep="$MEMORY_DIR/$subdir/.gitkeep"
    if [[ ! -f "$gitkeep" ]]; then
      if $DRY_RUN; then
        dry "touch $(rel_path "$gitkeep")"
      else
        touch "$gitkeep"
      fi
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
