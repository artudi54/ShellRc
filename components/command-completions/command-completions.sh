# completions for bash and zsh

# interactive shell only
[[ $- != *i* ]] && return

if [ -n "$ZSH_VERSION" ]; then
    include "zsh-completions/zsh-completions.plugin.zsh"
elif [ -n "$BASH_VERSION" ]; then
    include "install/share/bash-completion/bash_completion"
fi
