[[ $- != *i* ]] && return

bind '"\e[1~": beginning-of-line'
bind '"\e[4~": end-of-line'

bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'
bind '"\e[5C": forward-word'
bind '"\e[5D": backward-word'
bind '"\e\e[C": forward-word'
bind '"\e\e[D": backward-word'

bind 'TAB: menu-complete'
bind '"\e[Z": menu-complete-backward'
