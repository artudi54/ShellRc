# Source all library files

for dir in "$SHELLRC_DIR"/lib/*; do
    if [[ -d "$dir" ]]; then
        name="$(basename "$dir")"
        file="${name:3:${#name}}"
        source "$dir/$file.sh"
    fi
done
