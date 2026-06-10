# Command completion for array-append-unique, array-prepend-unique, array-print
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
    _array-utils() {
        COMPREPLY=()
        if [[ "$COMP_CWORD" -eq 1 ]]; then
            COMPREPLY=($(compgen -W "$(compgen -v)" -- "${COMP_WORDS[1]}"))
        fi
    }
    complete -F _array-utils array-append-unique
    complete -F _array-utils array-prepend-unique
    complete -F _array-utils array-print

elif [[ -v ZSH_VERSION ]]; then
    _array-append-unique() {
        _arguments \
            '1:array:_parameters -g "array*"' \
            '2:value:'
    }
    compdef _array-append-unique array-append-unique

    _array-prepend-unique() {
        _arguments \
            '1:array:_parameters -g "array*"' \
            '2:value:'
    }
    compdef _array-prepend-unique array-prepend-unique

    _array-print() {
        _arguments '1:array:_parameters -g "array*"'
    }
    compdef _array-print array-print
fi
