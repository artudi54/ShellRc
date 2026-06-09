# Override the alias builtin to automatically register completion for aliases

[[ $- != *i* ]] && return

if [[ -v ZSH_VERSION ]]; then
    include "zsh-complete-alias.sh"
    alias() {
        builtin alias "$@" || return $?

        local arg
        for arg in "$@"; do
            case "$arg" in
                -*g*|-*s*) return 0 ;;
                *=*)
                    local name="${arg%%=*}"
                    local body="${arg#*=}"
                    local -a _body_words=(${(z)body})
                    [[ "$name" == "${_body_words[1]}" ]] && continue
                    compdef _complete_alias "$name"
                    ;;
            esac
        done
    }
elif [[ -v BASH_VERSION ]]; then
    include "bash-complete-alias/complete_alias"
    alias() {
        builtin alias "$@" || return $?

        local arg
        for arg in "$@"; do
            [[ "$arg" == -* ]] && continue
            [[ "$arg" != *=* ]] && continue
            local name="${arg%%=*}"
            local body="${arg#*=}"
            local cmd="${body%% *}"
            [[ "$name" == "$cmd" ]] && continue
            complete -F _complete_alias "$name"
        done
    }
fi
