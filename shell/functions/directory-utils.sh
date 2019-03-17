# function for listing directories only
# TODO: FIX
ld() {
    local IFS=$'\n' 
	local files=$(ls -l $@ | grep "^d\|^l" | awk '{print $9}')
    local directories=""
    for file in $files; do 
        if [[ -d "$file" ]] || [[ -d "$(readlink -- "$file")" ]]; then
            directories="${directories}"$'\n'"${file}"
        fi
    done
    ls -d $@ $directories
}
alias ldl='ld -l'

# change directory with create when specified does not exist exist
cdc() {
    if [[ ! -d "$@" ]]; then
        mkdir -p "$@"
    fi
    cd "$@"
}

# clear contents of directory
cleardir() {
    local dir
    if [[ $# -eq 0 ]]; then
        dir=.
    elif [[ $# -eq 1 ]]; then
        dir="$1"
    else
        echo "cleardir: invalid number of arguments specified" 1>&2
        return 1
    fi
    
    if [[ ! -d "$dir" ]]; then
        echo "cleardir: - \"$dir\" is not a directory" 1>&2
        return 1
    fi

    local IFS=$'\n'
    find "$dir" -maxdepth 1 2>/dev/null | tail -n +2 | xargs rm -rf 2>/dev/null
}
