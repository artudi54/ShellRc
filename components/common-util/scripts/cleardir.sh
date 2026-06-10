#!/usr/bin/env bash
# cleardir — clear contents of a directory without removing the directory itself
# Usage: cleardir [directory]

if [[ $# -gt 1 ]]; then
    echo "Usage: $(basename "$0") [directory]" >&2
    exit 1
fi

dir="${1:-.}"

if [[ ! -d "$dir" ]]; then
    echo "cleardir: \"$dir\" is not a directory" >&2
    exit 1
fi

find "$dir" -maxdepth 1 2>/dev/null | tail -n +2 | xargs rm -rf 2>/dev/null
