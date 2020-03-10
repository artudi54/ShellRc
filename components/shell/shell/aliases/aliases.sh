# Main entry for all aliases

# colouring first
include "colours.sh"

for file in "$(script-directory)"/*.sh; do
    if [ "$file" != "$(script-directory)/aliases.sh" ]; then
        source "$file"
    fi
done
