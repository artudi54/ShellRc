#!/bin/bash
set -e

gcc_version=$(gcc -dumpversion)
if [ "${gcc_version:0:1}" -lt 8 ]; then
    # Clean g++ and gcc alternatives
    if update-alternatives --query gcc 2>/dev/null 1>&2; then
        sudo update-alternatives --remove-all gcc 
    fi
    if update-alternatives --query g++ 2>/dev/null 1>&2; then
        sudo update-alternatives --remove-all g++
    fi

    # Install alternatives
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 20
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 20

    # Configure cc and c++
    sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
    sudo update-alternatives --set cc /usr/bin/gcc
    sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
    sudo update-alternatives --set c++ /usr/bin/g++
fi

