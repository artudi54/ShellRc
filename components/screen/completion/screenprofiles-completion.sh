# Command completion for screenprofile command

_screenprofile() {
    COMPREPLY=()
    if [[ "$COMP_CWORD" -eq 1 ]]; then
        local profiles="$(ls "$SCREEN_PROFILES" | awk '{ print substr($1, 1, length($1) - 5) }')"
        COMPREPLY+=($(compgen -W "$profiles" -- "${COMP_WORDS[1]}"))
    fi
}

complete -F _screenprofile screenprofile

