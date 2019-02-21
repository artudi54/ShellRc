# Setup the prompt

# Setup for zsh
if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz colors && colors
    autoload -Uz promptinit && promptinit
    setopt promptsubst
fi

# Apply prompt theme
if [ -n "$SHELLRC_PROMPT" ] && [ -f "$SHELLRC_DIR/shell/prompt/themes/$SHELLRC_PROMPT.theme.sh" ]; then
    source "$SHELLRC_DIR/shell/prompt/themes/$SHELLRC_PROMPT.theme.sh"
else
    source "$SHELLRC_DIR/shell/prompt/themes/default.theme.sh"
fi

# utility functions
source "$SHELLRC_DIR/shell/prompt/prompt-utils.sh"

precmd_functions+=(make-prompt)
