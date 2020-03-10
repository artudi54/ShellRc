# Setup the prompt

# Setup for zsh
if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz colors && colors
    autoload -Uz promptinit && promptinit
    setopt promptsubst
fi

# Apply prompt theme
if [ -n "$SHELLRC_PROMPT" ] && [ -f "$(script-directory)/themes/$SHELLRC_PROMPT.theme.sh" ]; then
    include "themes/$SHELLRC_PROMPT.theme.sh"
else
    include "themes/default.theme.sh"
fi

# utility functions
include "prompt-utils.sh"

precmd_functions+=(make-prompt)

