# plugin enabling syntax highlighting in shell
[[ $- != *i* ]] && return

if [ -n "$ZSH_VERSION" ]; then
	include "zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
fi
