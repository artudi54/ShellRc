#!/bin/bash

check-mv() {
    if [ -h "$1" ] || [ -e "$1" ]; then
        mv "$1" "$2"
    fi
}

backup-from-file() {
    local backupList="$1"
    local component="$2"
    mkdir -p "$BACKUP_DIR/$component"
    local file
    while read file; do
        file="$(eval echo $file)"
        check-mv "$file" "$BACKUP_DIR/$component"
    done < "$backupList"
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
    backup-from-file "$componentDirectory/backuplist.txt" "$componentName"
done

