# append a value to an array only if it is not already present
array-append-unique() {
    local name="$1"
    local val="$2"
    if [[ -v BASH_VERSION ]]; then
        local -n arr="$name"
        for entry in "${arr[@]}"; do
            [[ "$entry" == "$val" ]] && return 0
        done
        arr+=("$val")
    elif [[ -v ZSH_VERSION ]]; then
        local arr=("${(@P)name}")
        for entry in "${arr[@]}"; do
            [[ "$entry" == "$val" ]] && return 0
        done
        set -A "$name" "${arr[@]}" "$val"
    fi
}

# prepend a value to an array only if it is not already present
array-prepend-unique() {
    local name="$1"
    local val="$2"
    if [[ -v BASH_VERSION ]]; then
        local -n arr="$name"
        for entry in "${arr[@]}"; do
            [[ "$entry" == "$val" ]] && return 0
        done
        arr=("$val" "${arr[@]}")
    elif [[ -v ZSH_VERSION ]]; then
        local arr=("${(@P)name}")
        for entry in "${arr[@]}"; do
            [[ "$entry" == "$val" ]] && return 0
        done
        set -A "$name" "$val" "${arr[@]}"
    fi
}

# print each element of an array on its own line
array-print() {
    eval "printf '%s\n' \"\${$1[@]}\""
}
