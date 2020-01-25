# Utility functions for dealing with script directories and sourcing

# Get script directory (returns directory of this function calling script)
if [[ -v BASH_VERSION ]]; then
    __script-directory() {
        local num="$1"
        if [[ -z "${BASH_SOURCE[$num]}" ]]; then
            echo "script-directory: not called from script" 1>&2
            return 1
        fi
        local directory="$(dirname "$(readlink -e "${BASH_SOURCE[$num]}")")" 
        echo "$directory"
    }
elif [[ -v ZSH_VERSION ]]; then
    __script-directory() {
        local num="$1"
        local file="$(readlink -e "${funcfiletrace[$num]%:*}")"
        if [[ -z "$file" ]]; then
            echo "script-directory: not called from script" 1>&2
            return 1
        fi
        local directory="$(dirname "$file")" 
        echo "$directory"
    }
fi
script-directory() {
    __script-directory 2
}

# Include command for sourcing files relative to script
include() {
    if [[ "$#" -eq 0 ]]; then
        echo "include: this function takes at least one argument, $# provided" 1>&2
        return 1
    fi
    local dir="$(__script-directory 2 2>/dev/null)"
    local file="$1"
    local sourced="$dir/$file"
    if [[ ! -f "$sourced" ]]; then
        echo "include: no such file: '$file'" 1>&2
        return 1
    fi
    source "$sourced" "$@"
}
