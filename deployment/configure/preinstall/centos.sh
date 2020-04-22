#!/bin/bash
set -e

if ! which dnf 2>/dev/null 1>&2; then
    sudo yum install -y dnf
fi

CENTOS_VER=$(rpm --eval %{centos_ver})

# RPM fusion
sudo dnf install -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm --eval %{centos_ver}).noarch.rpm
sudo dnf install -y --nogpgcheck https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-${CENTOS_VER}.noarch.rpm

# EPEL
sudo dnf install -y epel-release
if [ $CENTOS_VER -eq 8 ]; then 
    sudo dnf config-manager --set-enabled PowerTools
fi

# Trinity
sudo dnf install -y --nogpgcheck http://mirror.ppa.trinitydesktop.org/trinity/trinity/rpm/el${CENTOS_VER}/trinity-r14/RPMS/noarch/trinity-repo-14.0.7-1.el${CENTOS_VER}.noarch.rpm

