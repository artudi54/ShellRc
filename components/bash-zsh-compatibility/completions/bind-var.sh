# Command completion for bind-var
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
    _bind-var() {
        COMPREPLY=()
        case "$COMP_CWORD" in
            1) COMPREPLY=($(compgen -W "$(compgen -v)" -- "${COMP_WORDS[1]}")) ;;
            2) COMPREPLY=($(compgen -W "$(compgen -v)" -- "${COMP_WORDS[2]}")) ;;
        esac
    }
    complete -F _bind-var bind-var

elif [[ -v ZSH_VERSION ]]; then
    _bind-var() {
        _arguments \
            '1:scalar:_parameters -g scalar' \
            '2:array:_parameters -g "array*"' \
            '3:separator:'
    }
    compdef _bind-var bind-var
fi
