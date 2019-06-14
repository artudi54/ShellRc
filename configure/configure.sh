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

get-python() {
    local python
    python="$(which python3 2>/dev/null)"
    if [ "$python" = "" ]; then
        python="$(which python3.7 2>/dev/null)"
    fi
    if [ "$python" = "" ]; then
        python="$(which python3.6 2>/dev/null)"
    fi
    echo "$python"
}

preinstall() {
    "$SHELLRC_DIR/configure/preinstall/preinstall.sh" "$SHELLRC_DIR"
}

install() {
    if exists apt; then
        sudo apt install -y $(cat "$SHELLRC_DIR/configure/install/install-common.txt" "$SHELLRC_DIR/configure/install/debian/install.txt")
    elif exists aptitude; then
        sudo aptitude install -y $(cat "$SHELLRC_DIR/configure/install/install-common.txt" "$SHELLRC_DIR/configure/install/debian/install.txt")
    elif exists apt-get; then
        sudo apt-get install -y $(cat "$SHELLRC_DIR/configure/install/install-common.txt" "$SHELLRC_DIR/configure/install/debian/install.txt")
    elif exists dnf; then
        sudo dnf install -y $(cat "$SHELLRC_DIR/configure/install/install-common.txt" "$SHELLRC_DIR/configure/install/fedora/install.txt")
    elif exists yum; then
        sudo yum install -y $(cat "$SHELLRC_DIR/configure/install/install-common.txt" "$SHELLRC_DIR/configure/install/centos/install.txt")
    elif exists yay; then
        yay --noconfirm -Sy $(cat "$SHELLRC_DIR/configure/install/install-common.txt" "$SHELLRC_DIR/configure/install/arch/install.txt")
    else
        echo "$0: no suitable package manager for installing dependencies found" 1>&2
        return 1
    fi
}

postinstall() {
    "$SHELLRC_DIR/configure/postinstall/postinstall.sh" "$SHELLRC_DIR"
}


check-mv() {
    if [ -h "$HOME/$1" ] || [ -e "$HOME/$1" ]; then
        mv "$HOME/$1" "$BAK_DIR"
    fi
}

create-backups() {
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

echo "Preconfiguring installation"
preinstall
if [ $? != 0 ]; then
    exit 1
fi

echo "Installing required packages"
install
if [ $? != 0 ]; then
    exit 1
fi
echo "Installation done"

echo "Postconfiguring installation"
postinstall
if [ $? != 0 ]; then
    exit 1
fi

echo "Creating dotfiles backup"
create-backups
if [ $? != 0 ]; then
    exit 1
fi
echo "Backups created in $BAK_DIR"

echo "Writing dotfiles"
write-dotfiles
if [ $? != 0 ]; then
    exit 1
fi
echo "Writing dotfiles done"

echo "Searching for python binary"
python="$(get-python)"
if [ "$python" = "" ]; then
    echo "No python binary found" 1>&2
    exit 1
fi
echo "Found python '$python'"

echo "Configuring vim"
"$python" $SHELLRC_DIR/vim/bundle/YouCompleteMe/install.py --clang-completer
if [ $? != 0 ]; then
    exit 1
fi
echo "Configuring vim completion done"

