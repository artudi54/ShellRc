#!/usr/bin/env bash
# _unmount-here.sh

DIR="$1"

if ! mountpoint -q "$DIR"; then
    kdialog --error "$DIR is not a mountpoint."
    exit 1
fi

ERR=$(pkexec umount "$DIR" 2>&1)
if [ $? -eq 0 ]; then
    notify-send -i media-eject "Unmounted" "$DIR unmounted successfully"
else
    kdialog --error "Failed to unmount $DIR:\n$ERR"
fi
