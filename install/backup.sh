#!/usr/bin/env bash
set -e

backup-from-file() {
    local backupList="$1"
    local file
    while read file; do
        file="$(eval echo $file)"
        if [[ -h "$file" || -e "$file" ]]; then
            local relpath="${file#"$HOME/"}"
            local destdir="$BACKUP_DIR/$(dirname "$relpath")"
            mkdir -p "$destdir"
            mv "$file" "$destdir"
        fi
    done < "$backupList"
}

if [[ $# -ne 1 ]]; then
    echo "backup.sh: invalid number of arguments passed" 1>&2
    exit 1
fi

SCAN_DIR="$1"
BACKUP_DIR="$HOME/ShellRcBackups"

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
    backup-from-file "$componentDirectory/backuplist.txt"
done

echo "backups created in '$BACKUP_DIR'"

