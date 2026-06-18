# Command completion for array-prepend-unique
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
    _array-prepend-unique() {
        COMPREPLY=()
        if [[ "$COMP_CWORD" -eq 1 ]]; then
            COMPREPLY=($(compgen -W "$(compgen -v)" -- "${COMP_WORDS[1]}"))
        fi
    }
    complete -F _array-prepend-unique array-prepend-unique
elif [[ -v ZSH_VERSION ]]; then
    _array-prepend-unique() {
        _arguments \
            '1:array:_parameters -g "array*"' \
            '2:value:'
    }
    compdef _array-prepend-unique array-prepend-unique
fi
