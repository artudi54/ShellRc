# CDPATH management - bidirectional sync and persistence via shellenv
[[ $- != *i* ]] && return

if [[ -v ZSH_VERSION ]]; then
    setopt autocd
fi

# in bash, emulate zsh's tied cdpath/CDPATH
if [[ -v BASH_VERSION ]]; then
    if [[ -n "$CDPATH" ]]; then
        IFS=':' read -ra cdpath <<< "$CDPATH"
    else
        cdpath=()
    fi
    __cdpath_last_CDPATH="$CDPATH"
    __cdpath_last_cdpath=("${cdpath[@]}")

    __cdpath-sync-var() {
        local IFS=':'
        local cdpath_as_str="${cdpath[*]}"
        local old_as_str="${__cdpath_last_cdpath[*]}"

        if [[ "$cdpath_as_str" != "$old_as_str" ]]; then
            CDPATH="$cdpath_as_str"
        elif [[ "$CDPATH" != "$__cdpath_last_CDPATH" ]]; then
            if [[ -n "$CDPATH" ]]; then
                IFS=':' read -ra cdpath <<< "$CDPATH"
            else
                cdpath=()
            fi
        fi

        __cdpath_last_CDPATH="$CDPATH"
        __cdpath_last_cdpath=("${cdpath[@]}")
    }
    precmd_functions+=(__cdpath-sync-var)
fi

# persist CDPATH changes to shellenv
[[ -z "${CDPATH+x}" ]] && export CDPATH=""
shellenv sync CDPATH

