# Zsh alias completion — expands aliases and delegates to the real completion function.
# Equivalent of bash complete-alias (Cyker Way) for the zsh completion system.

# Extract the last simple command from a (potentially compound) command string.
# Handles pipes, &&, ||, ;, &, redirections, and leading variable assignments.
# Result returned in the caller's `reply` array.
__compal__last_simple_command() {
    local -a tokens
    tokens=(${(z)1})

    reply=()
    local token
    for token in "${tokens[@]}"; do
        case "$token" in
            '|'|'&&'|'||'|';'|'&'|'|&')
                reply=()
                ;;
            *)
                reply+=("$token")
                ;;
        esac
    done

    local -a filtered=()
    local skip_next=0
    for token in "${reply[@]}"; do
        if (( skip_next )); then
            skip_next=0
            continue
        fi

        case "$token" in
            '<'|'>'|'>>'|'<>'|'>&'|'<&'|'&>'|'&>>'|'<<<'|'<<'|\
            [0-9]'>'|[0-9]'>>'|[0-9]'<'|[0-9]'<>'|[0-9]'>&'|[0-9]'<&')
                skip_next=1
                continue
                ;;
        esac

        case "$token" in
            '>'?*|'>>'?*|'<'?*|'<>'?*|'&>'?*|'&>>'?*|\
            [0-9]'>'?*|[0-9]'>>'?*|[0-9]'<'?*|[0-9]'<>'?*)
                continue
                ;;
        esac

        filtered+=("$token")
    done
    reply=("${filtered[@]}")

    while (( ${#reply} )) && [[ "${reply[1]}" == [a-zA-Z_][a-zA-Z0-9_]#=* ]]; do
        shift reply
    done
}

_complete_alias() {
    local -A _compal_seen
    local -a reply body_words
    local word body n

    while true; do
        word="${words[1]}"
        body="${aliases[$word]}"

        [[ -z "$body" ]] && break
        (( ${+_compal_seen[$word]} )) && break
        _compal_seen[$word]=1

        __compal__last_simple_command "$body"
        body_words=("${reply[@]}")
        (( ${#body_words} == 0 )) && break

        n=${#body_words}
        words=("${body_words[@]}" "${(@)words[2,-1]}")
        (( CURRENT += n - 1 ))
    done

    local cmd="${words[1]}"
    if [[ "${_comps[$cmd]}" == _complete_alias ]]; then
        unset "_comps[$cmd]"
        _normal
        _comps[$cmd]=_complete_alias
    else
        _normal
    fi
}
