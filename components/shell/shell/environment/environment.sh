# Main entry for all environmental variables

for file in "$(script-directory)"/*.sh; do
    if [ "$file" != "$(script-directory)/environment.sh" ]; then
        source "$file"
    fi
done
