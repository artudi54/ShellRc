# Source all configuration components

for dir in "$(script_directory)"/*; do
    dirname="$(basename $dir)"
    [[ -d "$dir" ]] && [[ -f "$dir/$dirname.sh" ]] && source "$dir/$dirname.sh"
done
