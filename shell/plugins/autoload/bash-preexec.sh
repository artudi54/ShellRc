# enable bash preexec and precmd

if [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/autoload/bash-preexec/bash-preexec.sh"
fi
