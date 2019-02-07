source "$SHELLRC_DIR/common_aliases_package_manager.sh"

# makes aliases work with sudo
alias sudo='sudo '

# editor
alias edit=notepadqq

# explorer
alias explorer=pcmanfm

# clear
alias cls=clear

# ls aliases
alias ll='ls -lh'
alias lla='ls -alh'
alias la='ls -a'
alias l='ls'
# TODO: ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\// /g' -e 's/^/ /'
# TODO: tree

# cd aliases
alias cd..='cd ..'
alias cd-='cd -'
alias cd~='cd ~'

alias .-='cd -'

alias cd1='cd ..'
alias ..='cd ..'
alias .1='cd ..'

alias cd2='cd ../..'
alias .2='cd ../..'
alias ...='cd ../..'

alias cd3='cd ../../..'
alias .3='cd ../../..'
alias ....='cd ../../..'

alias cd4='cd ../../../..'
alias .4='cd ../../../..'
alias .....='cd ../../../..'


alias cd5='cd ../../../../..'
alias .5='cd ../../../../..'
alias ......='cd ../../../../..'

alias cd6='cd ../../../../../..'
alias .6='cd ../../../../../..'
alias .......='cd ../../../../../..'

alias cd7='cd ../../../../../../..'
alias .7='cd ../../../../../../..'
alias ........='cd ../../../../../../..'

alias cd8='cd ../../../../../../../..'
alias .8='cd ../../../../../../../..'
alias .........='cd ../../../../../../../..'

alias cd9='cd ../../../../../../../../..'
alias .9='cd ../../../../../../../../..'
alias ..........='cd ../../../../../../../../..'

# systemctl deamon service aliases
alias sctl='sudo systemctl'
alias sctl-start='sudo systemctl start'
alias sctl-status='sudo systemctl status'
alias sctl-stop='sudo systemctl stop'
alias sctl-restart='sudo systemctl restart'
alias sctl-enable='sudo systemctl enable'
alias sctl-disable='sudo systemctl disable'

alias uctl='systemctl --user'
alias uctl-start='systemctl --user start'
alias uctl-status='systemctl --user status'
alias uctl-stop='systemctl --user stop'
alias uctl-restart='systemctl --user restart'
alias uctl-enable='systemctl --user enable'
alias uctl-disable='systemctl --user disable'

# ps aliases
alias psgrep='ps aux | grep'

# df aliases
alias df='df -T'
alias dfh='df -h'

# network
alias ports='netstat -tulanp'
alias ping='ping -c 5'
alias wget='wget -c'
alias top='atop'

# exit aliases
alias :q='exit'
alias quit='exit'

# change ownership/permissions
alias chown-root='sudo chown root:root'
alias chown-me='sudo chown $USER:$USER'
alias chmod-exe='chmod a+x'

# java aliases
alias javar='java -jar'

# cmake aliases
alias cmake-release='cmake -DCMAKE_BUILD_TYPE=Release'
alias cmake-debug='cmake -DCMAKE_BUILD_TYPE=Debug'

# exe and wine utils
alias exe-extract-ico='wrestool -x -t 14'

# screen daemon
alias termscreen='screen -r termscreen'

# Add an 'alert' aliast for long running commands. Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

