#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Error - no commit message provided" 1>&2
    exit 1
fi

git add -A
git commit -m "$@"
git push
