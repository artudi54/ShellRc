#!/usr/bin/env bash
set -e

echo "Updating system"
sudo apt-get update
sudo apt-get upgrade -y

echo "Installing snap"
sudo apt-get install -y snapd

echo "Installing flatpak"
sudo apt-get install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# per os configuration
. /etc/os-release
if [[ "$ID" == "debian" ]]; then
    echo "Enabling non-free repository..."
    if [[ -f /etc/apt/sources.list.d/debian.sources ]]; then
        sudo sed -i 's/^Components:.*$/Components: main contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources
    else
        sudo sed -i 's/main$/main contrib non-free non-free-firmware/' /etc/apt/sources.list
    fi
    sudo apt-get update
elif [[ "$ID" == "ubuntu" ]]; then
    echo "Installing software-properties-common"
    sudo apt-get install -y software-properties-common
    echo "Adding PPA repositories..."
    sudo add-apt-repository -y ppa:longsleep/golang-backports
fi

