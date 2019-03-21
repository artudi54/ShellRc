# History
setopt histignorealldups
setopt histignorespace
setopt sharehistory
setopt appendhistory

# extended globbing
setopt extendedglob

# aliases completion
setopt completealiases

# fist tab completion
setopt nolistambiguous

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Use modern completion system
autoload -Uz compinit && compinit -d "$shellhistory_dir/zcompdump.log"
autoload -Uz compaudit && compaudit -d "$shellhistory_dir/zcompdump.log"
autoload -Uz bashcompinit && bashcompinit -d "$shellhistory_dir/zcompdump.log"

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
