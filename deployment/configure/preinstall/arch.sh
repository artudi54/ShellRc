#!/bin/bash
set -e

if ! grep "http://chaotic.bangl.de" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
    sudo pacman-key --lsign-key 3056513887B78AEB
    echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = http://lonewolf-builder.duckdns.org/\$repo/x86_64" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = http://chaotic.bangl.de/\$repo/x86_64" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://repo.kitsuna.net/x86_64" | sudo tee -a /etc/pacman.conf >/dev/null
fi

if ! grep "https://aur.andontie.net" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --recv-key EA50C866329648EE
    sudo pacman-key --lsign-key EA50C866329648EE
    echo "[andontie-aur]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://aur.andontie.net/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
fi

sudo pacman -Syy
if ! which yay 2>/dev/null 1>&2; then
    sudo pacman -S --noconfirm yay
fi

