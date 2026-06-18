# Command completion for add-zsh-hook
[[ $- != *i* ]] && return
[[ ! -v BASH_VERSION ]] && return

_add-zsh-hook() {
    COMPREPLY=()
    local cur="${COMP_WORDS[COMP_CWORD]}"

    # Complete options
    if [[ "$cur" == -* ]]; then
        COMPREPLY=($(compgen -W "-d -D -h -L -U -z -k" -- "$cur"))
        return
    fi

    # Determine if -d/-D is present and find the positional argument index
    local word del=false pos=0
    for (( i = 1; i < COMP_CWORD; i++ )); do
        word="${COMP_WORDS[i]}"
        if [[ "$word" == -* ]]; then
            [[ "$word" == *[dD]* ]] && del=true
        else
            (( pos++ ))
        fi
    done

    local -a hooktypes=(chpwd precmd preexec)

    if (( pos == 0 )); then
        # First positional: hook type
        COMPREPLY=($(compgen -W "${hooktypes[*]}" -- "$cur"))
    elif (( pos == 1 )); then
        if $del; then
            # Deleting: complete with functions currently in the hook array
            local hookname
            for (( i = 1; i < COMP_CWORD; i++ )); do
                word="${COMP_WORDS[i]}"
                [[ "$word" != -* ]] && hookname="$word" && break
            done
            local varname="${hookname}_functions"
            local -n __hook_ref="$varname" 2>/dev/null
            if [[ -n "${__hook_ref+set}" ]]; then
                COMPREPLY=($(compgen -W "${__hook_ref[*]}" -- "$cur"))
            fi
        else
            # Adding: complete with defined functions
            COMPREPLY=($(compgen -A function -- "$cur"))
        fi
    fi
}
complete -F _add-zsh-hook add-zsh-hook
