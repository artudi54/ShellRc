# enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# colours variables
C_BLACK='\e[0;30m'
C_RED='\e[0;31m'
C_GREEN='\e[0;32m'
C_BROWN='\e[0;33m'
C_BLUE='\e[0;34m'
C_PURPLE='\e[0;35m'
C_CYAN='\e[0;36m'
C_LIGHTGRAY='\e[0;37m'

C_DARKGRAY='\e[0;90m'
C_LIGHTRED='\e[0;91m'
C_LIGHTGREEN='\e[0;92m'
C_LIGHTYELLOW='\e[0;93m'
C_LIGHTBLUE='\e[0;94m'
C_LIGHTPURPLE='\e[0;95m'
C_LIGHTCYAN='\e[0;96m'
C_WHITE='\e[0;97m'

C_BLACK_BOLD='\e[1;30m'
C_RED_BOLD='\e[1;31m'
C_GREEN_BOLD='\e[1;32m'
C_BROWN_BOLD='\e[1;33m'
C_BLUE_BOLD='\e[1;34m'
C_PURPLE_BOLD='\e[1;35m'
C_CYAN_BOLD='\e[1;36m'
C_LIGHTGRAY_BOLD='\e[1;37m'

C_DARKGRAY_BOLD='\e[1;90m'
C_LIGHTRED_BOLD='\e[1;91m'
C_LIGHTGREEN_BOLD='\e[1;92m'
C_LIGHTYELLOW_BOLD='\e[1;93m'
C_LIGHTBLUE_BOLD='\e[1;94m'
C_LIGHTPURPLE_BOLD='\e[1;95m'
C_LIGHTCYAN_BOLD='\e[1;96m'
C_WHITE_BOLD='\e[1;97m'

C_NC='\e[0m' # No Color

