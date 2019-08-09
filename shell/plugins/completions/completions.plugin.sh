# completions for bash and zsh (currently only for zsh)

if [ -n "$ZSH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/completions/zsh-completions/zsh-completions.plugin.zsh"
    source "$SHELLRC_DIR/shell/plugins/completions/git-flow-completion/git-flow-completion.plugin.zsh"
elif [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/completions/bash-completion/bash_completion"
    source "$SHELLRC_DIR/shell/plugins/completions/git-flow-completion/git-flow-completion.bash"
fi
