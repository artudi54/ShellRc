#!/bin/bash
set -e

# If running debian we need to enable non-free repository
if grep "ID=debian" /etc/os-release >/dev/null; then
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository non-free
    sudo apt-get update

    if grep "VERSION_ID=\"10\"" /etc/os-release >/dev/null; then
        # Newer cmake for debian 10
        wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
        echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
        sudo apt-get update
        sudo rm /usr/share/keyrings/kitware-archive-keyring.gpg
        sudo apt-get install kitware-archive-keyring
    fi
fi

