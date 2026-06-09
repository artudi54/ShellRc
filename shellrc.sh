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

# needs to be loaded first to allow relative includes
load-component script-sourcing

# core shell settings and utilities required for other components
load-component xdg-dirs
load-component shellrc-dirs
load-component zsh-completion
load-component bash-hooks
load-component completable-aliases
load-component user-bin
load-component shellenv

# shell setup
load-component command-completions
load-component input
load-component shell

# xdg overrides for clean home directory
load-component xdg

# app configs
load-component ark
load-component dolphin
load-component emacs
load-component fastfetch
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

