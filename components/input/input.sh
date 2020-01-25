# Configuration for custom input keycodes for bash (readline) and zsh (ZLE)

export INPUTRC="$(script-directory)/inputrc.sh"

if [[ -v ZSH_VERSION ]]; then
    include "zle.sh"
fi

