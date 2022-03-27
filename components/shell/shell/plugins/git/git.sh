# Git additional packages

# PATH for git commands
## Git Flow
if [[ "$PATH" != *"$(script_directory)/bin/git-flow"* ]]; then
    export PATH="$PATH:$(script_directory)/bin/git-flow"
fi
## Git Extras
if [[ "$PATH" != *"$(script_directory)/bin/git-extras"* ]]; then
    export PATH="$PATH:$(script_directory)/bin/git-extras"
fi
## Git Utils
if [[ "$PATH" != *"$(script_directory)/bin/git-utils"* ]]; then
    export PATH="$PATH:$(script_directory)/bin/git-utils"
fi

# MANPATH for manual
## Git Flow
### TODO
## Git Extras
export MANPATH="$MANPATH:$(script_directory)/share/man/git-extras"
## Git Utils
### TODO

# Completions
## Git Flow
if [ -n "$ZSH_VERSION" ]; then
    source "$(script_directory)/completions/git-flow/git-flow-completion.zsh"
elif [ -n "$BASH_VERSION" ]; then
    source "$(script_directory)/completions/git-flow/git-flow-completion.bash"
fi
## Git Extras
if [ -n "$ZSH_VERSION" ]; then
    source "$(script_directory)/completions/git-extras/git-extras-completion.zsh"
elif [ -n "$BASH_VERSION" ]; then
    source "$(script_directory)/completions/git-extras/bash_completion.sh"
fi
## Git Utils
### TODO

