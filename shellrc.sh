#  _____  _            _  _ ______
# /  ___|| |          | || || ___ \
# \ `--. | |__    ___ | || || |_/ /  ___
#  `--. \| '_ \  / _ \| || ||    /  / __|
# /\__/ /| | | ||  __/| || || |\ \ | (__
# \____/ |_| |_| \___||_||_|\_| \_| \___|


# Main entry for shells
# Currently supports bash and zsh

# ShellRc root directory environmental variable
if [ -n "$BASH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$BASH_SOURCE")"
elif [ -n "$ZSH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "${(%):-%N}")"
fi

load-component() {
    local name="$1"
    local dir="$SHELLRC_DIR/components/$name"
    if [[ ! -d "$dir" ]]; then
        echo "shellrc.sh: component '$name' not found: $dir" 1>&2
        return 1
    fi
    local entry="$dir/$name.sh"
    [[ -f "$entry" ]] && source "$entry"
}

# core shell settings and utilities required for other components, order is important
load-component script-sourcing
load-component xdg-dirs
load-component shellrc-dirs
load-component zsh-completion
load-component core-utils
load-component bash-hooks
load-component bash-bound-vars
load-component completable-aliases
load-component user-bin
load-component shellenv
load-component shellrc

# shell setup
load-component shell
load-component command-completions
load-component terminal-inputs
load-component shell-history
load-component syntax-highlighting
load-component cdpath
load-component common-aliases
load-component common-util

# xdg overrides for clean home directory
load-component xdg

# app configs
load-component ark
load-component dolphin
load-component emacs
load-component fastfetch
load-component gcc
load-component git
load-component konsole
load-component less
load-component ls
load-component npm
load-component python
load-component screen
load-component sudo
load-component tmux
load-component vim
load-component wget
load-component wine
load-component yakuake

