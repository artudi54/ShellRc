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
if ! grep "https://arch4edu.keybase.pub" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --recv-keys 7931B6D628C8D3BA
    sudo pacman-key --finger 7931B6D628C8D3BA
    sudo pacman-key --lsign-key 7931B6D628C8D3BA
    echo "[arch4edu]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://arch4edu.keybase.pub/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# Disastrous AUR
if ! grep "https://mirror.repohost.de" /etc/pacman.conf >/dev/null; then
    sudo pacman-key --recv-keys CBAE582A876533FD
    sudo pacman-key --lsign-key CBAE582A876533FD
    echo "[disastrousaur]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://mirror.repohost.de/\$repo/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
fi

# Chinese Community
if ! grep "https://repo.archlinuxcn.org" /etc/pacman.conf >/dev/null; then
    echo "[archlinuxcn]" | sudo tee -a /etc/pacman.conf >/dev/null
    echo "Server = https://repo.archlinuxcn.org/\$arch" | sudo tee -a /etc/pacman.conf >/dev/null
    sudo pacman -Syy && sudo pacman -S archlinuxcn-keyring
fi

paki update-get

# Install yay if not present
if ! which yay 2>/dev/null 1>&2; then
    #TODO fix for arch
    paki install --noconfirm yay
fi


# Install snap if not present
if ! which snap 2>/dev/null 1>&2; then
    #TODO fix for arch
    paki install  --noconfirm snapd
    sudo systemctl enable --now snapd.socket
fi
# Enable snap classic support
[[ ! -d /snap ]] && sudo ln -s /var/lib/snapd/snap /snap

