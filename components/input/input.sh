# Configuration for custom input keycodes for bash (readline) and zsh (ZLE)

export INPUTRC="$SHELLRC_DIR/components/input/inputrc.sh"

if [[ -v ZSH_VERSION ]]; then
    source "$SHELLRC_DIR/components/input/zle.sh"
fi

