# Command completion for array-print
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
    _array-print() {
        COMPREPLY=()
        if [[ "$COMP_CWORD" -eq 1 ]]; then
            COMPREPLY=($(compgen -W "$(compgen -v)" -- "${COMP_WORDS[1]}"))
        fi
    }
    complete -F _array-print array-print
elif [[ -v ZSH_VERSION ]]; then
    _array-print() {
        _arguments '1:array:_parameters -g "array*"'
    }
    compdef _array-print array-print
fi
