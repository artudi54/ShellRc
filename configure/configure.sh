#!/bin/bash
SHELLRC_DIR="$(dirname "$(dirname "$(realpath "$BASH_SOURCE")")")"
BAK_DIR="$HOME/.shellrc-backups"

exists() {
    if which "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

install-deps() {
    if exists apt; then
        sudo apt install -y $(cat "$SHELLRC_DIR/configure/install.txt" "$SHELLRC_DIR/configure/install-python3.txt")
    elif exists aptitude; then
        sudo aptitude install -y $(cat i"$SHELLRC_DIR/configure/install.txt" "$SHELLRC_DIR/configure/install-python3.txt")
    elif exists apt-get; then
        sudo apt-get install -y $(cat "$SHELLRC_DIR/configure/install.txt" "$SHELLRC_DIR/configure/install-python3.txt")
    elif exists dnf; then
        sudo dnf install -y $(cat "$SHELLRC_DIR/configure/install.txt" "$SHELLRC_DIR/configure/install-python3.txt")
    elif exists yum; then
        sudo yum install -y $(cat "$SHELLRC_DIR/configure/install.txt" "$SHELLRC_DIR/configure/install-python3.txt")
    elif exists yay; then
        yay --noconfirm -Sy $(cat "$SHELLRC_DIR/configure/install.txt" "$SHELLRC_DIR/configure/install-python.txt")
    else
        echo "$0: no suitable package manager for installing dependencies found" 1>&2
        return 1
    fi
}


check-mv() {
    if [ -h "$HOME/$1" ] || [ -e "$HOME/$1" ]; then
        mv "$HOME/$1" "$BAK_DIR"
    fi
}

make-backups() {
    if [ -d "$BAK_DIR" ]; then
        echo "$0: backups already created in '$BAK_DIR' - won't overwrite" 1>&2
        return 1
    fi
    mkdir "$HOME/.shellrc-backups"
    
    # bash
    check-mv ".bashrc"
    check-mv ".bash_history"
    check-mv ".bash_login"
    check-mv ".bash_logout"
    check-mv ".bash_profile"
    check-mv ".profile"
    
    # zsh
    check-mv ".zlogin"
    check-mv ".zlogout"
    check-mv ".zprofile"
    check-mv ".zshenv"
    check-mv ".zshrc"
    check-mv ".zsh_history"
    
    # vim
    check-mv ".vim"
    check-mv ".vimrc"
    check-mv ".viminfo"
    
    # screen
    check-mv ".screenrc"
    
    # tmux
    check-mv ".tmux.conf"
    
    # emacs
    check-mv ".emacs"
    check-mv ".emacs.d"
    
    # git
    check-mv ".gitconfig"
    
    # python
    check-mv ".pythonrc"
    check-mv ".python-history"
}


write-dotfiles() {
    echo "source "\"$SHELLRC_DIR/shell/shellrc.sh\""" > "$HOME/.bashrc"
    ln -s ".bashrc" "$HOME/.zshrc"
    
    echo "source "\"$SHELLRC_DIR/shell/shellrc.sh\""" > "$HOME/.profile"
    ln -s ".profile" "$HOME/.zprofile"

    echo "[include]" > "$HOME/.gitconfig"
    echo "    path = "\"$SHELLRC_DIR/git/gitconfig.ini\""" >> "$HOME/.gitconfig"

    echo "source "\"$SHELLRC_DIR/tmux/tmux.conf\""" > "$HOME/.tmux.conf"
}


install-deps
if [ $? != 0 ]; then
    exit 1
fi
echo "Installation done"

make-backups
if [ $? != 0 ]; then
    exit 1
fi
echo "Backups done"

write-dotfiles
if [ $? != 0 ]; then
    exit 1
fi
echo "Writing dotfiles done"

