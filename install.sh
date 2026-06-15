#!/usr/bin/env bash
set -e
export SHELLRC_DIR="$(cd -- "$(dirname "$BASH_SOURCE")" && pwd)"

source "$SHELLRC_DIR/components/script-sourcing/script-sourcing.sh"
source "$SHELLRC_DIR/components/xdg-dirs/xdg-dirs.sh"

# TODO: make it work with export (-e option for script-sourcing) and just running scripts directly
# TODO: add --skip-backup option for debugging
# TODO: add --core-install and --no-install options

echo "[ShellRc] Installing system packages"
include install/packages.sh
echo "[ShellRc] Installing system packages complete"

echo "[ShellRc] Creating backups"
include /install/backup.sh "$SHELLRC_DIR/components"
echo "[ShellRc] Creating backups complete"

echo "[ShellRc] Configuring components"
include install/components.sh "$SHELLRC_DIR/components"
echo "[ShellRc] Configuring components complete"

echo "[ShellRc] Configuration complete"

