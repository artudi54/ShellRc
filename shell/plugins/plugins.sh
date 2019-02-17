# main plugins file

# load autoloading plugins
for file in $SHELLRC_DIR/shell/plugins/autoload/*.sh; do
    source "$file"
done
