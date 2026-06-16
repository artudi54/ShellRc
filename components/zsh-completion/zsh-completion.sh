# Compatibility for zsh to use bash completion system

[[ ! -v ZSH_VERSION ]] && return
export skip_global_compinit=1

# interactive only
[[ $- != *i* ]] && return

# Guard against being loaded more than once
[[ -v __SHELLRC_COMPINIT_LOADED ]] && return
__SHELLRC_COMPINIT_LOADED=1

autoload -Uz compinit && compinit -d "$SHELLRC_STATE_DIR/zcompdump.log"
autoload -Uz bashcompinit && bashcompinit

# Clean the guard flag after startup completes
__shellrc_compinit_cleanup() {
    unset __SHELLRC_COMPINIT_LOADED
    precmd_functions=(${precmd_functions:#__shellrc_compinit_cleanup})
}
precmd_functions+=(__shellrc_compinit_cleanup)

