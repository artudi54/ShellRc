#!/bin/bash
set -e

# gcc-8 repository
if ! apt-cache show '^gcc-8$' 2>/dev/null 1>&2; then
    gcc="/etc/apt/sources.list.d/jonathonf-ubuntu-gcc-8_0-xenial.list"
    binutils="/etc/apt/sources.list.d/jonathonf-ubuntu-binutils-xenial.list"
    key=4AB0F789CBA31744CC7DA76A8CF63AD3F06FC659
    echo "Adding gcc-8 and binutils ppa"
    printf "deb http://ppa.launchpad.net/jonathonf/gcc-8.0/ubuntu xenial main\n# deb-src http://ppa.launchpad.net/jonathonf/gcc-8.0/ubuntu xenial main\n" | sudo tee "$gcc"
    printf "deb http://ppa.launchpad.net/jonathonf/binutils/ubuntu xenial main\n# deb-src http://ppa.launchpad.net/jonathonf/binutils/ubuntu xenial main\n" | sudo tee "$binutils"
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$key" 
    sudo apt-get update
fi
