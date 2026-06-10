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
## relative includes, script directory
load-component script-sourcing
## make sure that xdg dirs are defined and created
load-component xdg-dirs
## shellrc-specific dirs created under xdg dirs
load-component shellrc-dirs
## enable zsh completion + bash completion compatibility
load-component zsh-completion
## core utility functions (array helpers, etc.)
load-component core-utils
## add partial hook support to bash
load-component bash-hooks
## bidirectional sync between array and string variables in bash
load-component bash-bound-vars
## automatically add alias command completion
load-component completable-aliases
## configure PATH to include user bin dir(s)
load-component user-bin
## utility for persistent env variable management
load-component shellenv
## ANSI colour variables for use by other components
load-component ascii-colors

# shell setup
load-component command-completions
load-component terminal-inputs
load-component shell-history
load-component cdpath
load-component common-aliases
load-component common-util
load-component shell

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

