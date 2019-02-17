# Setup the prompt

# Setup for zsh
if [ -n "$ZSH_VERSION" ]; then
    autoload -Uz colors && colors
    autoload -Uz promptinit && promptinit
    setopt promptsubst
fi

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${DEBIAN_CHROOT:-}" ] && [ -r /etc/debian_chroot ]; then
    DEBIAN_CHROOT=$(cat /etc/debian_chroot)
fi

# Apply prompt theme
if [ -n "$SHELLRC_PROMPT" ] && [ -f "$SHELLRC_DIR/shell/prompt/themes/$SHELLRC_PROMPT.theme.sh" ]; then
    source "$SHELLRC_DIR/shell/prompt/themes/$SHELLRC_PROMPT.theme.sh"
else
    source "$SHELLRC_DIR/shell/prompt/themes/default.theme.sh"
fi
PS1="${DEBIAN_CHROOT:+($DEBIAN_CHROOT)}$PS1"

if [ -f "$SHELLRC_DIR/shell/prompt/prompt-utils.sh" ]; then
    source "$SHELLRC_DIR/shell/prompt/prompt-utils.sh"
fi