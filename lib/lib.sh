# Source all library files
for dir in "$SHELLRC_DIR"/lib/*; do
    dirname="$(basename $dir)"
    [[ -d "$dir" ]] && source "$dir/$dirname.sh"
done
