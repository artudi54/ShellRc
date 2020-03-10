#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "install: invalid number of arguments passed" 1>&2
    exit 1
fi

SCAN_DIR="$1"

for componentDirectory in "$SCAN_DIR"/*; do
    if [[ ! -f "$componentDirectory/install.sh" ]]; then
        continue
    fi
    componentName=$(basename "$componentDirectory")
    echo "installing config for $componentName"
    source "$componentDirectory/install.sh"
    echo "installed config for  $componentName"
done
