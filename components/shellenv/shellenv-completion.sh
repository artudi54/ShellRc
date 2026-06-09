# Command completion for shellenv command
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
    _shellenv() {
        COMPREPLY=()
        if [[ "$COMP_CWORD" -eq 1 ]]; then
            if [[ "${COMP_WORDS[1]:0:1}" == "-" ]]; then
                COMPREPLY=($(compgen -W "--help" -- "${COMP_WORDS[1]}"))
            else
                COMPREPLY=($(compgen -W "get help list print reload set sync unset" -- "${COMP_WORDS[1]}"))
            fi
        elif [[ "$COMP_CWORD" -eq 2 ]]; then
            case "${COMP_WORDS[1]}" in
                get|set|unset)
                    COMPREPLY=($(compgen -W "$(shellenv list)" -- "${COMP_WORDS[2]}"))
                    ;;
                sync)
                    COMPREPLY=($(compgen -e -- "${COMP_WORDS[2]}"))
                    ;;
            esac
        fi
    }
    complete -F _shellenv shellenv

elif [[ -v ZSH_VERSION ]]; then
    _shellenv() {
        local -a commands
        commands=(
            'get:get variable value'
            'help:display help message'
            'list:show all shellenv variables'
            'print:print configuration file'
            'reload:reload variables from configuration file'
            'set:set variable value'
            'sync:register variable for automatic persistence on change'
            'unset:remove variable'
        )

        _arguments -s \
            '1:command:->command' \
            '2:key:->key' && return

        case "$state" in
            command)
                _describe 'command' commands
                _arguments '1:command:(--help)'
                ;;
            key)
                case "${words[2]}" in
                    get|set|unset)
                        local -a keys
                        keys=(${(z)$(shellenv list)})
                        _describe 'key' keys
                        ;;
                    sync)
                        _parameters -g 'export'
                        ;;
                esac
                ;;
        esac
    }
    compdef _shellenv shellenv
fi
