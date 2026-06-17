# Ensure .local/bin exists
mkdir -p "$HOME/.local/bin"

# Add .local/bin and its subdirectories to path (prepend, reverse order)
for dir in "$HOME/.local/bin"/* "$HOME/.local/bin"; do
    [[ -d "$dir" ]] || continue
    [[ ":$PATH:" != *":$dir:"* ]] || continue
    PATH="$dir:$PATH"
done
unset dir

