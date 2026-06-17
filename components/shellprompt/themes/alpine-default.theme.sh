unset PS1
unset PS2
unset PROMPT

# Alpine default: minimal, hostname:dir$ (no username, no colors)
if [[ -v BASH_VERSION ]]; then
    PS1="\h:\w\$ "
elif [[ -v ZSH_VERSION ]]; then
    PS1="%m:%~%(#.#.$) "
fi
