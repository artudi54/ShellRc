#!/bin/bash

exists() {
    if which "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

common="$(script-directory)/cli/system.txt"

if exists apt-get; then
    paki install -y $(cat "$common" "$(script-directory)/cli/system-debian.txt")
elif exists dnf; then
    paki install -y $(cat "$common" "$(script-directory)/cli/fedora/system-fedora.txt")
elif exists yum; then
    paki install -y $(cat "$common" "$(script-directory)/cli/system-centos.txt")
elif exists yay; then
    # TODO: fix in paki
    paki install --noconfirm $(cat "$common" "$(script-directory)/cli/system-arch.txt")
else
    echo "$0: no suitable package manager for installing dependencies found" 1>&2
    return 1
fi
