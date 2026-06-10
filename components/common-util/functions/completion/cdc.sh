# Command completion for cdc
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
    _cdc() {
        COMPREPLY=()
        if [[ "$COMP_CWORD" -eq 1 ]]; then
            COMPREPLY=($(compgen -d -- "${COMP_WORDS[1]}"))
        fi
    }
    complete -o filenames -F _cdc cdc

elif [[ -v ZSH_VERSION ]]; then
    _cdc() {
        _arguments '1:directory:_directories'
    }
    compdef _cdc cdc
fi
