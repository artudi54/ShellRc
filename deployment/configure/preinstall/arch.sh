#!/bin/bash
set -e
sudo pacman-key --init

# Chaotic AUR
if ! grep "chaotic-mirrorlist" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --keyserver keyserver.ubuntu.com -r 3056513887B78AEB
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-'{keyring,mirrorlist}'.pkg.tar.zst'
    echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# Andontie AUR
if ! grep "https://aur.andontie.net" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --recv-key B545E9B7CD906FE3
    sudo pacman-key --lsign-key B545E9B7CD906FE3
    echo "[andontie-aur]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://aur.andontie.net/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# Arch4edu
if ! grep "https://arch4edu.keybase.pub" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --recv-keys 7931B6D628C8D3BA
    sudo pacman-key --finger 7931B6D628C8D3BA
    sudo pacman-key --lsign-key 7931B6D628C8D3BA
    echo "[arch4edu]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://arch4edu.keybase.pub/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# Chinese Community
if ! grep "https://repo.archlinuxcn.org" /etc/pacman.conf >/dev/null; then
    echo "[archlinuxcn]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://repo.archlinuxcn.org/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
    sudo pacman -Syy --noconfirm && sudo pacman -S --noconfirm archlinuxcn-keyring
fi


# User Repository
if ! grep "https://userrepository.eu" /etc/pacman.conf >/dev/null; then
    echo "[userrepository]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://userrepository.eu" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "SigLevel = Optional TrustAll" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# BlackArch
if ! grep "/etc/pacman.d/blackarch-mirrorlist" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --keyserver keyserver.ubuntu.com -r 4345771566D76038C7FEB43863EC0ADBEA87E4E3
    sudo pacman-key --keyserver keyserver.ubuntu.com --lsign-key 4345771566D76038C7FEB43863EC0ADBEA87E4E3
    sudo pacman -U --noconfirm "https://www.blackarch.org/keyring/blackarch-keyring.pkg.tar.xz"
    sudo curl -s "https://blackarch.org/blackarch-mirrorlist" -o "/etc/pacman.d/blackarch-mirrorlist"
    echo "[blackarch]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Include = /etc/pacman.d/blackarch-mirrorlist" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# miffe
if ! grep "https://arch.miffe.org/" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --keyserver keyserver.ubuntu.com -r 313F5ABD
    sudo pacman-key --lsign-key 313F5ABD
    echo "[miffe]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://arch.miffe.org/\$arch/" | sudo tee -a /etc/pacman.conf >/dev/null
fi

sudo pacman -Syy --noconfirm

# Install yay if not present
if ! which yay 2>/dev/null 1>&2; then
    pacman -S --noconfirm yay
fi
