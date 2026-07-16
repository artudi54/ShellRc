#  _____  _            _  _ ______
# /  ___|| |          | || || ___ \
# \ `--. | |__    ___ | || || |_/ /  ___
#  `--. \| '_ \  / _ \| || ||    /  / __|
# /\__/ /| | | ||  __/| || || |\ \ | (__
# \____/ |_| |_| \___||_||_|\_| \_| \___|


# Main entry for shells
# Currently supports bash and zsh

# ShellRc root directory environmental variable
if [[ -v BASH_VERSION ]]; then
    export SHELLRC_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
elif [[ -v ZSH_VERSION ]]; then
    export SHELLRC_DIR="$(dirname "$(readlink -f "${(%):-%N}")")"
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
    declare -f shellrc-next >/dev/null 2>&1 && shellrc-next
}


# core shell settings and utilities required for other components, order is important
load-component script-sourcing
load-component shellrc-hooks
load-component directory-setup
load-component bash-zsh-compatibility
load-component core-utils
load-component completable-aliases
load-component shellenv

# shell setup
load-component shell
load-component shellprompt
load-component command-completions
load-component syntax-highlighting
load-component common-aliases
load-component common-util
load-component shellrc


# app configs
load-component xdg # xdg overrides for clean home directory
load-component user-dirs
load-component ark
load-component dolphin
load-component emacs
load-component fastfetch
load-component gcc
load-component git
load-component go
load-component konsole
load-component less
load-component ls
load-component mediainfo
load-component npm
load-component p4
load-component python
load-component screen
load-component sudo
load-component tmux
load-component vcpkg
load-component vim
load-component wget
load-component wine
load-component yakuake

# Run registered initialization hooks
shellrc-exit
unset -f load-component

