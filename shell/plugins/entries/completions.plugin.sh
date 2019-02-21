# completions for bash and zsh (currently only for zsh)

if [ -n "$ZSH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/files/zsh-completions/zsh-completions.plugin.zsh"
elif [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/files/bash-completion/bash_completion"
fi
