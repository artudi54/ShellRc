# CDPATH management - bidirectional sync and persistence via shellenv
[[ $- != *i* ]] && return

if [[ -v ZSH_VERSION ]]; then
    setopt autocd
fi

[[ -z "${CDPATH+x}" ]] && export CDPATH=""

# tie cdpath array to CDPATH string
bind-var CDPATH cdpath

# persist CDPATH changes to shellenv
shellenv sync CDPATH

