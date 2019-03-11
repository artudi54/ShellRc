# package manager aliases ('s' stands for system - running with sudo)

# snap
alias sinstall-snap='sudo snap install'
alias sinstall-snap-cl='sudo snap install --classic'
alias sremove-snap='sudo snap remove'
alias supdate-snap='sudo snap refresh'

# flatpak
alias sinstall-flatpak='sudo flatpak install'
alias sremove-flatpak='sudo flatpak remove'
alias supdate-flatpak='sudo flatpak update'

#pip
alias sinstall-pip='sudo -H pip3 install'
alias sremove-pip='sudo -H pip3 uninstall'

#apt
aliases_apt() {
    alias supdate='sudo apt update && sudo apt upgrade -y && sudo snap refresh && sudo flatpak update -y'
    alias supdate-dist='sudo apt dist-upgrade'
    alias supdate-get='sudo apt update'
    alias supdate-list='sudo apt list --upgradable'

    alias sinstall='sudo apt install'
    alias sinstall-system='sinstall'
    alias sremove='sudo apt remove'
    alias sremove-all='sudo apt remove --purge'
    alias sremove-auto='sudo apt autoremove'

    alias srepadd='sudo add-apt-repository'
    alias srepremove='sudo add-apt-repository -r'
    alias slist='(sudo apt list --installed 2>/dev/null && sudo snap list && sudo flatpak list && sudo -H pip3 list -v)'
}

# dnf
aliases_dnf() {
    alias supdate='sudo dnf upgrade'
    alias supdate-dist='sudo dnf system-upgrade download'
    alias supdate-get='sudo dnf check-update'
    alias supdate-list='sudo dnf list --upgrades'

    alias sinstall='sudo dnf install'
    alias sremove='sudo dnf remove'
    alias sremove-all='#todo'
    alias sremove-auto='sudo dnf autoremove'
}

if which apt >/dev/null 2>&1; then
    aliases_apt
elif which dnf >/dev/null 2>&1; then
    aliases_dnf
fi

unset -f aliases_apt
unset -f aliases_dnf
