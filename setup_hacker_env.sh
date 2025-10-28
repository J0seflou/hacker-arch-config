#!/usr/bin/env bash
set -euo pipefail

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME/config_backup_$TIMESTAMP"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_CONF="$REPO_DIR/.config"
DEST_CONF="$HOME/.config"

echo ">>> Repo detected in: $REPO_DIR"
echo ">>> Source configs: $SRC_CONF"
echo

if [ -d "$DEST_CONF" ]; then
  echo ">>> Backup: moving existing ~/.config to $BACKUP_DIR"
  mv "$DEST_CONF" "$BACKUP_DIR"
else
  echo ">>> No existing ~/.config found — no backup needed"
fi

mkdir -p "$DEST_CONF"
mkdir -p "$HOME/.local/share/backgrounds"
mkdir -p "$HOME/.local/bin"

if [ -d "$SRC_CONF" ]; then
  echo ">>> Copying config files from repo to ~/.config"
  if command -v rsync >/dev/null 2>&1; then
    rsync -av --no-perms --chmod=ugo=rwX "$SRC_CONF"/ "$DEST_CONF"/
  else
    cp -r "$SRC_CONF"/* "$DEST_CONF"/
  fi
  echo ">>> Copy complete."
else
  echo ">>> ERROR: source .config not found inside repo at $SRC_CONF"
  exit 1
fi

echo
echo ">>> Created: $DEST_CONF"
echo ">>> Created: $HOME/.local/share/backgrounds and $HOME/.local/bin"
echo
echo ">>> NOTA: Este script ligero no instala paquetes. Para la versión completa dímelo y te la doy."
