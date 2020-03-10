# Main entry for shells
# Currently supports bash and zsh

# basic repository variables
if [ -n "$BASH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$BASH_SOURCE")"
elif [ -n "$ZSH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "${(%):-%N}")"
fi

# basic libraries
source "$SHELLRC_DIR/lib/lib.sh"

# components
source "$SHELLRC_DIR/components/components.sh"

