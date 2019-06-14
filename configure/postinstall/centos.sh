#!/bin/bash
set -e

if [ ! -f /usr/bin/python3 ]; then
    if [ -f /usr/bin/python3.7 ]; then
        VER="3.7"
    elif [ -f /usr/bin/python3.6 ]; then
        VER="3.6"
    fi
    if [ -z "$VER" ]; then
        echo "Could not find python executable" 1>&2
    fi
    ln -s /usr/bin/python3.7 /usr/bin/python3
fi

