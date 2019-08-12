# plugin enabling syntax highlighting in shell

if [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/syntax-highlighting/ble-0.3.0/ble.sh" --rcfile "$SHELLRC_DIR/shell/plugins/syntax-highlighting/blerc.sh"
elif [ -n "$ZSH_VERSION" ]; then
	source "$SHELLRC_DIR/shell/plugins/syntax-highlighting/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi
