# Main entry for shells
# Currently supports bash and zsh

# basic repository variables
if [ -n "$BASH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "$BASH_SOURCE")")"
elif [ -n "$ZSH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "${(%):-%N}")")"
fi

# shellrc configuration
source "$SHELLRC_DIR/settings.sh"