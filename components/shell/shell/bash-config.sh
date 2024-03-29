# check if running interactively
if [[ $- != *i* ]]; then
    return
fi

# disable ctrl-s
stty -ixon

# append to the history file, don't overwrite it
shopt -s histappend

# save multi-line commands as one command
shopt -s cmdhist

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

# don't put duplicate lines or lines starting with space in the history
HISTCONTROL="erasedups:ignoreboth"

# zsh like completion
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind "set colored-completion-prefix on"
