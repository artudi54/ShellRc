#!/bin/bash

exists() {
    if which "$1" 2>&1 1>/dev/null; then
        return 0
    else
        return 1
    fi
}

if exists apt; then
    sudo apt install -y $(cat install.txt)
elif exists aptitude; then
    sudo aptitude install -y $(cat install.txt)
elif exists apt-get; then
    sudo apt-get install -y $(cat install.txt)
elif exists dnf; then
    sudo dnf install -y $(cat install.txt)
elif exists yum; then
    sudo yum install -y $(cat install.txt)
elif exists pacman; then
    sudo pacman -Sy $(cat install.txt)
fi

