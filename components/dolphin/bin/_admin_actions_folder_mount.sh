#!/usr/bin/env bash
DIR="$1"

if mountpoint -q "$DIR"; then
    kdialog --error "$DIR is already mounted."
    exit 1
fi

ERR=$(pkexec mount "$DIR" 2>&1)
if [ $? -eq 0 ]; then
    notify-send -i drive-removable-media "Mounted" "$DIR mounted successfully"
else
    kdialog --error "Failed to mount $DIR:\n$ERR"
fi
