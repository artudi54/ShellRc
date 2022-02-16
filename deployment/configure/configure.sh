#!/bin/bash
export SHELLRC_DIR="$(dirname "$(dirname "$(dirname "$(realpath "$BASH_SOURCE")")")")"
source "$SHELLRC_DIR/lib/lib.sh"
source "$SHELLRC_DIR/components/shell/shell/plugins/paki/paki.plugin.sh"
export -f __script_directory
export -f script_directory
export -f include

echo "[ShellRc] Preconfiguring installation"
"$(script_directory)/preinstall/preinstall.sh" || exit 1
echo "[ShellRc] Preconfiguring installation complete"

echo "[ShellRc] Installing system packages"
"$(script_directory)/packages/packages.sh" || exit 1
echo "[ShellRc] Installing system packages complete"

echo "[ShellRc] Creating backups"
"$(script_directory)/backup/backup.sh" "$SHELLRC_DIR/components" || exit 1
echo "[ShellRc] Creating backups complete"

echo "[ShellRc] Configuring components"
"$(script_directory)/components/components.sh" "$SHELLRC_DIR/components" || exit 1
echo "[ShellRc] Configuring components complete"

echo "[ShellRc] Configuration complete"

