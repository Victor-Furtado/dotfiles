#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/Victor-Furtado/dotfiles.git"
TMP_DIR="$(mktemp -d)"

log() {
  echo -e "\n==> $1"
}

cleanup() {
  log "Cleaning up"
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

log "Cloning dotfiles repository"
git clone --depth=1 "$REPO_URL" "$TMP_DIR"

log "Running install.sh"
cd "$TMP_DIR"
chmod +x install.sh
./install.sh

log "Bootstrap finished successfully"
