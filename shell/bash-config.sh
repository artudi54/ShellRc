# append to the history file, don't overwrite it
shopt -s histappend

# save multi-line commands as one command
shopt -s cmdhist

# check the window size after each command and, if necessary
shopt -s checkwinsize

# if set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;


# enable programmable completion features 
if ! shopt -oq posix; then 
    if [ -f /usr/share/bash-completion/bash_completion ]; then 
        source /usr/share/bash-completion/bash_completion 
    elif [ -f /etc/bash_completion ]; then 
        source /etc/bash_completion 
    fi 
fi 

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