#!/bin/sh
sudo yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm --eval %{centos_ver}).noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm --eval %{centos_ver}).noarch.rpm
sudo yum install -y https://centos$(rpm --eval %{centos_ver}).iuscommunity.org/ius-release.rpm
sudo rpm -Uvh http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el$(rpm --eval %{centos_ver}).noarch.rpm
sudo yum --enablerepo=gf-plus update -y

