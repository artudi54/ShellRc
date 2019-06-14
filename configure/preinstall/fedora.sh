#!/bin/bash
set -e
FEDORA_VER="$(rpm -E %fedora)"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_VER}.noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VER}.noarch.rpm
sudo dnf update -y

