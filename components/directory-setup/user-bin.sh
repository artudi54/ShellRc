# Ensure .local/bin exists
mkdir -p "$HOME/.local/bin"

# Add .local/bin and its subdirectories to path (prepend, reverse order)
while IFS= read -r dir; do
    [[ ":$PATH:" != *":$dir:"* ]] || continue
    PATH="$dir:$PATH"
done < <(find -L "$HOME/.local/bin" -maxdepth 1 -type d 2>/dev/null | sort -r)
unset dir

