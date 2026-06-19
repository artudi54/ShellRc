#!/bin/bash

install_cmd='~/.config/ShellRc/install.sh -n testuser -e testuser@example.com'

if [[ $# -gt 0 ]]; then
    printf -v quoted_args '%q ' "$@"
    exec runuser -l shelluser -c "$install_cmd && exec $quoted_args"
else
    exec runuser -l shelluser -c "$install_cmd"
fi

