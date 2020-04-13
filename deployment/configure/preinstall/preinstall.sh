#!/bin/bash
set -e

# Update system
#TODO move WSL case to paki or wait for WSL2
if grep -qE "(Microsoft|WSL)" /proc/version &>/dev/null; then
    paki update -ys
else
    paki update -y
fi

# platform switch
if [ -f /etc/arch-release ]; then
    "$(script-directory)/arch.sh"
elif [ -f /etc/centos-release ]; then
    "$(script-directory)/centos.sh"
elif [ -f /etc/debian_version ]; then
    "$(script-directory)/debian.sh"
elif [ -f /etc/fedora-release ]; then
    "$(script-directory)/fedora.sh"
else
    echo "$0: couldn't recognize linux distribution" 1>&2
    return 1
fi
