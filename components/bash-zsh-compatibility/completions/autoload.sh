# Command completion for autoload
[[ $- != *i* ]] && return
[[ ! -v BASH_VERSION ]] && return

_autoload() {
    COMPREPLY=()
    local cur="${COMP_WORDS[COMP_CWORD]}"

    # Complete options
    if [[ "$cur" == -* ]]; then
        COMPREPLY=($(compgen -W "-U -z -k -t -T -r -R -d -m -X" -- "$cur"))
        return
    fi
    if [[ "$cur" == +* ]]; then
        COMPREPLY=($(compgen -W "+X +U +z +k +d +t +T +r +R +m" -- "$cur"))
        return
    fi

    # Check if +X is present — complete registered autoloads
    local word load_now=false
    for word in "${COMP_WORDS[@]}"; do
        [[ "$word" == *X* && "$word" == +* ]] && load_now=true
    done

    if $load_now; then
        # Complete with registered but unloaded autoloads
        local -a candidates=()
        local name
        for name in "${!__autoload_registry[@]}"; do
            [[ "${__autoload_registry[$name]}" == "undefined" ]] && candidates+=("$name")
        done
        COMPREPLY=($(compgen -W "${candidates[*]}" -- "$cur"))
    else
        # Complete with files from fpath directories
        local -a candidates=()
        local dir
        for dir in "${fpath[@]}"; do
            [[ -d "$dir" ]] || continue
            local file
            for file in "$dir"/*; do
                [[ -f "$file" ]] && candidates+=("${file##*/}")
            done
        done
        COMPREPLY=($(compgen -W "${candidates[*]}" -- "$cur"))
    fi
}
complete -F _autoload autoload
