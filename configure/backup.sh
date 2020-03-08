#!/bin/bash


backup-from-file() {
    local backuplist="$1"
}

if [[ $# -ne 1 ]]; then
    echo "backup: invalid number of arguments passed" 1>&2
    exit 1
fi

SCAN_DIR="$1"
BACKUP_DIR="$HOME/ShellrcBackups"

if [[ -e "$BACKUP_DIR" ]]; then
    echo "backup: backup directory already exists - '$BACKUP_DIR'" 1>&2
    exit 2
fi

for componentDirectory in "$SCAN_DIR"/*; do
    if [[ ! -f "$componentDirectory/backuplist.txt" ]]; then
        continue
    fi
    componentName=$(basename "$componentDirectory")
    echo "backing up $componentName"
done
