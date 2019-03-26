#!/bin/bsh
sudo yum localinstall --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm --eval %{centos_ver}).noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm --eval %{centos_ver}).noarch.rpm
sudo yum install -y https://centos$(rpm --eval %{centos_ver}).iuscommunity.org/ius-release.rpm

