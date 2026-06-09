# Ensure .local/bin exists
mkdir -p "$HOME/.local/bin"

# Add .local/bin and its subdirectories to path
binFiles=("$HOME/.local/bin" "$HOME/.local/bin/"*)
addedPaths=""

for ((idx=${#binFiles[@]}; idx>=0 ; idx-- )); do
    if [[ -d "${binFiles[idx]}" ]] && [[ "$PATH" != *"${binFiles[idx]}"* ]]; then
        addedPaths="${binFiles[idx]}:$addedPaths"
    fi
done
export PATH="${addedPaths}${PATH}"

unset idx
unset binFiles
unset addedPaths

