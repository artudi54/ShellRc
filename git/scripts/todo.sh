#!/bin/bash

if [[ -$# -ne 0 ]]; then
    echo "todo: command takes no arguments" 1>&2
fi

C_BLACK='\e[0;30m'
C_RED='\e[0;31m'
C_GREEN='\e[0;32m'
C_BROWN='\e[0;33m'
C_BLUE='\e[0;34m'
C_PURPLE='\e[0;35m'
C_CYAN='\e[0;36m'
C_LIGHTGRAY='\e[0;37m'
C_NC='\e[0m' # No Color

git grep -inz "todo\|fixme" | while read -d '' -r file && read -d '' -r line && read -d '' -r todo && read; do
    file="${C_PURPLE}$file${C_NC}"
    colon="${C_BLUE}:${C_NC}"
    line="${C_GREEN}$line${C_NC}"
    todo=$(echo "$todo" | xargs | sed 's/.*\(todo\|fixme\)/\1/gI') #format
    printf "$file$colon$line$colon$todo\n"
done

