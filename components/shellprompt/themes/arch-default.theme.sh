unset PS1
unset PS2
unset PROMPT

if [[ -v BASH_VERSION ]]; then
    PS1="\[${fg_bold[red]}\][\h\[${fg_bold[cyan]}\] \W\[${fg_bold[red]}\]]\$\[${reset_color}\] "
elif [[ -v ZSH_VERSION ]]; then
    PS1="%{${fg_bold[red]}%}[%m%{${fg_bold[cyan]}%} %1~%{${fg_bold[red]}%}]%(#.#.$)%{${reset_color}%} "
fi
