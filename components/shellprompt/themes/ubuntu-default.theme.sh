unset PS1
unset PS2
unset PROMPT

if [[ -v BASH_VERSION ]]; then
    PS1="\[${fg_bold[green]}\]\u@\h\[${reset_color}\]:\[${fg_bold[blue]}\]\w\[${reset_color}\]\$ "
elif [[ -v ZSH_VERSION ]]; then
    PS1="%{${fg_bold[green]}%}%n@%m%{${reset_color}%}:%{${fg_bold[blue]}%}%~%{${reset_color}%}%(#.#.$) "
fi
