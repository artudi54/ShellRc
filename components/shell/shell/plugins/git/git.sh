# Git additional packages

# PATH for git commands
## Git Flow
export PATH="$PATH:$(script-directory)/bin/git-flow"
## Git Extras
export PATH="$PATH:$(script-directory)/bin/git-extras"
## Git Utils
export PATH="$PATH:$(script-directory)/bin/git-utils"

# MANPATH for manual
## Git Flow
### TODO
## Git Extras
export MANPATH="$MANPATH:$(script-directory)/share/man/git-extras"
## Git Utils
### TODO

# Completions
## Git Flow
if [ -n "$ZSH_VERSION" ]; then
    source "$(script-directory)/completions/git-flow/git-flow-completion.zsh"
elif [ -n "$BASH_VERSION" ]; then
    source "$(script-directory)/completions/git-flow/git-flow-completion.bash"
fi
## Git Extras
if [ -n "$ZSH_VERSION" ]; then
    source "$(script-directory)/completions/git-extras/git-extras-completion.zsh"
elif [ -n "$BASH_VERSION" ]; then
    source "$(script-directory)/completions/git-extras/bash_completion.sh"
fi
## Git Utils
### TODO

