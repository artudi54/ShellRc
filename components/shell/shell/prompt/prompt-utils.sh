# Functions for manipulating prompt

# current prompt setting
shellrc-prompt() {
    echo "$SHELLRC_PROMPT"
}

# listing available themes
shellrc-prompt-list() {
    ls "$(script-dir)/themes/"*.theme.sh 2>/dev/null | awk -F'/' '{print $NF }' | sed 's/.theme.sh//'
}

# setting prompt theme
shellrc-prompt-set() {
    if [ "$#" -ne 1 ]; then
        echo "shellrc-prompt: invalid number of arguments" 1>&2
        return 1
    fi

    theme="$1"
    if [ ! -f "$(script-dir)/themes/$theme.theme.sh" ]; then
        echo "shellrc-prompt: \"$theme\" - no such theme available"
        return 2
    fi
    
    shellenv set SHELLRC_PROMPT "$theme"
    unset -f make-prompt 2>/dev/null
    shellrc-reload
}
