# P4 env configuration and bp4o setup

export P4ENVIRO="$XDG_CONFIG_HOME"/p4enviro

if command -v p4 >/dev/null 2>&1; then
    autoload -Uz array-prepend-unique
    array-prepend-unique path "$(script_directory)/bin"
fi

