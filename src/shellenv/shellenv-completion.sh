# Command completion for shelenv command

_shellenv-complete-commands() {
    if [ "${COMP_WORDS[1]:0:1}" = "-" ]; then
        COMPREPLY+=($(compgen -W "--help" -- "${COMP_WORDS[1]}"))
    else
        local commands="get help list print reload set unset"
        COMPREPLY+=($(compgen -W "$commands" -- "${COMP_WORDS[1]}"))
    fi
}

_shellenv-complete-keys() {
    COMPREPLY+=($(compgen -W "$(shellenv list)" -- "${COMP_WORDS[2]}"))
}

_shellenv() {
    COMPREPLY=()
    if [[ "$COMP_CWORD" -eq 1 ]]; then
        _shellenv-complete-commands
    elif [[ "$COMP_CWORD" -eq 2 ]]; then
        local comm="${COMP_WORDS[1]}"
        if [[ "$comm" == get ]] || [[ "$comm" == set ]] || [[ "$comm" == unset ]]; then
            _shellenv-complete-keys
        fi
    fi
}


complete -F _shellenv shellenv

