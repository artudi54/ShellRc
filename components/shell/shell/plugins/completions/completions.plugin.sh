# completions for bash and zsh (currently only for zsh)

if [ -n "$ZSH_VERSION" ]; then
    include "zsh-completions/zsh-completions.plugin.zsh"
elif [ -n "$BASH_VERSION" ]; then
    include "bash-completion/bash_completion"
fi
