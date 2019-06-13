#!/bin/bash

# gcc-8 repository
if ! apt-cache show '^gcc-8$' 2>/dev/null 1>&2; then
    file="/etc/apt/sources.list.d/jonathonf-ubuntu-gcc-8_0-xenial.list"
    echo "Adding gcc-8 ppa"
    printf "deb http://ppa.launchpad.net/jonathonf/gcc-8.0/ubuntu xenial main\n# deb-src http://ppa.launchpad.net/jonathonf/gcc-8.0/ubuntu xenial main\n" | sudo tee "$file"
    sudo apt-get update
fi
