# Shell configuration setup for ShellRc

# Set environment file variable
export SHELLRC_ENVIRONMENT="$SHELLRC_DIR/personal/environment.conf"

# Create file if it does not exist
[[ ! -f "$SHELLRC_ENVIRONMENT" ]] && touch "$SHELLRC_ENVIRONMENT"

# Load shellenv command line utility
include "shellenv.sh"
include "shellenv-completion.sh"

# Load variables
shellenv reload

