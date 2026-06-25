# plugin enabling syntax highlighting in shell
[[ $- != *i* ]] && return

# comment it out for now
#if [ -n "$BASH_VERSION" ]; then
#	include "ble.sh/out/ble.sh" --rcfile="$(script_directory)/blerc"
#fi
if [ -n "$ZSH_VERSION" ]; then
	include "zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi
