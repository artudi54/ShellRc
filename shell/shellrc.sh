# Main entry for shells
# Currently supports bash and zsh

# basic repository variables
if [ -n "$BASH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "$BASH_SOURCE")")"
elif [ -n "$ZSH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "${(%):-%N}")")"
fi

# basic libraries
source "$SHELLRC_DIR/lib/lib.sh"

# shell config
if [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/bash-config.sh"
elif [ -n "$ZSH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/zsh-config.sh"
fi

# components
source "$SHELLRC_DIR/components/components.sh"

# environmental variables
source "$SHELLRC_DIR/shell/environment/environment.sh"

# functions
source "$SHELLRC_DIR/shell/functions/functions.sh"

# aliases
source "$SHELLRC_DIR/shell/aliases/aliases.sh"

# promt settings
source "$SHELLRC_DIR/shell/prompt/prompt.sh"

# plugins
source "$SHELLRC_DIR/shell/plugins/plugins.sh"

# make less more friendly for non-text input files
if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi


#TODO FIX MODULES
