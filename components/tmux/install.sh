dir="$(script_directory)"
mkdir -p "$XDG_CONFIG_HOME/tmux"
echo "source \"$dir/tmux.conf\"" > "$XDG_CONFIG_HOME/tmux/tmux.conf"
