#!/usr/bin/env bash
set -e
export SHELLRC_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

while getopts "n:e:" opt; do
    case "$opt" in
        n) export GIT_NAME="$OPTARG" ;;
        e) export GIT_EMAIL="$OPTARG" ;;
        *) echo "Usage: $0 [-n name] [-e email]" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

source "$SHELLRC_DIR/components/script-sourcing/script-sourcing.sh"
source "$SHELLRC_DIR/components/directory-setup/directory-setup.sh"

# TODO: make it work with export (-e option for script-sourcing) and just running scripts directly
# TODO: add --skip-backup option for debugging
# TODO: add --core-install and --no-install options

echo "[ShellRc] Preparing system repositories"
include install/prepare.sh
echo "[ShellRc] Preparing system repositories complete"

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

