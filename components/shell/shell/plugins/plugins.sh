# main plugins file

# load autoloading plugins
for dir in "$(script_directory)"/*; do
    [ -d "$dir" ] && source "$dir/$(basename $dir).plugin.sh"
done

