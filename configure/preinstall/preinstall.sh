#!/bin/bash
set -e

if [ $# -ne 1 ]; then
    echo "preconfigure: invalid number of arguments" 1>&2
    exit 1
fi

SHELLRC_DIR=$1

# Update system
if grep -qE "(Microsoft|WSL)" /proc/version &>/dev/null; then
    $SHELLRC_DIR/shell/plugins/paki/paki/bin/paki update -ys
else
    $SHELLRC_DIR/shell/plugins/paki/paki/bin/paki update -y
fi

# Platform switch
if [ -f /etc/arch-release ]; then
    "$SHELLRC_DIR/configure/preinstall/arch.sh"
elif [ -f /etc/centos-release ]; then
    "$SHELLRC_DIR/configure/preinstall/centos.sh"
elif [ -f /etc/debian_version ]; then
    "$SHELLRC_DIR/configure/preinstall/debian.sh"
elif [ -f /etc/fedora-release ]; then
    "$SHELLRC_DIR/configure/preinstall/fedora.sh"
fi
