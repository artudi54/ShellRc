# Add .local/bin to path
if [[ "$PATH" != *"$HOME/.local/bin"* ]]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# Add .local/bin subdirectories to path
for dir in "$HOME/.local/bin/"*; do
    if [[ -d "$dir" ]] && [[ "$PATH" != *"$dir"* ]]; then
        export PATH="$PATH:$dir"
    fi
done

