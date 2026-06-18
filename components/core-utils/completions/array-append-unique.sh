# Command completion for array-append-unique
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
    _array-append-unique() {
        COMPREPLY=()
        if [[ "$COMP_CWORD" -eq 1 ]]; then
            COMPREPLY=($(compgen -W "$(compgen -v)" -- "${COMP_WORDS[1]}"))
        fi
    }
    complete -F _array-append-unique array-append-unique
elif [[ -v ZSH_VERSION ]]; then
    _array-append-unique() {
        _arguments \
            '1:array:_parameters -g "array*"' \
            '2:value:'
    }
    compdef _array-append-unique array-append-unique
fi
