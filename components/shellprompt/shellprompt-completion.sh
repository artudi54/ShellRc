# Command completion for shellprompt command
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
    _shellprompt() {
        COMPREPLY=()
        if [[ "$COMP_CWORD" -eq 1 ]]; then
            if [[ "${COMP_WORDS[1]:0:1}" == "-" ]]; then
                COMPREPLY=($(compgen -W "--help" -- "${COMP_WORDS[1]}"))
            else
                COMPREPLY=($(compgen -W "get help list set" -- "${COMP_WORDS[1]}"))
            fi
        elif [[ "$COMP_CWORD" -eq 2 ]]; then
            case "${COMP_WORDS[1]}" in
                set)
                    COMPREPLY=($(compgen -W "$(shellprompt list)" -- "${COMP_WORDS[2]}"))
                    ;;
            esac
        fi
    }
    complete -F _shellprompt shellprompt

elif [[ -v ZSH_VERSION ]]; then
    _shellprompt() {
        local -a commands
        commands=(
            'get:show current prompt theme'
            'help:display help message'
            'list:list available themes'
            'set:set prompt theme'
        )

        _arguments -s \
            '1:command:->command' \
            '2:theme:->theme' && return

        case "$state" in
            command)
                _describe 'command' commands
                _arguments '1:command:(--help)'
                ;;
            theme)
                case "${words[2]}" in
                    set)
                        local -a themes
                        themes=(${(f)"$(shellprompt list)"})
                        _describe 'theme' themes
                        ;;
                esac
                ;;
        esac
    }
    compdef _shellprompt shellprompt
fi
