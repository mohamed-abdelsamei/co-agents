#!/usr/bin/env bash
set -euo pipefail

# ─── Co-Agents Installer (GitHub Copilot) ────────────────────────────────────
# Builds the Copilot bundle from source and installs it for VS Code.
#
#   Global (default):  every workspace — into your VS Code user profile.
#   Project:           one repo — into <path>/.github/ + a .coagents/ memory scaffold.
#
# Needs: python3, bash. Run from a clone of the repo:
#   ./install.sh                 # global install (all workspaces)
#   ./install.sh --project .     # install into this repo's .github/
#
# Claude Code users: the marketplace plugin is the zero-maintenance path —
#   /plugin marketplace add mohamed-abdelsamei/co-agents  →  /plugin install co-agents
# ─────────────────────────────────────────────────────────────────────────────

REPO="mohamed-abdelsamei/co-agents"

DRY_RUN=false
FORCE=false
PROJECT=""
USER_DIR=""
SCOPE="global"

RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; YELLOW=$'\033[0;33m'; BLUE=$'\033[0;34m'
BOLD=$'\033[1m'; NC=$'\033[0m'
log()  { echo -e "${GREEN}→${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC} $*"; }
err()  { echo -e "${RED}✗${NC} $*" >&2; }
info() { echo -e "${BLUE}ℹ${NC} $*"; }
dry()  { echo -e "${YELLOW}[dry-run]${NC} $*"; }

usage() {
  cat <<EOF
${BOLD}Co-Agents Installer — GitHub Copilot (VS Code)${NC}

${BOLD}Usage:${NC}
  ./install.sh [options]

${BOLD}Scope${NC} (default: global):
  (default)        Global — installs into your VS Code user profile, available in every workspace.
  --project PATH   Project — installs into PATH/.github/ and scaffolds PATH/.coagents/ memory.

${BOLD}Other:${NC}
  --user-dir DIR   Override the VS Code user-profile directory (global scope).
  --dry-run        Preview without writing anything.
  --force          Overwrite existing files (default: skip files that exist).
  --help           Show this help.

${BOLD}Examples:${NC}
  ./install.sh                       # global, all workspaces
  ./install.sh --project ~/Work/app  # into that repo's .github/
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)  SCOPE="project"; PROJECT="${2:-}"; shift 2 ;;
    --user-dir) USER_DIR="${2:-}"; shift 2 ;;
    --dry-run)  DRY_RUN=true; shift ;;
    --force)    FORCE=true; shift ;;
    --help|-h)  usage ;;
    *)          err "Unknown argument: $1"; echo ""; usage ;;
  esac
done

# ─── Locate repo + build ──────────────────────────────────────────────────────

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
[[ -f "$REPO_DIR/build.py" ]] || { err "Run this from a clone of the co-agents repo."; exit 1; }
command -v python3 >/dev/null 2>&1 || { err "python3 is required."; exit 1; }

log "Building Copilot bundle..."
( cd "$REPO_DIR" && python3 build.py >/dev/null )
DIST="$REPO_DIR/dist/copilot"
[[ -d "$DIST" ]] || { err "Build produced no output at $DIST"; exit 1; }

# ─── Copy helpers ─────────────────────────────────────────────────────────────

copied=0; skipped=0
copy_file() {
  local src="$1" dest="$2"
  if [[ -f "$dest" ]] && ! $FORCE; then warn "skip (exists): ${dest/#$HOME/\~}"; skipped=$((skipped+1)); return; fi
  if $DRY_RUN; then dry "→ ${dest/#$HOME/\~}"; else mkdir -p "$(dirname "$dest")"; cp "$src" "$dest"; fi
  copied=$((copied+1))
}
copy_glob() { # copy_glob <src-dir> <glob> <dest-dir>
  local d="$1" g="$2" out="$3" f
  shopt -s nullglob
  for f in "$d"/$g; do copy_file "$f" "$out/$(basename "$f")"; done
  shopt -u nullglob
}

default_vscode_user_dir() {
  case "$(uname -s)" in
    Darwin) echo "$HOME/Library/Application Support/Code/User" ;;
    Linux)  echo "$HOME/.config/Code/User" ;;
    *)      echo "" ;;
  esac
}

echo ""
echo -e "${BOLD}Co-Agents → GitHub Copilot${NC}"
echo -e "Scope: ${BLUE}$SCOPE${NC}   $($DRY_RUN && echo "${YELLOW}(dry-run)${NC}")"
echo ""

if [[ "$SCOPE" == "global" ]]; then
  # ── Global: VS Code user profile. Drop agents/prompts/instructions into the
  #    profile's `prompts/` folder, which VS Code auto-discovers for every workspace.
  [[ -n "$USER_DIR" ]] || USER_DIR="$(default_vscode_user_dir)"
  [[ -n "$USER_DIR" ]] || { err "Could not detect a VS Code user dir; pass --user-dir DIR."; exit 1; }
  DEST="$USER_DIR/prompts"
  log "Installing into ${DEST/#$HOME/\~}/ ..."
  copy_glob "$DIST/agents"       "*.agent.md"        "$DEST"
  copy_glob "$DIST/prompts"      "*.prompt.md"       "$DEST"
  copy_glob "$DIST/instructions" "*.instructions.md" "$DEST"   # incl. co-agents.instructions.md (applyTo '**')
  echo ""
  info "If your VS Code version doesn't auto-discover user files, point these settings at"
  info "  ${DEST/#$HOME/\~}/ :  chat.promptFilesLocations, chat.instructionsFilesLocations, chat.agentFilesLocations"
  info "Memory is per-project — run /team-init inside a project to scaffold .coagents/."
else
  # ── Project: install the team tooling into <path>/.github/.
  #    Memory (.coagents/) is created later by /team-init (new) or /team-onboard (existing) —
  #    those build a real, filled-in charter, so we don't pre-scaffold a blank one here.
  [[ -n "$PROJECT" ]] || { err "--project needs a path."; exit 1; }
  [[ -d "$PROJECT" ]] || { err "No such directory: $PROJECT"; exit 1; }
  PROJECT="$(cd "$PROJECT" && pwd)"
  GH="$PROJECT/.github"
  log "Installing the team into ${PROJECT}/.github/ ..."
  copy_glob "$DIST/agents"       "*.agent.md"        "$GH/agents"
  copy_glob "$DIST/prompts"      "*.prompt.md"       "$GH/prompts"
  copy_glob "$DIST/instructions" "team-memory.instructions.md" "$GH/instructions"
  # Preserve any existing copilot-instructions.md — it's the project's, and authoritative.
  if [[ -f "$GH/copilot-instructions.md" ]] && ! $FORCE; then
    warn "keeping your existing .github/copilot-instructions.md (the team will read, not replace it)"
  else
    copy_file "$DIST/copilot-instructions.md" "$GH/copilot-instructions.md"
  fi
  echo ""
  info "No project memory created yet. Inside this repo, run:"
  info "  /team-init      — new project (interview → charter)"
  info "  /team-onboard   — existing project (scan & understand, then build memory)"
fi

echo ""
echo -e "${BOLD}Summary${NC}  copied: $copied   skipped: $skipped"
if $DRY_RUN; then
  info "Dry run — re-run without --dry-run to apply."
else
  echo -e "${GREEN}${BOLD}✓ Installed.${NC}"
  echo -e "Open Copilot Chat, pick the ${BOLD}Maestro${NC} agent (or a specialist), or run ${BOLD}/team-brainstorm${NC}."
fi
