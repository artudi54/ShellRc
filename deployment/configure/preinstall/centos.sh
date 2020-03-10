#!/bin/bash
set -e

CENTOS_VER=$(rpm --eval %{centos_ver})
sudo yum install -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm --eval %{centos_ver}).noarch.rpm
sudo yum install -y --nogpgcheck https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-${CENTOS_VER}.noarch.rpm
sudo yum install -y https://centos${CENTOS_VER}.iuscommunity.org/ius-release.rpm
sudo yum install -y http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el${CENTOS_VER}.noarch.rpm
sudo yum --enablerepo=gf-plus update -y

