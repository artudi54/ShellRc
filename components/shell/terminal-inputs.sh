# Configuration for custom input keycodes for bash (readline) and zsh (ZLE)
[[ $- != *i* ]] && return

if [[ -v BASH_VERSION ]]; then
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

    bind '"\e\r": "\C-q\C-j"'
elif [[ -v ZSH_VERSION ]]; then
    bindkey "\e[1~" beginning-of-line
    bindkey "\e[4~" end-of-line
    bindkey "\e[H" beginning-of-line
    bindkey "\e[F" end-of-line

    bindkey "^[[1;5C" forward-word
    bindkey "^[[5C" forward-word
    bindkey "^[[1;5D" backward-word
    bindkey "^[[5D" backward-word

    bindkey "^[[3~" delete-char

    bindkey "TAB" expand-or-complete
    bindkey "\e[Z" reverse-menu-complete
fi
