# Git additional packages

# PATH for git commands
## Git Extras
export PATH="$PATH:$SHELLRC_DIR/shell/plugins/git/bin/git-extras"
## Git Flow
export PATH="$PATH:$SHELLRC_DIR/shell/plugins/git/bin/git-flow"
## Git Utils
export PATH="$PATH:$SHELLRC_DIR/shell/plugins/git/bin/git-utils"

# MANPATH for manual
## Git Extras
export MANPATH="$MANPATH:$SHELLRC_DIR/shell/plugins/git/share/man/git-extras"
## Git Flow
### TODO
## Git Utils
### TODO

# Completions
## Git Extras
if [ -n "$ZSH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/git/completions/git-extras/git-extras-completion.zsh"
elif [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/git/completions/git-extras/bash_completion.sh"
fi
## Git Flow
if [ -n "$ZSH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/git/completions/git-flow/git-flow-completion.zsh"
elif [ -n "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/plugins/git/completions/git-flow/git-flow-completion.bash"
fi
## Git Utils
### TODO

