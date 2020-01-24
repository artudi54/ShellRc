# Shell configuration setup for ShellRc

if [[ ! -v SHELLRC_ENVIRONMENT ]]; then
    readonly SHELLRC_ENVIRONMENT="$SHELLRC_DIR/environment.conf"
    export SHELLRC_ENVIRONMENT
fi

if [[ ! -f "$SHELLRC_ENVIRONMENT" ]]; then
    touch "$SHELLRC_ENVIRONMENT"
fi

source "$SHELLRC_DIR/lib/shell-environment/shellenv.sh"
source "$SHELLRC_DIR/lib/shell-environment/shellenv-completion.sh"
shellenv reload

