# main plugins file

# load autoloading plugins
for dir in "$(script-directory)"/*; do
    [ -d "$dir" ] && source "$dir/$(basename $dir).plugin.sh"
done

