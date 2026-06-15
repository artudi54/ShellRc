#!/usr/bin/env bash
set -e

echo "Configuring pacman keyring"
sudo pacman-key --init

echo "Installing build utils"
sudo pacman -S --needed --noconfirm git base-devel

echo "Installing yay"
(
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    cd "$tmpdir/yay"
    makepkg -si --noconfirm
)

echo "Installing snap"
yay -S --noconfirm snapd
sudo systemctl enable --now snapd.socket
sudo systemctl enable --now snapd.apparmor.service
[[ ! -d /var/lib/snapd/snap ]] && sudo ln -s /var/lib/snapd/snap /snap

echo "Installing flatpak"
yay -S --noconfirm flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

