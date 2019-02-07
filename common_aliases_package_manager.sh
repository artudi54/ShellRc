# package tool aliases ('s' stands for system - running with sudo)

# snap
alias sinstall-snap='sudo snap install'
alias sinstall-snap-cl='sudo snap install --classic'
alias sremove-snap='sudo snap remove'

#pip
alias sinstall-pip='sudo -H pip3 install'
alias sremove-pip='sudo -H pip3 uninstall'

#apt
aliases_apt() {
    alias supdate='sudo apt update && sudo apt upgrade -y && sudo snap refresh'
    alias supdate-dist='sudo apt dist-upgrade'
    alias supdate-get='sudo apt update'
    alias supdate-list='sudo apt list --upgradable'

    alias sinstall='sudo apt install'
    alias sremove='sudo apt remove'
    alias sremove-all='sudo apt remove --purge'
    alias sremove-auto='sudo apt autoremove'

    alias srepadd='sudo add-apt-repository'
    alias srepremove='sudo add-apt-repository -r'
    alias slist='(sudo apt list --installed && sudo snap list && sudo -H pip3 list -v)'
}

# dnf
aliases_dnf() {
    alias supdate='sudo dnf upgrade'
    alias supdate-dist='#todo'
    alias supdate-get='sudo dnf check-update'
    alias supdate-list='sudo dnf check-update'

    alias sinstall='sudo dnf install'
    alias sremove='sudo dnf remove'
    alias sremove-all='#todo'
    alias sremove-auto='sudo dnf autoremove'
}

if which apt >/dev/null; then
    aliases_apt
elif which dnf >/dev/null; then
    aliases_dnf
fi

unset -f aliases_apt
unset -f aliases_dnf