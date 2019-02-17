unset PS1
unset PROMPT

if [ -n "$BASH_VERSION" ]; then
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ '
elif [ -n "$ZSH_VERSION" ]; then
    PS1=$'%{$fg_bold[green]%}%n@%M%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}$ '
fi