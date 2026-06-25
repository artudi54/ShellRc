# interactive shell only
[[ $- != *i* ]] && return

# disable ctrl-s
stty -ixon

# per shell config
if [ -n "$BASH_VERSION" ]; then
    # check the window size after each command and, if necessary
    shopt -s checkwinsize

    # extended globbing
    shopt -s globstar
    shopt -s nocaseglob
elif [ -n "$ZSH_VERSION" ]; then
    # extended globbing
    setopt extendedglob
    setopt +o nomatch

    #help
    autoload -Uz run-help
fi

include "history.sh"
include "terminal-inputs.sh"

