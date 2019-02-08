unset PS1
unset PROMPT
unset PROMPT_COMMAND

# git branch name
_git-branch() {
	git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# fancy return code face
if [ -n "$BASH_VERSION" ]; then
    _return-face() {
        if [ "$?" -eq 0 ]; then
            printf '\001\033[1;34m\002(^_^)\001\033[0m\002'
        else
            printf '\001\033[1;31m\002(O_O)\001\033[0m\002'
        fi
    }
elif [ -n "$ZSH_VERSION" ]; then
    _return-face() {
        if [ "$?" -eq 0 ]; then
            echo "%{$fg_bold[blue]%}(^_^)%{$reset_color%}%"
        else
            echo "%{$fg_bold[red]%}(O_O)%{$reset_color%}%"
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

if [ -n "$BASH_VERSION" ]; then
    PS1='$(_return-face)\[\033[00m\]\[\033[01;33m\][\t]\[\033[00m\] \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[01;31m\]$(_git-branch)\[\033[00m\]\$ '
elif [ -n "$ZSH_VERSION" ]; then
    PS1=$'$(_return-face){$fg_bold[yellow]%}[%*]%{$reset_color%} %{$fg_bold[green]%}%n@%M%{$reset_color%}:%{$fg_bold[blue]%}%1~%{$reset_color%}%{$fg_bold[red]%}$(_git-branch)%{$reset_color%}$ '
fi