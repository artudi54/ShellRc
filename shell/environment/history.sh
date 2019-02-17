# history directory
export SHELLHISTORY_DIR="$HOME/.config/ShellHistory"
if [[ ! -d "$SHELLHISTORY_DIR" ]]; then
    mkdir "$SHELLHISTORY_DIR"
fi

# hitory size
HISTSIZE=5000
HISTFILESIZE=5000
SAVEHIST=5000

# history file
HISTFILE=~/.config/ShellHistory/shell_history.log

# append history on every command both for bash and zsh
precmd_functions+=(append-history)