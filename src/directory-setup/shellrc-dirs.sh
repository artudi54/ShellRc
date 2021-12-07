# Setup cache and data directories for ShellRc

export SHELLRC_CACHE_DIR="$XDG_CACHE_HOME/ShellRc"
if [[ ! -d "$SHELLRC_CACHE_DIR" ]]; then
    mkdir "$SHELLRC_CACHE_DIR"
fi

export SHELLRC_DATA_DIR="$XDG_DATA_HOME/ShellRc"
if [[ ! -d "$SHELLRC_DATA_DIR" ]]; then
    mkdir "$SHELLRC_DATA_DIR"
fi
