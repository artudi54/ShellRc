# Source all configuration components

for dir in "$(script-directory)"/*; do
    dirname="$(basename $dir)"
    [[ -d "$dir" ]] && source "$dir/$dirname.sh"
done
