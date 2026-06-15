#!/usr/bin/env bash
set -e

echo "Updating system"
sudo apt-get update
sudo apt-get upgrade -y

echo "Installing snap"
sudo apt install -y snapd

echo "Installing flatpak"
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Installing software-properties-common"
sudo apt-get install -y software-properties-common

# per os configuration
. /etc/os-release
if [[ "$ID" == "debian" ]]; then
    echo "Enabling non-free repository..."
    sudo apt-add-repository -y non-free
elif [[ "$ID" == "ubuntu" ]]; then
    echo "Adding PPA repositories..."
    sudo add-apt-repository -y ppa:jonathonf/vim
    sudo add-apt-repository -y ppa:longsleep/golang-backports
fi

