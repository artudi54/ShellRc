#!/bin/bash

exists() {
    if which "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# platform switch
if [ -f /etc/arch-release ]; then
    arch=arch
elif [ -f /etc/centos-release ]; then
    arch=centos
elif [ -f /etc/debian_version ]; then
    arch=debian
elif [ -f /etc/fedora-release ]; then
    arch=fedora
else
    echo "$0: couldn't recognize linux distribution" 1>&2
    return 1
fi

commonCli="$(script-directory)/cli/system.txt"
commonGui="$(script-directory)/gui/system.txt"
commonDriverish="$(script-directory)/driverish/system.txt"
specialCli="$(script-directory)/cli/system-$arch.txt"
specialGui="$(script-directory)/gui/system-$arch.txt"
specialDriverish="$(script-directory)/driverish/system-$arch.txt"

# TODO FIX FOR ARCH add yes option
paki install $(cat "$commonCli" "$commonGui" "$commonDriverish" "$specialCli" "$specialGui" "$specialDriverish")

