# Main entry for screen configuration

# Source only when GNU Screen is installed
if which screen 2>&1 1>/dev/null; then
    source "$SHELLRC_DIR/screen/scripts/profiles.sh"
    source "$SHELLRC_DIR/screen/scripts/termscreen.sh"
fi
