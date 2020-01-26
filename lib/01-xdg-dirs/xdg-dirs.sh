# Set all XDG variables so that they are can be assumed to always exist

if [[ ! -v XDG_CONFIG_DIRS ]]; then
    export XDG_CONFIG_DIRS="/etc/xdg"
fi

if [[ ! -v XDG_DATA_DIRS ]]; then
    export XDG_DATA_DIRS="/usr/local/share:/usr/share"
fi

if [[ ! -v XDG_CONFIG_HOME ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
    if [[ ! -d "$XDG_CONFIG_HOME" ]]; then
        mkdir -p "XDG_CONFIG_HOME"
    fi
fi

if [[ ! -v XDG_CACHE_HOME ]]; then
    export XDG_CACHE_HOME="$HOME/.cache"
    if [[ ! -d "$XDG_CACHE_HOME" ]]; then
        mkdir -p "XDG_CACHE_HOME"
    fi
fi

if [[ ! -v XDG_DATA_HOME ]]; then
    export XDG_DATA_HOME="$HOME/.local/share"
    if [[ ! -d "$XDG_DATA_HOME" ]]; then
        mkdir -p "XDG_DATA_HOME"
    fi
fi

