# This script loads plugins loaded at teh beginning

# enable bash preexec and precmd
if [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/depends/hooks/hooks.plugin.sh"
fi
