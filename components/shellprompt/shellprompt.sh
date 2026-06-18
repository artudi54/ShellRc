# Command for managing ShellRc prompt theme
[[ $- != *i* ]] && return

include "shellprompt-completion.sh"

autoload -Uz colors && colors
autoload -Uz promptinit && promptinit
# Setup for zsh
if [[ -v ZSH_VERSION ]]; then
    setopt promptsubst
    zmodload zsh/datetime
fi

_shellprompt-help() {
    if [[ "$#" -gt 0 ]]; then
        echo "shellprompt: help: this command takes no arguments, $# provided" 1>&2
        return 1
    fi
    echo "shellprompt"
    echo "Usage: shellprompt <command> [args]"
    echo
    echo "shellprompt is a command for managing the ShellRc prompt theme."
    echo "It allows listing available themes and switching between them."
    echo "The selected theme is persisted via shellenv."
    echo
    echo "The prompt theme is controlled by the SHELLRC_PROMPT variable."
    echo "You can also set it directly: SHELLRC_PROMPT=<theme>"
    echo
    echo "Options:"
    echo "  --help - display this message"
    echo
    echo "Supported commands:"
    echo "  get - show current prompt theme"
    echo "  help - display this message"
    echo "  list - list available themes"
    echo "  set - set prompt theme"
    echo
}

_shellprompt-get() {
    if [[ "$#" -gt 0 ]]; then
        echo "shellprompt: get: this command takes no arguments, $# provided" 1>&2
        return 1
    fi
    echo "$SHELLRC_PROMPT"
}

_shellprompt-list() {
    if [[ "$#" -gt 0 ]]; then
        echo "shellprompt: list: this command takes no arguments, $# provided" 1>&2
        return 1
    fi
    ls "$(script_directory)/themes/"*.theme.sh 2>/dev/null | awk -F'/' '{print $NF}' | sed 's/.theme.sh//'
}

_shellprompt-set() {
    if [[ "$#" -ne 1 ]]; then
        echo "shellprompt: set: this command takes one argument, $# provided" 1>&2
        return 1
    fi

    local theme="$1"
    if [[ ! -f "$(script_directory)/themes/$theme.theme.sh" ]]; then
        echo "shellprompt: set: '$theme' - no such theme available" 1>&2
        return 2
    fi

    SHELLRC_PROMPT="$theme"
}

shellprompt() {
    local comm
    if [[ "$#" -eq 0 ]]; then
        comm=get
    else
        comm="$1"
        shift
    fi

    if [[ "$comm" == "--help" ]]; then
        _shellprompt-help "$@"
    elif typeset -f "_shellprompt-$comm" >/dev/null; then
        "_shellprompt-$comm" "$@"
    else
        echo "shellprompt: unknown command: '$comm'" 1>&2
        return 1
    fi
}

# Sync SHELLRC_PROMPT via shellenv so direct assignment is persisted
shellenv sync SHELLRC_PROMPT

# Detect theme change and re-apply
__shellprompt_last_theme=""

__shellprompt-sync() {
    if [[ "$SHELLRC_PROMPT" != "$__shellprompt_last_theme" ]]; then
        if [[ -n "$SHELLRC_PROMPT" ]] && [[ -f "$(script_directory)/themes/$SHELLRC_PROMPT.theme.sh" ]]; then
            unset -f make-prompt 2>/dev/null
            include "themes/$SHELLRC_PROMPT.theme.sh"
            __shellprompt_last_theme="$SHELLRC_PROMPT"
        elif [[ -z "$SHELLRC_PROMPT" ]]; then
            unset -f make-prompt 2>/dev/null
            include "themes/default.theme.sh"
            __shellprompt_last_theme=""
        else
            echo "shellprompt: '$SHELLRC_PROMPT' - no such theme available" 1>&2
            SHELLRC_PROMPT="$__shellprompt_last_theme"
        fi
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __shellprompt-sync
add-zsh-hook precmd make-prompt

