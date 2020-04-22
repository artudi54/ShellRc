#!/bin/bash
set -e

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

# Update system
#TODO move WSL case to paki or wait for WSL2
if grep -qE "(Microsoft|WSL)" /proc/version &>/dev/null; then
    paki update -ys
else
    paki update -y
fi


# Install snap if not present
if ! which snap 2>/dev/null 1>&2; then
    paki install -y snapd
    sudo systemctl enable --now snapd.socket
fi
# Enable snap classic support
[[ -d /snap ]] || sudo ln -s /var/lib/snapd/snap /snap


# Install flatpak if not present
if ! which flatpak 2>/dev/null 1>&2; then
    paki install -y flatpak
fi
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

