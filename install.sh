#!/bin/bash
set -e
export SHELLRC_DIR="$(dirname "$BASH_SOURCE")"

source "$SHELLRC_DIR/components/script-sourcing/script-sourcing.sh"
source "$SHELLRC_DIR/components/xdg-dirs/xdg-dirs.sh"

# make available for scripts (TODO: add -e option to script-sourcing.sh)
export -f __script_directory
export -f script_directory
export -f include

echo "[ShellRc] Installing system packages"
"$(script_directory)/install/packages.sh" || exit 1
echo "[ShellRc] Installing system packages complete"

echo "[ShellRc] Creating backups"
"$(script_directory)/install/backup.sh" "$SHELLRC_DIR/components" || exit 1
echo "[ShellRc] Creating backups complete"

echo "[ShellRc] Configuring components"
"$(script_directory)/install/components.sh" "$SHELLRC_DIR/components" || exit 1
echo "[ShellRc] Configuring components complete"

echo "[ShellRc] Configuration complete"

