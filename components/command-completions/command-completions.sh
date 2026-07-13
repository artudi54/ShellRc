# completions for bash and zsh

# interactive shell only
[[ $- != *i* ]] && return

if [[ -v ZSH_VERSION ]]; then
    include "zsh-completions/zsh-completions.plugin.zsh"

    # aliases completion
    setopt completealiases

    # first tab completion
    setopt nolistambiguous

    # keep trailing / after completing a symlink to a directory when the next
    # character (e.g. <enter>, space) would otherwise cause zsh to strip it —
    # matches bash behavior so `ll ~/link<tab><enter>` lists the target dir
    unsetopt autoremoveslash

    zstyle ':completion:*' auto-description 'specify: %d'
    zstyle ':completion:*' completer _expand _complete _correct _approximate
    zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'
    zstyle ':completion:*' format 'Completing %d'
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*' menu select=2
    zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==36=36}:${(s.:.)LS_COLORS}")';
    zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
    zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'm:{-_}={_-}' 'r:|[._-]=* r:|=* l:|=*'
    zstyle ':completion:*' menu select=long
    zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
    zstyle ':completion:*' use-compctl false
    zstyle ':completion:*' verbose true

    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
    zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

elif [[ -v BASH_VERSION ]]; then
    include "install/share/bash-completion/bash_completion"

    # ignore case in completion
    bind 'set completion-ignore-case on'

    # treat hyphens and underscores as equivalent
    bind "set completion-map-case on"

    # display matches for ambiguous patterns at first tab press
    bind "set show-all-if-ambiguous on"

    # add a trailing slash when autocompleting symlinks to directories
    bind "set mark-symlinked-directories on"

    # zsh like completion
    bind "set menu-complete-display-prefix on"
    bind "set colored-completion-prefix on"
    bind "set colored-stats on"
fi
