#!/usr/bin/env bash
set -e

. /etc/os-release
sudo apt-get update

if [[ "$ID" == "debian" ]]; then
    echo "Enabling non-free repository..."
    sudo apt-add-repository -y non-free
elif [[ "$ID" == "ubuntu" ]]; then
    echo "Installing software-properties-common..."
    sudo apt-get install -y software-properties-common
    echo "Adding PPA repositories..."
    sudo add-apt-repository -y ppa:jonathonf/vim
    sudo add-apt-repository -y ppa:longsleep/golang-backports
fi

sudo apt-get upgrade -y

