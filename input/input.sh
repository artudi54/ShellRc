# Configuration for custom input keycodes for bash (readline) and zsh (ZLE)

export INPUTRC="$SHELLRC_DIR/input/inputrc.sh"

source "$SHELLRC_DIR/input/common.sh"

if [ -n "$ZSH_VERSION" ]; then
    source "$SHELLRC_DIR/input/zle.sh"
fi

