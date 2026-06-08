#  _____  _            _  _ ______
# /  ___|| |          | || || ___ \
# \ `--. | |__    ___ | || || |_/ /  ___
#  `--. \| '_ \  / _ \| || ||    /  / __|
# /\__/ /| | | ||  __/| || || |\ \ | (__
# \____/ |_| |_| \___||_||_|\_| \_| \___|


# Main entry for shells
# Currently supports bash and zsh

# ShellRc root directory environmental variable
if [ -n "$BASH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$BASH_SOURCE")"
elif [ -n "$ZSH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "${(%):-%N}")"
fi

# Core setup for all components
source "$SHELLRC_DIR/src/src.sh"

# Components configuration
include "components/components.sh"

