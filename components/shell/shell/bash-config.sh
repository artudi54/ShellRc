[[ ! -v BASH_VERSION ]] && return

# interactive shell only
[[ $- != *i* ]] && return

# disable ctrl-s
stty -ixon

# check the window size after each command and, if necessary
shopt -s checkwinsize

# extended globbing
shopt -s globstar

# case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# ignore case in completion
bind 'set completion-ignore-case on'

# treat hyphens and underscores as equivalent
bind "set completion-map-case on"

# display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

# add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"

# zsh like completion
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind "set colored-completion-prefix on"
bind "set colored-stats on"
