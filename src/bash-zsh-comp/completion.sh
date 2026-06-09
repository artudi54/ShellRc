# Compatibility for zsh to use bash completion system

[[ ! -v ZSH_VERSION ]] && return
export skip_global_compinit=1

# interactive only
[[ $- != *i* ]] && return

autoload -Uz compinit && compinit -d "$SHELLRC_STATE_DIR/zcompdump.log"
autoload -Uz compaudit && compaudit
autoload -Uz bashcompinit && bashcompinit

