#!/bin/bash
set -e

# If running debian we need to enable non-free repository
if grep "ID=debian" /etc/os-release >/dev/null; then
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository non-free
    sudo apt-get update
fi

