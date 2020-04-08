#!/bin/bash
export SHELLRC_DIR="$(dirname "$(dirname "$(dirname "$(realpath "$BASH_SOURCE")")")")"
source "$SHELLRC_DIR/lib/lib.sh"
export -f include
export -f script-directory

exists() {
    if which "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

preinstall() {
    "$SHELLRC_DIR/deployment/configure/preinstall/preinstall.sh" "$SHELLRC_DIR"
}

install() {
    if exists apt; then
        sudo apt install -y $(cat "$SHELLRC_DIR/deployment/configure/install/install-common.txt" "$SHELLRC_DIR/deployment/configure/install/debian/install.txt")
    elif exists aptitude; then
        sudo aptitude install -y $(cat "$SHELLRC_DIR/deployment/configure/install/install-common.txt" "$SHELLRC_DIR/deployment/configure/install/debian/install.txt")
    elif exists apt-get; then
        sudo apt-get install -y $(cat "$SHELLRC_DIR/deployment/configure/install/install-common.txt" "$SHELLRC_DIR/deployment/configure/install/debian/install.txt")
    elif exists dnf; then
        sudo dnf install -y $(cat "$SHELLRC_DIR/deployment/configure/install/install-common.txt" "$SHELLRC_DIR/deployment/configure/install/fedora/install.txt")
    elif exists yum; then
        sudo yum install -y $(cat "$SHELLRC_DIR/deployment/configure/install/install-common.txt" "$SHELLRC_DIR/deployment/configure/install/centos/install.txt")
    elif exists yay; then
        yay --noconfirm -Sy $(cat "$SHELLRC_DIR/deployment/configure/install/install-common.txt" "$SHELLRC_DIR/deployment/configure/install/arch/install.txt")
    else
        echo "$0: no suitable package manager for installing dependencies found" 1>&2
        return 1
    fi
}

postinstall() {
    "$SHELLRC_DIR/deployment/configure/postinstall/postinstall.sh" "$SHELLRC_DIR"
}

configure-vim-ycm() {
    python3 $SHELLRC_DIR/components/vim/plugins/YouCompleteMe/install.py --clang-completer --clangd-completer
}


configure-vim-color-coded() {
    rm -f "$SHELLRC_DIR/components/vim/plugins/color_coded/CMakeCache.txt"
    rm -rf "$SHELLRC_DIR/components/vim/plugins/color_coded/build"
    mkdir "$SHELLRC_DIR/components/vim/plugins/color_coded/build"
    (cd "$SHELLRC_DIR/components/vim/plugins/color_coded/build" && cmake .. && make install && make clean && make clean_clang)
}

configure-vim() {
    configure-vim-ycm && configure-vim-color-coded
}

source "$SHELLRC_DIR/lib/lib.sh"
export -f script-directory
export -f __script-directory
export -f include

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

echo "Creating backups"
if ! "$(script-directory)/backup.sh" "$SHELLRC_DIR/components"; then
    exit 1
fi
echo "Backups created in \"$HOME/ShellrcBackups\""

echo "Configuring components"
if ! "$(script-directory)/install.sh" "$SHELLRC_DIR/components"; then
    exit 1
fi
echo "Configuring components done"

echo "Configuring vim"
configure-vim
if [ $? != 0 ]; then
    exit 1
fi
echo "Configuring vim completion done"

