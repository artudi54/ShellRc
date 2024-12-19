# Main entry for screen configuration

# Execute only when GNU Screen is installed
if which screen 2>&1 1>/dev/null; then
    # Default screenrc
    # Screen profiles
    export SCREEN_PROFILES="$(script_directory)/profiles"

    # screen 4 compatibility
    if [[ "$(screen --version)" == *5.* ]]; then
        export SCREENRC="$(script_directory)/screenrc.sh"
    else
        export SCREENRC="$(script_directory)/screenrc-v4.sh"
    fi

    # Scripts
    include "scripts/screenprofile.sh"
    include "scripts/termscreen.sh"

    # Autocompletion
    include "completion/screenprofiles-completion.sh"
fi
