# Main entry for all environmental variables

for file in "$(script_directory)"/*.sh; do
    if [ "$file" != "$(script_directory)/environment.sh" ]; then
        source "$file"
    fi
done
