# Functions for manipulating prompt

# current prompt setting
shellrc-prompt() {
    echo "$SHELLRC_PROMPT"
}

# listing available themes
shellrc-prompt-list() {
    ls $SHELLRC_DIR/shell/prompt/themes/*.theme.sh 2>/dev/null | awk -F'/' '{print $NF }' | sed 's/.theme.sh//'
}

# setting prompt theme
shellrc-prompt-set() {
    if [ "$#" -ne 1 ]; then
        echo "shellrc-prompt: invalid number of arguments" 1>&2
        return 1
    fi

    theme="$1"
    if [ ! -f "$SHELLRC_DIR/shell/prompt/themes/$theme.theme.sh" ]; then
        echo "shellrc-prompt: \"$theme\" - no such theme available"
        return 2
    fi
    
    if grep "SHELLRC_PROMPT" "$SHELLRC_DIR/settings.conf" >/dev/null 2>&1; then
        sed -i "s/SHELLRC_PROMPT=.*/SHELLRC_PROMPT=\"$theme\"/" "$SHELLRC_DIR/settings.conf" >/dev/null 2>&1
    else
        echo "SHELLRC_PROMPT=\"$theme\"" >>"$SHELLRC_DIR/settings.conf"
    fi
    SHELLRC_PROMPT="$theme"
    shellrc-reload
}