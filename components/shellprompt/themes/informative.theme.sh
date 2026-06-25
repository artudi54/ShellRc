unset PS1
unset PS2
unset PROMPT

_file-info() {
    local files=$(ls -A1 2>/dev/null | wc -l)
    local hidden=$(($files-$(ls -1 2>/dev/null | wc -l)))

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
    ls -lah 2>/dev/null | head -n 1 | awk '{ print $2 }'
}


# branch name
if [[ -v BASH_VERSION ]]; then
    _git-branch-arrow() {
        local branch="$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        if [ -n "$branch" ]; then
            printf ' -> \001%s\002%s\001%s\002' "${fg_bold[yellow]}" "${branch}" "${reset_color}"
        fi
    }
elif [[ -v ZSH_VERSION ]]; then
    _git-branch-arrow() {
        local branch="$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
        if [ -n "$branch" ]; then
            echo " -> %{${fg_bold[yellow]}%}${branch}%{${reset_color}%}"
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
if [[ -v BASH_VERSION ]]; then
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
        printf ' -> \001%s\002%s %s\001%s\002' "${fg[yellow]}" "$jobcount" "$form" "${reset_color}"
    }
elif [[ -v ZSH_VERSION ]]; then
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
        echo " -> %{${fg[yellow]}%}$jobcount $form%{${reset_color}%}"
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
if [[ -v BASH_VERSION ]]; then
    _return-code-format() {
        if [ "$1" -ne 0 ]; then
            printf ' -> \001%s\002%s\001%s\002' "${fg[red]}" "$1" "${reset_color}"
        fi
    }
elif [[ -v ZSH_VERSION ]]; then
    _return-code-format() {
        if [ "$1" -ne 0 ]; then
            echo " -> %{${fg[red]}%}$1%{${reset_color}%}"
        fi
    }
else
    _return-code-format() {
        if [ "$1" -ne 0 ]; then
            echo " -> $1"
        fi
    }
fi

# command execution time formatting
_exec-time-human() {
    local now=$1 start=$2

    local now_s=${now%.*} now_us=${now#*.}
    local start_s=${start%.*} start_us=${start#*.}
    now_us="${now_us}000000"; now_us=${now_us:0:6}
    start_us="${start_us}000000"; start_us=${start_us:0:6}

    local s=$(( now_s - start_s ))
    local us=$(( 10#$now_us - 10#$start_us ))
    if (( us < 0 )); then
        (( us += 1000000 ))
        (( s -= 1 ))
    fi
    local ms=$(( us / 1000 ))
    if (( us % 1000 >= 500 )); then
        (( ms += 1 ))
        if (( ms >= 1000 )); then
            (( ms -= 1000 ))
            (( s += 1 ))
        fi
    fi

    if (( s < 3 )); then
        return 1
    fi

    if (( s >= 3600 )); then
        printf '%dh %dm %d.%03ds' $((s / 3600)) $((s % 3600 / 60)) $((s % 60)) "$ms"
    elif (( s >= 60 )); then
        printf '%dm %d.%03ds' $((s / 60)) $((s % 60)) "$ms"
    else
        printf '%d.%03ds' "$s" "$ms"
    fi
}

if [[ -v BASH_VERSION ]]; then
    _exec-time-format() {
        local human
        human=$(_exec-time-human "$1" "$2") || return
        printf ' -> \001%s\002%s\001%s\002' "${fg[yellow]}" "$human" "${reset_color}"
    }
elif [[ -v ZSH_VERSION ]]; then
    _exec-time-format() {
        local human
        human=$(_exec-time-human "$1" "$2") || return
        echo " -> %{${fg[yellow]}%}${human}%{${reset_color}%}"
    }
else
    _exec-time-format() {
        local human
        human=$(_exec-time-human "$1" "$2") || return
        printf ' -> %s' "$human"
    }
fi

# preexec hook for command timing
__shellprompt_cmd_start=""
__shellprompt-theme-preexec() {
    __shellprompt_cmd_start=$(date +%s.%N)
}
add-zsh-hook preexec __shellprompt-theme-preexec

# tty information
_tty() {
    local tty=$(tty)
    echo ${tty:5}
}

# ip address
_ip-address() {
    local ip
    ip=$(ip -4 route get 1.1.1.1 2>/dev/null | grep -oP 'src \K\S+')
    if [[ -n "$ip" ]]; then
        echo "$ip"
    else
        echo "no ip"
    fi
}

make-prompt() {
    local code=$?
    local exec_time_fmt=""
    if [[ -n "$__shellprompt_cmd_start" ]]; then
        local now=$(date +%s.%N)
        local start=$__shellprompt_cmd_start
        __shellprompt_cmd_start=""
        exec_time_fmt=$(_exec-time-format "$now" "$start")
    fi
    if [[ -v BASH_VERSION ]]; then
        PS1="\n\[${fg[cyan]}\]\$(date)\[${reset_color}\]\$(_jobs-arrow) -> \[${fg_bold[yellow]}\]\$(_ip-address)\[${reset_color}\] -> \[${fg_bold[magenta]}\]\$(_tty)\[${reset_color}\]\n\[${fg_bold[green]}\]\$PWD\[${reset_color}\]\$(_git-branch-arrow) -> \[${fg_bold[cyan]}\]\$(_file-info)\[${reset_color}\] -> \[${fg_bold[magenta]}\]\$(_file-size)\[${reset_color}\]\n\[${fg_bold[blue]}\]\u\[${fg_bold[white]}\]@\[${fg_bold[magenta]}\]\h\[${reset_color}\]${exec_time_fmt}\$(_return-code-format '$code') -> "
    elif [[ -v ZSH_VERSION ]]; then
        PS1=$'\n'"%{${fg[cyan]}%}\$(date)%{${reset_color}%}\$(_jobs-arrow) -> %{${fg_bold[yellow]}%}\$(_ip-address)%{${reset_color}%} -> %{${fg_bold[magenta]}%}\$(_tty)%{${reset_color}%}"$'\n'"%{${fg_bold[green]}%}\$PWD%{${reset_color}%}\$(_git-branch-arrow) -> %{${fg_bold[cyan]}%}\$(_file-info)%{${reset_color}%} -> %{${fg_bold[magenta]}%}\$(_file-size)%{${reset_color}%}"$'\n'"%{${fg_bold[blue]}%}%n%{${fg_bold[white]}%}@%{${fg_bold[magenta]}%}%m%{${reset_color}%}${exec_time_fmt}\$(_return-code-format '$code') -> "
    fi
}
