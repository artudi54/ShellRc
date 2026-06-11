# Tmux config location
export SHELLRC_TMUX_CONFIG_DIR="$(script_directory)"

# Tmux socket directory
export TMUX_TMPDIR="$SHELLRC_STATE_DIR/tmux-sessions"
[[ -d "$TMUX_TMPDIR" ]] || mkdir -p "$TMUX_TMPDIR"

# termtmux - persistent tmux session using basic setup
termtmux() {
    if tmux has-session -t termtmux 2>/dev/null; then
        tmux attach-session -t termtmux
    else
        tmux new-session -s termtmux
    fi
}

