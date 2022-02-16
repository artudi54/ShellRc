# Main entry for screen configuration

# Execute only when GNU Screen is installed
if which screen 2>&1 1>/dev/null; then
    # Default screenrc
    export SCREENRC="$(script_directory)/screenrc.sh"
    # Screen profiles
    export SCREEN_PROFILES="$(script_directory)/profiles"

    # Scripts
    include "scripts/screenprofile.sh"
    include "scripts/termscreen.sh"

    # Autocompletion
    include "completion/screenprofiles-completion.sh"
fi
