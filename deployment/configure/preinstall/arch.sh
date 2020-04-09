#!/bin/bash
set -e

# Chaotic AUR
if ! grep "http://chaotic.bangl.de" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
    sudo pacman-key --lsign-key 3056513887B78AEB
    echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = http://lonewolf-builder.duckdns.org/\$repo/x86_64" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = http://chaotic.bangl.de/\$repo/x86_64" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://repo.kitsuna.net/x86_64" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# Andontie AUR
if ! grep "https://aur.andontie.net" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --recv-key EA50C866329648EE
    sudo pacman-key --lsign-key EA50C866329648EE
    echo "[andontie-aur]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://aur.andontie.net/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
fi


# Arch4edu
if ! grep "https://arch4edu.keybase.pub" /etc/pacman.conf > /dev/null; then
    sudo pacman-key --recv-keys 7931B6D628C8D3BA
    sudo pacman-key --finger 7931B6D628C8D3BA
    sudo pacman-key --lsign-key 7931B6D628C8D3BA
    echo "[arch4edu]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://arch4edu.keybase.pub/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# Install yay if not present
sudo pacman -Syy
if ! which yay 2>/dev/null 1>&2; then
    sudo pacman -S --noconfirm yay
fi

