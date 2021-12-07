# Compatibility for zsh to use bash completion system

if [[ -v ZSH_VERSION ]]; then
    export skip_global_compinit=1
    autoload -Uz compinit && compinit -d "$SHELLRC_CACHE_DIR/zcompdump.log"
    autoload -Uz compaudit && compaudit
    autoload -Uz bashcompinit && bashcompinit
fi

