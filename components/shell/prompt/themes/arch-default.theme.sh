unset PS1
unset PS2
unset PROMPT

if [ -n "$BASH_VERSION" ]; then
    PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
elif [ -n "$ZSH_VERSION" ]; then
    PS1=$'%{$fg_bold[green]%}%n@%M%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}$ '
    PS1=$'%{$fg_bold[red]%}[%n@%{$fg_bold[cyan]%}%m %{$fg_bold[red]%}%1~]$%{$reset_color%} '
fi
