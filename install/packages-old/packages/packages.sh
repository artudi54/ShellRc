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

commonCli="$(script_directory)/cli/system.txt"
commonGui="$(script_directory)/gui/system.txt"
commonDriverish="$(script_directory)/driverish/system.txt"
specialCli="$(script_directory)/cli/system-$arch.txt"
specialGui="$(script_directory)/gui/system-$arch.txt"
specialDriverish="$(script_directory)/driverish/system-$arch.txt"

snap="$(script_directory)/snap/snap.txt"
flatpak="$(script_directory)/flatpak/flatpak.txt"

# TODO FIX FOR ARCH add yes option
paki install $(cat "$commonCli" "$commonGui" "$commonDriverish" "$specialCli" "$specialGui" "$specialDriverish")

for entry in $(cat "$snap"); do
    sudo snap install --classic $entry
done

sudo flatpak install -y $(cat "$flatpak")

