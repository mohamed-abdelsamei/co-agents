#!/usr/bin/env bash
set -euo pipefail

# ─── Co-Agents Installer ─────────────────────────────────────────────────────
# Installs co-agents as files for GitHub Copilot or Claude Code, at project or
# user (global) scope. (Claude's recommended path is the marketplace plugin —
# see --claude notes / README; this is the file-install alternative.)
#
# Self-bootstrapping: run from a clone, or one-line over curl (it clones itself
# when needed). Needs python3 + git.
#
#   bash <(curl -fsSL https://raw.githubusercontent.com/mohamed-abdelsamei/co-agents/main/install.sh) .
#   ./install.sh <target-project-path> [options]
#
# Tool (pick one; default --copilot):
#   --copilot     GitHub Copilot layout
#   --claude      Claude Code file layout (.claude/ + CLAUDE.md)
#
# Scope:
#   (default)     Project: into <target>/ — also lays the .co-agents/ memory skeleton
#   --user        User/global: every project (no <target> needed; no memory skeleton)
#   --user-dir D  Override the user-scope destination (Copilot only)
#
# Other:
#   --dry-run --force --no-memory --help
# ─────────────────────────────────────────────────────────────────────────────

REPO_HTTPS="https://github.com/mohamed-abdelsamei/co-agents.git"
REPO_SSH="git@github.com:mohamed-abdelsamei/co-agents.git"
REPO="mohamed-abdelsamei/co-agents"

DRY_RUN=false
FORCE=false
SKIP_MEMORY=false
TOOL="copilot"
USER_LEVEL=false
USER_DIR=""
USE_SSH=false
TARGET=""

# ─── Colors ───────────────────────────────────────────────────────────────────

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'; BOLD=$'\033[1m'; NC=$'\033[0m'

log()   { echo -e "${GREEN}→${NC} $*"; }
warn()  { echo -e "${YELLOW}⚠${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*" >&2; }
info()  { echo -e "${BLUE}ℹ${NC} $*"; }
dry()   { echo -e "${YELLOW}[dry-run]${NC} $*"; }

# ─── Usage ────────────────────────────────────────────────────────────────────

usage() {
  cat <<EOF
${BOLD}Co-Agents Installer${NC}

Installs co-agents as files for GitHub Copilot or Claude Code, at project or
user scope. Needs python3 + git. (Claude's zero-maintenance path is the plugin:
'/plugin marketplace add ${REPO}' then '/plugin install co-agents'.)

${BOLD}Usage:${NC}
  bash <(curl -fsSL https://raw.githubusercontent.com/${REPO}/main/install.sh) <target>
  ./install.sh <target-project-path> [options]

${BOLD}Tool${NC} (default --copilot):
  --copilot      GitHub Copilot layout (.github/)
  --claude       Claude Code file layout (.claude/ + CLAUDE.md)

${BOLD}Scope:${NC}
  (default)      Project — into <target>/, plus the .co-agents/ memory skeleton
  --user         User/global — for every project; no <target>, no memory skeleton
                   Claude  → ~/.claude/
                   Copilot → the VS Code user profile (override with --user-dir)
  --user-dir D   Override the user-scope destination directory

${BOLD}Other:${NC}
  --dry-run      Preview without making changes
  --force        Overwrite existing files (default: skip)
  --no-memory    Skip the .co-agents/ skeleton (project scope only)
  --help         Show this help

${BOLD}Examples:${NC}
  ./install.sh ~/Work/app                 # Copilot, this project
  ./install.sh ~/Work/app --claude        # Claude files, this project
  ./install.sh --claude --user            # Claude files in ~/.claude (all projects)
  ./install.sh --copilot --user           # Copilot files in the VS Code user profile
EOF
  exit 0
}

# ─── Parse Args ───────────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
  case "$1" in
    --claude)     TOOL="claude"; shift ;;
    --copilot)    TOOL="copilot"; shift ;;
    --user)       USER_LEVEL=true; shift ;;
    --user-dir)   USER_DIR="${2:-}"; shift 2 ;;
    --ssh)        USE_SSH=true; shift ;;
    --dry-run)    DRY_RUN=true; shift ;;
    --force)      FORCE=true; shift ;;
    --no-memory)  SKIP_MEMORY=true; shift ;;
    --help|-h)    usage ;;
    -*)           error "Unknown option: $1"; echo ""; usage ;;
    *)
      if [[ -z "$TARGET" ]]; then TARGET="$1"; else error "Unexpected argument: $1"; exit 1; fi
      shift ;;
  esac
done

# Project scope needs a target; user scope does not.
if ! $USER_LEVEL; then
  if [[ -z "$TARGET" ]]; then
    error "Missing target project path (or use --user for a global install)"
    echo ""
    usage
  fi
  [[ -d "$TARGET" ]] || { error "Target directory does not exist: $TARGET"; exit 1; }
  TARGET="$(cd "$TARGET" && pwd)"
fi

# ─── Locate the repo (clone it if running standalone) ────────────────────────

CLEANUP_DIR=""
cleanup() { [[ -n "$CLEANUP_DIR" ]] && rm -rf "$CLEANUP_DIR"; }
trap cleanup EXIT

REPO_DIR=""
if SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" \
   && [[ -f "$SELF_DIR/adapters/__main__.py" ]]; then
  REPO_DIR="$SELF_DIR"
fi
if [[ -z "$REPO_DIR" ]]; then
  command -v git >/dev/null 2>&1 || { error "git is required to self-clone."; exit 1; }
  $USE_SSH && REPO_URL="$REPO_SSH" || REPO_URL="$REPO_HTTPS"
  CLEANUP_DIR="$(mktemp -d)"
  log "Fetching co-agents..."
  if ! git clone --depth 1 --branch main "$REPO_URL" "$CLEANUP_DIR/co-agents" 2>/dev/null; then
    error "Failed to clone from $REPO_URL"; ! $USE_SSH && info "For private access, try --ssh."; exit 1
  fi
  REPO_DIR="$CLEANUP_DIR/co-agents"
fi
command -v python3 >/dev/null 2>&1 || { error "python3 is required to build the layout."; exit 1; }

DIST="$REPO_DIR/dist"
SHARED="$DIST/shared"

build_target() { ( cd "$REPO_DIR" && python3 -m adapters "$1" >/dev/null ); }

# ─── Copy helpers (SUBST_ROOT, when set, replaces the __CO_ROOT__ token) ─────

copied=0; skipped=0; created_dirs=0
SUBST_ROOT=""

rel_path() { echo "${1#"$BASE"/}"; }

ensure_dir() {
  local d="$1"
  [[ -d "$d" ]] && return
  if $DRY_RUN; then dry "mkdir -p $(rel_path "$d")"; else mkdir -p "$d"; fi
  created_dirs=$((created_dirs + 1))
}

copy_file() {
  local src="$1" dest="$2" rel; rel="$(rel_path "$dest")"
  if [[ -f "$dest" ]] && ! $FORCE; then warn "Skipping (exists): $rel"; skipped=$((skipped + 1)); return; fi
  if $DRY_RUN; then
    [[ -f "$dest" ]] && dry "overwrite $rel" || dry "copy → $rel"
  else
    ensure_dir "$(dirname "$dest")"
    if [[ -n "$SUBST_ROOT" ]]; then sed "s|__CO_ROOT__|$SUBST_ROOT|g" "$src" > "$dest"; else cp "$src" "$dest"; fi
  fi
  copied=$((copied + 1))
}

copy_tree() {
  local src_dir="$1" dest_dir="$2"
  while IFS= read -r -d '' f; do copy_file "$f" "$dest_dir/${f#"$src_dir"/}"; done \
    < <(find "$src_dir" -type f -print0)
}

# ─── Resolve destinations per tool + scope ───────────────────────────────────

default_vscode_user_dir() {
  case "$(uname -s)" in
    Darwin) echo "$HOME/Library/Application Support/Code/User" ;;
    Linux)  echo "$HOME/.config/Code/User" ;;
    *)      echo "" ;;
  esac
}

echo ""
echo -e "${BOLD}Co-Agents Installer${NC}"
echo -e "Source: ${BLUE}$REPO_DIR${NC}"
echo -e "Tool:   ${BLUE}$TOOL${NC}    Scope: ${BLUE}$([[ $USER_LEVEL == true ]] && echo user || echo project)${NC}"
$DRY_RUN && echo -e "Mode:   ${YELLOW}dry-run${NC}" || echo -e "Mode:   ${GREEN}install${NC}"
echo ""

if [[ "$TOOL" == "claude" ]]; then
  log "Building Claude file layout (python3 -m adapters claude-local)..."
  build_target claude-local
  SRC="$DIST/claude-local"
  [[ -d "$SRC" ]] || { error "Build produced no output at $SRC"; exit 1; }
  if $USER_LEVEL; then
    CLAUDE_HOME="$HOME/.claude"; SUBST_ROOT="$HOME/.claude"; BASE="$HOME"
    CLAUDE_MD="$CLAUDE_HOME/CLAUDE.md"
  else
    CLAUDE_HOME="$TARGET/.claude"; SUBST_ROOT=".claude"; BASE="$TARGET"
    CLAUDE_MD="$TARGET/CLAUDE.md"
  fi
  log "Installing Claude layout → ${CLAUDE_HOME/#$HOME/\~}/ ..."
  for d in agents commands instructions skills; do
    [[ -d "$SRC/$d" ]] && copy_tree "$SRC/$d" "$CLAUDE_HOME/$d"
  done
  [[ -f "$SRC/CLAUDE.md" ]] && copy_file "$SRC/CLAUDE.md" "$CLAUDE_MD"
  echo ""; info "Tip: the marketplace plugin is the zero-maintenance alternative —"
  info "  /plugin marketplace add ${REPO}  →  /plugin install co-agents"
else
  log "Building Copilot layout (python3 -m adapters copilot)..."
  build_target copilot
  [[ -d "$DIST/copilot/.github" ]] || { error "Build produced no .github output"; exit 1; }
  SUBST_ROOT=""
  if $USER_LEVEL; then
    [[ -n "$USER_DIR" ]] || USER_DIR="$(default_vscode_user_dir)"
    [[ -n "$USER_DIR" ]] || { error "Could not detect a VS Code user dir; pass --user-dir D."; exit 1; }
    BASE="$USER_DIR"
    log "Installing Copilot files → $USER_DIR/ ..."
    copy_tree "$DIST/copilot/.github" "$USER_DIR"
    echo ""; info "User-scope Copilot files vary by IDE/version — you may need to point"
    info "  Copilot at this dir (VS Code: chat.promptFilesLocations / instructionsFilesLocations)."
  else
    BASE="$TARGET"
    log "Installing Copilot layout (.github/)..."
    copy_tree "$DIST/copilot/.github" "$TARGET/.github"
  fi
fi

# ─── Shared skeleton (project scope only — memory is per-project) ────────────

if ! $USER_LEVEL; then
  [[ -d "$SHARED" ]] || { error "Shared payload missing at $SHARED"; exit 1; }
  log "Setting up docs/..."
  [[ -d "$SHARED/docs" ]] && copy_tree "$SHARED/docs" "$TARGET/docs"

  if ! $SKIP_MEMORY; then
    log "Setting up project memory (.co-agents/)..."
    MEMORY_DIR="$TARGET/.co-agents"
    ensure_dir "$MEMORY_DIR"
    [[ -d "$SHARED/memory" ]] && copy_tree "$SHARED/memory" "$MEMORY_DIR"
    for sub in requirements tasks reviews research experiments; do
      ensure_dir "$MEMORY_DIR/$sub"
      gk="$MEMORY_DIR/$sub/.gitkeep"
      [[ -f "$gk" ]] || { $DRY_RUN && dry "touch $(rel_path "$gk")" || touch "$gk"; }
    done
  else
    info "Skipping project memory skeleton (--no-memory)"
  fi
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
  if ! $USER_LEVEL; then
    echo ""
    echo -e "${BOLD}Next:${NC} edit the main instructions for your stack, then run /co-init."
  fi
fi
