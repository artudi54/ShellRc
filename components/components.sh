# Source all configuration components

for dir in "$SHELLRC_DIR"/components/*; do
    dirname="$(basename $dir)"
    [[ -d "$dir" ]] && source "$dir/$dirname.sh"
done
