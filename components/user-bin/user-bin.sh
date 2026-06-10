# Ensure .local/bin exists
mkdir -p "$HOME/.local/bin"

# Add .local/bin and its subdirectories to path (prepend, reverse order)
for dir in "$HOME/.local/bin/"* "$HOME/.local/bin"; do
    [[ -d "$dir" ]] && array-prepend-unique path "$dir"
done
unset dir

