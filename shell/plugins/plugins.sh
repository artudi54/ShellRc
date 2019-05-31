# main plugins file

# load autoloading plugins
for dir in $SHELLRC_DIR/shell/plugins/*; do
    [ -d "$dir" ] && source "$dir/$(basename $dir).plugin.sh"
done

source "$SHELLRC_DIR/shell/plugins/plugins-utils.sh"
