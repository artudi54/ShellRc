unset PS1
unset PS2
unset PROMPT

_file-info() {
    local files=$(ls -A1 | wc -l)
    local hidden=$(($files-$(ls -1 | wc -l)))

    local form
    if [ "$files" -eq 1 ]; then
        form="file"
    else
        form="files"
    fi

    if [ "$hidden" -ne "0" ]; then
        echo "$files $form ($hidden hidden)"
    else
        echo "$files $form"
    fi
}

_file-size() {
    ls -lah | head -n 1 | awk '{ print $2 }'
}


# branch name
if [ -n "$BASH_VERSION" ]; then
    _git-branch-arrow() {
        local branch="$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        if [ -n "$branch" ]; then
            printf " -> \001\033[1;93m\002${branch}\001\033[0m\002"
        fi
    }
elif [ -n "$ZSH_VERSION" ]; then
    _git-branch-arrow() {
        local branch="$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        if [ -n "$branch" ]; then
            echo " -> %{$fg_bold[yellow]%}${branch}%{$reset_color%}"
        fi
    }
else
    _git-branch-arrow() {
        local branch="$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        if [ -n "$branch" ]; then
            printf " -> ${branch}"
        fi
    }
fi

# jobs information
if [ -n "$BASH_VERSION" ]; then
    _jobs-arrow() {
        local jobcount=$(jobs -l | grep -P '^\[\d+]' | wc -l)    
        if [ "$jobcount" -eq 0 ]; then
            return
        fi

        local form
        if [ "$jobcount" -eq 1 ]; then
            form="job"
        else
            form="jobs"
        fi
        printf " -> \001\033[33m\002$jobcount $form\001\033[0m\002"
    }
elif [ -n "$ZSH_VERSION" ]; then
    _jobs-arrow() {
        local jobcount=$(jobs -l | grep -P '^\[\d+]' | wc -l)    
        if [ "$jobcount" -eq 0 ]; then
            return
        fi

        local form
        if [ "$jobcount" -eq 1 ]; then
            form="job"
        else
            form="jobs"
        fi
        echo " -> %{$fg[yellow]%}$jobcount $form%{$reset_color%}"
    }
else
    _jobs-arrow() {
        local jobcount=$(jobs -l | grep -P '^\[\d+]' | wc -l)    
        if [ "$jobcount" -eq 0 ]; then
            return
        fi

        local form
        if [ "$jobcount" -eq 1 ]; then
            form="job"
        else
            form="jobs"
        fi
        echo " -> $jobcount $form"
    }
fi


# return code formatting
if [ -n "$BASH_VERSION" ]; then
    _return-code-format() {
        if [ "$1" -ne 0 ]; then
            printf " -> \001\033[31m\002$1\001\033[0m\002";
        fi
    }
elif [ -n "$ZSH_VERSION" ]; then
    _return-code-format() {
        if [ "$1" -ne 0 ]; then
            echo " -> %{$fg[red]%}$1%{$reset_color%}"
        fi
    }
else
    _return-code-format() {
        if [ "$1" -ne 0 ]; then
            echo " -> $1"
        fi
    }
fi

# tty information
_tty() {
    local tty=$(tty)
    echo ${tty:5}
}

make-prompt() {
    local code=$?
    if [ -n "$BASH_VERSION" ]; then
        PS1='\n\[\033[36m\]$(date)\[\033[0m\]$(_jobs-arrow)\n\[\033[01;32m\]$PWD\[\033[0m\]$(_git-branch-arrow) -> \[\033[1;36m\]$(_file-info)\[\033[0m\] -> \[\033[1;35m\]$(_file-size)\[\033[0m\]\n\[\033[1;34m\]\u@\h\[\033[0m\] -> \[\033[1;35m\]$(_tty)\[\033[0m\]$(_return-code-format '$code') -> '
    elif [ -n "$ZSH_VERSION" ]; then
        PS1=$'\n%{$fg[cyan]%}$(date)%{$reset_color%}$(_jobs-arrow)\n%{$fg_bold[green]%}$PWD%{$reset_color%}$(_git-branch-arrow) -> %{$fg_bold[cyan]%}$(_file-info)%{$reset_color%} -> %{$fg_bold[magenta]%}$(_file-size)%{$reset_color%}\n%{$fg_bold[blue]%}%n@%M%{$reset_color%} -> %{$fg_bold[magenta]%}$(_tty)%{$reset_color%}$(_return-code-format '$code') -> '
    fi
}
