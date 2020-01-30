#!/bin/bash
DIRECTORY="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

export PATH="$DIRECTORY/lesspipe:$PATH"
"$DIRECTORY/lesspipe/lesspipe.sh" "$@"

