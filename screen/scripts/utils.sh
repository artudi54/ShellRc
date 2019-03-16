#!/bin/bash

cdc() {
    if [[ ! -d "$@" ]]; then
        mkdir "$@"
    fi
    cd "$@"
}

