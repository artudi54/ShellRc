# Main entry for shells
# Currently supports bash and zsh

# basic repository variables
if [ -n "$BASH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "$BASH_SOURCE")")"
elif [ -n "$ZSH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "${(%):-%N}")")"
fi

# shellrc configuration
source "$SHELLRC_DIR/settings.conf"

# dependencies
source "$SHELLRC_DIR/shell/depends/depends.sh"

# environmental variables
source "$SHELLRC_DIR/shell/environment/environment.sh"

# functions
source "$SHELLRC_DIR/shell/functions/functions.sh"

# aliases
source "$SHELLRC_DIR/shell/aliases/aliases.sh"

# promt settings
source "$SHELLRC_DIR/shell/prompt/prompt.sh"

if [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/bash-config.sh"
elif [ -n "$ZSH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/zsh-config.sh"
fi

# input codes
source "$SHELLRC_DIR/input/input.sh"

# screen functions
source "$SHELLRC_DIR/screen/screen.sh"

# plugins
source "$SHELLRC_DIR/shell/plugins/plugins.sh"

# make less more friendly for non-text input files
if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi


#TODO FIX MODULES
