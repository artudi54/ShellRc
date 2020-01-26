# Shell configuration setup for ShellRc

if [[ ! -v SHELLRC_ENVIRONMENT ]]; then
    export SHELLRC_ENVIRONMENT="$SHELLRC_DIR/environment.conf"
fi

if [[ ! -f "$SHELLRC_ENVIRONMENT" ]]; then
    touch "$SHELLRC_ENVIRONMENT"
fi

include "shellenv.sh"
include "shellenv-completion.sh"
shellenv reload

