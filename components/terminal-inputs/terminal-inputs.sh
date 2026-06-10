# Configuration for custom input keycodes for bash (readline) and zsh (ZLE)
[[ $- != *i* ]] && return

if [[ -v ZSH_VERSION ]]; then
    include "zle.sh"
else
    include "readline.sh"
fi

