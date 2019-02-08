unset PS1
unset PROMPT
unset PROMPT_COMMAND

if [ -n "$BASH_VERSION" ]; then
    PS1='[$?]$ '
elif [ -n "$ZSH_VERSION" ]; then
    PS1=$'%{$fg[cyan]%}%D{%c}%{$reset_color%}\n%{$fg[green]%}%/%{$reset_color%}\n%{$fg_bold[yellow]%}[$?]%{$reset_color%}$ '
fi