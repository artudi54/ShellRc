# change directory with create when specified does not exist
cdc() {
    if [[ ! -d "$@" ]]; then
        mkdir -p "$@"
    fi
    cd "$@"
}
