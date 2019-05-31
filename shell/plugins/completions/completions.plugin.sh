# completions for bash and zsh (currently only for zsh)

if [ -n "$ZSH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/completions/zsh-completions/zsh-completions.plugin.zsh"
elif [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/completions/bash-completion/bash_completion"
fi
