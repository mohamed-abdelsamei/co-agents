#!/usr/bin/env bash
set -euo pipefail

# ─── Co-Agents Installer ─────────────────────────────────────────────────────
# Installs the co-agents workflow into an existing project.
#
# Usage:
#   ./install.sh <target-project-path> [options]
#
# Options:
#   --dry-run     Show what would happen without making changes
#   --force       Overwrite existing files (default: skip)
#   --no-memory   Skip creating .co-agents/ skeleton
#   --help        Show this help message
# ─────────────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_GITHUB="$SCRIPT_DIR/.github"
SOURCE_MEMORY="$SCRIPT_DIR/.co-agents"

DRY_RUN=false
FORCE=false
SKIP_MEMORY=false
TARGET=""

# ─── Colors ───────────────────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log()   { echo -e "${GREEN}→${NC} $*"; }
warn()  { echo -e "${YELLOW}⚠${NC} $*"; }
error() { echo -e "${RED}✗${NC} $*" >&2; }
info()  { echo -e "${BLUE}ℹ${NC} $*"; }
dry()   { echo -e "${YELLOW}[dry-run]${NC} $*"; }

# ─── Usage ────────────────────────────────────────────────────────────────────

usage() {
  cat <<EOF
${BOLD}Co-Agents Installer${NC}

Install the co-agents SDLC workflow into an existing project.

${BOLD}Usage:${NC}
  $(basename "$0") <target-project-path> [options]

${BOLD}Options:${NC}
  --dry-run     Show what would happen without making changes
  --force       Overwrite existing files (default: skip existing)
  --no-memory   Skip creating .co-agents/ skeleton
  --help        Show this help message

${BOLD}What gets installed:${NC}
  .github/agents/           4 custom agents (architect, engineer, reviewer, researcher)
  .github/prompts/          13 prompt files (/co-specify, /co-plan, /co-implement, etc.)
  .github/instructions/     Project memory format standards + before-acting rules
  .github/skills/           Workflow skills (co-memory)
  .github/copilot-instructions.md   Main copilot configuration
  .co-agents/               Project memory skeleton (constitution, decisions, etc.)

${BOLD}Examples:${NC}
  $(basename "$0") ~/Work/my-app
  $(basename "$0") ~/Work/my-app --dry-run
  $(basename "$0") ~/Work/my-app --force
  $(basename "$0") ~/Work/my-app --no-memory

${BOLD}After installation:${NC}
  1. Edit .github/copilot-instructions.md to match the project's stack
  2. Run /co-init to scan the codebase and populate project memory
  3. Run /co-constitution to define project principles
EOF
  exit 0
}

# ─── Parse Args ───────────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
  case "$1" in
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
    cp "$src" "$dest"
  fi
  copied=$((copied + 1))
}

copy_dir_contents() {
  local src_dir="$1"
  local dest_dir="$2"
  local pattern="${3:-*}"

  ensure_dir "$dest_dir"

  for src_file in "$src_dir"/$pattern; do
    [[ -f "$src_file" ]] || continue
    local filename
    filename="$(basename "$src_file")"
    copy_file "$src_file" "$dest_dir/$filename"
  done
}

# ─── Preflight ────────────────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Co-Agents Installer${NC}"
echo -e "Source: ${BLUE}$SCRIPT_DIR${NC}"
echo -e "Target: ${BLUE}$TARGET${NC}"
$DRY_RUN && echo -e "Mode:   ${YELLOW}dry-run${NC}" || echo -e "Mode:   ${GREEN}install${NC}"
$FORCE && echo -e "Force:  ${YELLOW}overwrite existing files${NC}"
echo ""

# ─── Verify source files exist ───────────────────────────────────────────────

if [[ ! -d "$SOURCE_GITHUB/agents" ]]; then
  error "Source agents directory not found: $SOURCE_GITHUB/agents"
  exit 1
fi

if [[ ! -d "$SOURCE_GITHUB/prompts" ]]; then
  error "Source prompts directory not found: $SOURCE_GITHUB/prompts"
  exit 1
fi

if [[ ! -d "$SOURCE_GITHUB/skills" ]]; then
  error "Source skills directory not found: $SOURCE_GITHUB/skills"
  exit 1
fi

if [[ ! -d "$SOURCE_GITHUB/instructions" ]]; then
  error "Source instructions directory not found: $SOURCE_GITHUB/instructions"
  exit 1
fi

if [[ ! -f "$SOURCE_GITHUB/copilot-instructions.md" ]]; then
  error "Source copilot-instructions.md not found: $SOURCE_GITHUB/copilot-instructions.md"
  exit 1
fi

# ─── Install ──────────────────────────────────────────────────────────────────

log "Installing agents..."
copy_dir_contents "$SOURCE_GITHUB/agents" "$TARGET/.github/agents" "*.agent.md"

log "Installing prompts..."
copy_dir_contents "$SOURCE_GITHUB/prompts" "$TARGET/.github/prompts" "*.prompt.md"

log "Installing instructions..."
copy_dir_contents "$SOURCE_GITHUB/instructions" "$TARGET/.github/instructions" "*.instructions.md"

log "Installing skills..."
for skill_dir in "$SOURCE_GITHUB/skills"/*/; do
  skill_name="$(basename "$skill_dir")"
  copy_dir_contents "$skill_dir" "$TARGET/.github/skills/$skill_name"
done

log "Installing copilot-instructions.md..."
copy_file "$SOURCE_GITHUB/copilot-instructions.md" "$TARGET/.github/copilot-instructions.md"

# ─── Project Memory Skeleton ─────────────────────────────────────────────────

if ! $SKIP_MEMORY; then
  log "Setting up project memory..."

  MEMORY_DIR="$TARGET/.co-agents"
  ensure_dir "$MEMORY_DIR"

  # Copy template files
  for template in constitution.md decisions.md architecture.md improvements.md; do
    if [[ -f "$SOURCE_MEMORY/$template" ]]; then
      copy_file "$SOURCE_MEMORY/$template" "$MEMORY_DIR/$template"
    fi
  done

  # Create subdirectories with .gitkeep
  for subdir in requirements tasks reviews research experiments; do
    ensure_dir "$MEMORY_DIR/$subdir"
    local_gitkeep="$MEMORY_DIR/$subdir/.gitkeep"
    if [[ ! -f "$local_gitkeep" ]]; then
      if $DRY_RUN; then
        dry "touch $(rel_path "$local_gitkeep")"
      else
        touch "$local_gitkeep"
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
  echo "  2. Edit .github/copilot-instructions.md to match your project's stack"
  echo "  3. Run /co-init to scan the codebase and populate project memory"
  echo "  4. Run /co-constitution to define project principles"
  echo ""
fi
