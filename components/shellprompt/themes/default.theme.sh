unset PS1
unset PS2
unset PROMPT

# git branch name
_git-branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# fancy return code face
if [[ -v BASH_VERSION ]]; then
    _return-face() {
        if [ "$?" -eq 0 ]; then
            printf '\001%s\002(^_^)\001%s\002' "${fg_bold[blue]}" "${reset_color}"
        else
            printf '\001%s\002(O_O)\001%s\002' "${fg_bold[red]}" "${reset_color}"
        fi
    }
elif [[ -v ZSH_VERSION ]]; then
    _return-face() {
        if [ "$?" -eq 0 ]; then
            echo "%{${fg_bold[blue]}%}(^_^)%{${reset_color}%}"
        else
            echo "%{${fg_bold[red]}%}(O_O)%{${reset_color}%}"
        fi
    }
else
    _return-face() {
        if [ "$?" -eq 0 ]; then
            printf '(^_^)'
        else
            printf '(O_O)'
        fi
    }
fi



if [[ -v BASH_VERSION ]]; then
    PS1="\$(_return-face)\[${fg_bold[yellow]}\][\t]\[${reset_color}\] \[${fg_bold[green]}\]\u@\h\[${reset_color}\]:\[${fg_bold[blue]}\]\W\[${reset_color}\]\[${fg_bold[red]}\]\$(_git-branch)\[${reset_color}\]\$ "
elif [[ -v ZSH_VERSION ]]; then
    PS1="\$(_return-face)%{${fg_bold[yellow]}%}[%D{%H:%m:%S}]%{${reset_color}%} %{${fg_bold[green]}%}%n@%m%{${reset_color}%}:%{${fg_bold[blue]}%}%1~%{${reset_color}%}%{${fg_bold[red]}%}\$(_git-branch)%{${reset_color}%}%# "
fi
