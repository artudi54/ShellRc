# Source all library files

source "$SHELLRC_DIR/lib/script-sourcing/script-sourcing.sh"

for dir in "$SHELLRC_DIR"/lib/*; do
    if [[ -d "$dir" ]]; then
        name="$(basename "$dir")"
        file="${name:3:${#name}}"
        [[ -f "$dir/$file.sh" ]] && source "$dir/$file.sh"
    fi
done
