# Use modern completion system
export skip_global_compinit=1
autoload -Uz compinit && compinit -d "$SHELLHISTORY_DIR/zcompdump.log"
autoload -Uz compaudit && compaudit -d "$SHELLHISTORY_DIR/zcompdump.log"
autoload -Uz bashcompinit && bashcompinit -d "$SHELLHISTORY_DIR/zcompdump.log"

# check if running interactively
if [[ -o login ]]; then
  return
fi

# History
setopt histignorealldups
setopt histignorespace
setopt sharehistory
setopt appendhistory

# extended globbing
setopt extendedglob
setopt +o nomatch

# aliases completion
setopt completealiases

# fist tab completion
setopt nolistambiguous

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


# help
autoload -Uz run-help

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'm:{-_}={_-}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
