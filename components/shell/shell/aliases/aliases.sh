# Main entry for all aliases
# Interactive shell only
[[ $- != *i* ]] && return
# colouring first
include "colours.sh"

for file in "$(script_directory)"/*.sh; do
    if [ "$file" != "$(script_directory)/aliases.sh" ]; then
        source "$file"
    fi
done
