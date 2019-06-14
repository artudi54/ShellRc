#!/bin/bash

if [ $# -ne 1 ]; then
    echo "preconfigure: invalid number of arguments" 1>&2
    exit 1
fi

SHELLRC_DIR=$1

# Platform switch
if [ -f /etc/arch-release ]; then
    :
elif [ -f /etc/centos-release ]; then
    :
elif [ -f /etc/debian_version ]; then
    "$SHELLRC_DIR/configure/postinstall/debian.sh"
elif [ -f /etc/fedora-release ]; then
    :
fi
