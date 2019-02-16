# Main entry for all environmental variables

for file in $SHELLRC_DIR/shell/environment/*.sh; do
    if [ "$file" != "$SHELLRC_DIR/shell/environment/environment.sh" ]; then
        source "$file"
    fi
done
