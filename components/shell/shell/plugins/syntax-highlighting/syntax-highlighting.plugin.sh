# plugin enabling syntax highlighting in shell

if [ -n "$BASH_VERSION" ]; then
    #include "ble-0.3.0/ble.sh" --rcfile "$(script-directory)/blerc.sh"
    :
elif [ -n "$ZSH_VERSION" ]; then
	include "zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi
