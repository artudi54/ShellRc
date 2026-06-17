unset PS1
unset PS2
unset PROMPT

# Gentoo default: green user@host + blue dir for users, red host + blue dir for root
if [[ -v BASH_VERSION ]]; then
    if [[ $EUID -eq 0 ]]; then
        PS1="\[${fg_bold[red]}\]\h\[${fg_bold[blue]}\] \W \$\[${reset_color}\] "
    else
        PS1="\[${fg_bold[green]}\]\u@\h\[${fg_bold[blue]}\] \w \$\[${reset_color}\] "
    fi
elif [[ -v ZSH_VERSION ]]; then
    if [[ $EUID -eq 0 ]]; then
        PS1="%{${fg_bold[red]}%}%m%{${fg_bold[blue]}%} %1~ %(#.#.$)%{${reset_color}%} "
    else
        PS1="%{${fg_bold[green]}%}%n@%m%{${fg_bold[blue]}%} %~ %(#.#.$)%{${reset_color}%} "
    fi
fi
