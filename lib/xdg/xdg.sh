# Set all XDG variables so that they are not empty

if [[ ! -v XDG_CONFIG_DIRS ]]; then
    readonly XDG_CONFIG_DIRS="/etc/xdg"
    export XDG_CONFIG_DIRS
fi

if [[ ! -v XDG_DATA_DIRS ]]; then
    readonly XDG_DATA_DIRS="/usr/local/share:/usr/share"
    export XDG_DATA_DIRS
fi

if [[ ! -v XDG_CONFIG_HOME ]]; then
    readonly XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CONFIG_HOME
    if [[ ! -d "$XDG_CONFIG_HOME" ]]; then
        mkdir -p "XDG_CONFIG_HOME"
    fi
fi

if [[ ! -v XDG_CACHE_HOME ]]; then
    readonly XDG_CACHE_HOME="$HOME/.cache"
    export XDG_CACHE_HOME
    if [[ ! -d "$XDG_CACHE_HOME" ]]; then
        mkdir -p "XDG_CACHE_HOME"
    fi
fi

if [[ ! -v XDG_DATA_HOME ]]; then
    readonly XDG_DATA_HOME="$HOME/.local/share"
    export XDG_DATA_HOME
    if [[ ! -d "$XDG_DATA_HOME" ]]; then
        mkdir -p "XDG_DATA_HOME"
    fi
fi

