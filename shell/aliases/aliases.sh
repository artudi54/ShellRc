# Main entry for all aliases

# colouring first
source "$SHELLRC_DIR/shell/aliases/colours.sh"

for file in $SHELLRC_DIR/shell/aliases/*.sh; do
    if [ "$file" != "$SHELLRC_DIR/shell/aliases/aliases.sh" ]; then
        source "$file"
    fi
done