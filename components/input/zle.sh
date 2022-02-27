bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

bindkey "^[[1;5C" forward-word
bindkey "^[[5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[5D" backward-word

bindkey  "^[[3~" delete-char

bindkey "TAB" expand-or-complete
bindkey "\e[Z" reverse-menu-complete

