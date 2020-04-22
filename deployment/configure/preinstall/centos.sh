#!/bin/bash
set -e

CENTOS_VER=$(rpm --eval %{centos_ver})

# RPM fusion
sudo yum install -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm --eval %{centos_ver}).noarch.rpm
sudo yum install -y --nogpgcheck https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-${CENTOS_VER}.noarch.rpm

# EPEL
sudo yum install epel-release dnf

# Trinity
sudo yum install -y --nogpgcheck http://mirror.ppa.trinitydesktop.org/trinity/trinity/rpm/el${CENTOS_VER}/trinity-r14/RPMS/noarch/trinity-repo-14.0.7-1.el${CENTOS_VER}.noarch.rpm


# Install snap if not present
if ! which snap 2>/dev/null 1>&2; then
    paki install -y snapd
    sudo systemctl enable --now snapd.socket
fi
# Enable snap classic support
[[ -d /snap ]] || sudo ln -s /var/lib/snapd/snap /snap


# Install flatpak if not present
if ! which flatpak 2>/dev/null 1>&2; then
    paki install -y flatpak
fi
