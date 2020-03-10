# Main entry for all functions Sources all files in this directory

for file in "$(script-directory)"/*.sh; do
    if [ "$file" != "$(script-directory)/functions.sh" ]; then
        source "$file"
    fi
done
