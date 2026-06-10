# Change directroy to ShellRc
shellrc-go() {
    cd "$SHELLRC_DIR"
}

# Update from external repository
shellrc-update() {
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" pull --recurse-submodules
    shellrc-reload
}

# ShellRc git status
shellrc-status() {
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" status
}


# reload ShellRc in bash or zsh
shellrc-reload() {
    source "$HOME/.bashrc"
}
