# Main entry for screen configuration

# Execute only when GNU Screen is installed
if which screen 2>&1 1>/dev/null; then
    # Default screenrc
    if [[ ! -v SCREENRC ]]; then
        export SCREENRC="$SHELLRC_DIR/components/screen/screenrc.sh"
    fi

    # Scripts
    source "$SHELLRC_DIR/components/screen/scripts/screenprofile.sh"
    source "$SHELLRC_DIR/components/screen/scripts/termscreen.sh"

    # Scripts' autocompletion
    source "$SHELLRC_DIR/components/screen/completion/screenprofiles-completion.sh"
fi
