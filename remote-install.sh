#!/usr/bin/env bash
set -euo pipefail

# ─── Co-Agents Remote Installer ──────────────────────────────────────────────
# Installs co-agents into a project without cloning the full repo.
# Uses git clone --depth 1 so it works with both public and private repos.
#
# Usage:
#   bash remote-install.sh <target-project-path> [options]
#
# All options from install.sh are supported: --dry-run, --force, --no-memory
# Additional options:
#   --ssh             Clone via SSH instead of HTTPS
# ─────────────────────────────────────────────────────────────────────────────

REPO_HTTPS="https://github.com/mohamed-abdelsamei/co-agents.git"
REPO_SSH="git@github.com:mohamed-abdelsamei/co-agents.git"
USE_SSH=false
ARGS=()

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

error() { echo -e "${RED}✗${NC} $*" >&2; }
log()   { echo -e "${GREEN}→${NC} $*"; }
info()  { echo -e "${BLUE}ℹ${NC} $*"; }

# ─── Parse --ssh, pass everything else through ───────────────────────────────

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ssh)
      USE_SSH=true
      shift
      ;;
    *)
      ARGS+=("$1")
      shift
      ;;
  esac
done

if [[ ${#ARGS[@]} -eq 0 ]]; then
  echo -e "${BOLD}Co-Agents Remote Installer${NC}"
  echo ""
  echo "Usage:"
  echo "  bash remote-install.sh <target-project-path> [options]"
  echo ""
  echo "Options:"
  echo "  --ssh              Clone via SSH instead of HTTPS"
  echo "  --dry-run          Preview changes without applying"
  echo "  --force            Overwrite existing files"
  echo "  --no-memory        Skip .co-agents/ skeleton"
  echo "  --help             Show install.sh help"
  echo ""
  echo "More info: https://github.com/mohamed-abdelsamei/co-agents"
  exit 0
fi

# ─── Clone and install ───────────────────────────────────────────────────────

if $USE_SSH; then
  REPO_URL="$REPO_SSH"
else
  REPO_URL="$REPO_HTTPS"
fi

TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

log "Cloning co-agents (main)..."
if ! git clone --depth 1 --branch main "$REPO_URL" "$TMP_DIR/co-agents"; then
  error "Failed to clone from $REPO_URL"
  error "Make sure you have access to the repo."
  if ! $USE_SSH; then
    info "Tip: If using a private repo, try --ssh or configure a GitHub credential helper."
  fi
  exit 1
fi

if [[ ! -f "$TMP_DIR/co-agents/install.sh" ]]; then
  error "install.sh not found in cloned repo"
  exit 1
fi

# ─── Run the installer ───────────────────────────────────────────────────────

chmod +x "$TMP_DIR/co-agents/install.sh"
log "Running installer..."
echo ""
bash "$TMP_DIR/co-agents/install.sh" "${ARGS[@]}"
