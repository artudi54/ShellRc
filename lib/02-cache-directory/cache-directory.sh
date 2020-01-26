# Setup cache directory for ShellRc

export SHELLRC_CACHE_DIR="$XDG_CACHE_HOME/ShellRc"
if [[ ! -d "$SHELLRC_CACHE_DIR" ]]; then
    mkdir "$SHELLRC_CACHE_DIR"
fi

