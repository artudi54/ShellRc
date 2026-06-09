# ls command aliases

# Interactive shell only
[[ $- != *i* ]] && return

# Make defaults a little bit nicer
alias ls='ls --color=auto -vh'
alias dir='dir --color=auto -vh'
alias vdir='vdir --color=auto -vh'

alias l='ls'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'
