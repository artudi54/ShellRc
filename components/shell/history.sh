# Shell history configuration for bash and zsh
[[ $- != *i* ]] && return

# history size
HISTSIZE=10000
HISTFILESIZE=10000
SAVEHIST=10000

# shared history file - both shells use plain format
export HISTFILE="$SHELLRC_STATE_DIR/shell_history.log"

if [[ -v BASH_VERSION ]]; then
    shopt -s histappend
    shopt -s cmdhist
    HISTCONTROL="erasedups:ignoreboth"

    __append-history() {
        history -a
        history -c
        history -r
    }
elif [[ -v ZSH_VERSION ]]; then
    # plain format for bash compatibility (sharehistory forces extended format)
    unsetopt extendedhistory
    setopt incappendhistory
    setopt histignorealldups
    setopt histignorespace

    __append-history() {
        fc -R
    }
fi

autoload -Uz add-zsh-hook
add-zsh-hook precmd __append-history
add-zsh-hook preexec __append-history

