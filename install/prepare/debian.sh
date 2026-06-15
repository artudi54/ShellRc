#!/usr/bin/env bash
set -e

. /etc/os-release
sudo apt-get update

echo "Installing software-properties-common..."
sudo apt-get install -y software-properties-common

if [[ "$ID" == "debian" ]]; then
    echo "Enabling non-free repository..."
    sudo apt-add-repository -y non-free
elif [[ "$ID" == "ubuntu" ]]; then
    echo "Adding PPA repositories..."
    sudo add-apt-repository -y ppa:jonathonf/vim
    sudo add-apt-repository -y ppa:longsleep/golang-backports
fi

sudo apt-get upgrade -y

