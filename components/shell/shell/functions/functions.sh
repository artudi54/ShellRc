# Main entry for all functions Sources all files in this directory

for file in "$(script_directory)"/*.sh; do
    if [ "$file" != "$(script_directory)/functions.sh" ]; then
        source "$file"
    fi
done
