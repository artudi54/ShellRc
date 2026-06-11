# Main entry for screen configuration

# screen 4 compatibility
if [[ "$(screen --version)" == *5.* ]]; then
    export SCREENRC="$(script_directory)/screenrc.sh"
else
    export SCREENRC="$(script_directory)/screenrc-v4.sh"
fi
export SCREENDIR="$SHELLRC_STATE_DIR/screen-sessions"

# termscreen - persistent screen session using basic setup
termscreen() {
    if screen -ls | grep 'termscreen' 2>&1 >/dev/null; then
        screen -r termscreen
    else
        screen -S termscreen
    fi
}

