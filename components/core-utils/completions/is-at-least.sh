# Command completion for is-at-least
[[ $- != *i* ]] && return
[[ ! -v BASH_VERSION ]] && return

_is-at-least() {
    COMPREPLY=()
    local cur="${COMP_WORDS[COMP_CWORD]}"

    # Second argument: complete with common version variables
    if (( COMP_CWORD == 2 )); then
        COMPREPLY=($(compgen -W '$BASH_VERSION $TERM_PROGRAM_VERSION' -- "$cur"))
    fi
}
complete -F _is-at-least is-at-least
