# Main entry for all functions Sources all files in this directory

for file in $SHELLRC_DIR/shell/functions/*.sh; do
    if [ "$file" != "$SHELLRC_DIR/shell/functions/functions.sh" ]; then
        source "$file"
    fi
done
