# editor
alias edit=notepadqq

# explorer
alias explorer=dolphin

# ps aliases
alias psgrep='ps aux | grep'

# Add an 'alert' aliast for long running commands. Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
