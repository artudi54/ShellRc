#!/bin/bash

cdc() {
    if [[ ! -d "$@" ]]; then
        mkdir "$@"
    fi
    cd "$@"
}

export-start() {
    export START="$PWD"
}
