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

# Deploy update to external repository
shellrc-deploy() {
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" add -A
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" commit -m "update"
    git --git-dir="$SHELLRC_DIR/.git" --work-tree="$SHELLRC_DIR" push
}

# reload ShellRc in bash or zsh
shellrc-reload() {
    if [[ -n $BASH_VERSION ]]; then
        source ~/.bashrc
    elif [[ -n $ZSH_VERSION ]]; then
        source ~/.zshrc
    fi
}
