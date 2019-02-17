# Main entry for shells
# Currently supports bash and zsh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# basic repository variables
if [ -n "$BASH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "$BASH_SOURCE")")"
elif [ -n "$ZSH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "${(%):-%N}")")"
fi

# shellrc configuration
source "$SHELLRC_DIR/settings.conf"

# plugins
source "$SHELLRC_DIR/shell/plugins/plugins.sh"

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

# screen functions
source "$SHELLRC_DIR/screen/screen_profiles.sh"


# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
