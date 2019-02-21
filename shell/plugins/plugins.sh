# main plugins file

# load autoloading plugins
for file in $SHELLRC_DIR/shell/plugins/entries/*.plugin.sh; do
    source "$file"
done

source "$SHELLRC_DIR/shell/plugins/plugins-utils.sh"