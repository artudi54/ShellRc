# interactive shell only
[[ $- != *i* ]] && return

#append history bash-zsh compatible
if [ -n "$BASH_VERSION" ]; then
    __append-history() {
        history -a
        history -c
        history -r
    }
elif [ -n "$ZSH_VERSION" ]; then
    __append-history() {
        fc -W
    }
fi

# hitory size
HISTSIZE=10000
HISTFILESIZE=10000
SAVEHIST=10000

# history file
HISTFILE="$SHELLRC_STATE_DIR/shell_history.log"

# append history on every command both for bash and zsh
precmd_functions+=(__append-history)

