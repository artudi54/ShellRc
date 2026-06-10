# Command completion for cleardir
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
    _cleardir() {
        COMPREPLY=()
        if [[ "$COMP_CWORD" -eq 1 ]]; then
            COMPREPLY=($(compgen -d -- "${COMP_WORDS[1]}"))
        fi
    }
    complete -F _cleardir cleardir

elif [[ -v ZSH_VERSION ]]; then
    _cleardir() {
        _arguments '1:directory:_directories'
    }
    compdef _cleardir cleardir
fi
