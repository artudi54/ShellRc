# paki plugin file

# PATH addition
if [[ "$PATH" != *"$(script_directory)/paki/bin"* ]]; then
    export PATH="$PATH:$(script_directory)/paki/bin"
fi

# autocompletion
include "paki/lib/completion.sh"
# aliases
include "paki/lib/aliases.sh"

