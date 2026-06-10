# CDPATH management - bidirectional sync and persistence via shellenv
[[ $- != *i* ]] && return

if [[ -v ZSH_VERSION ]]; then
    setopt autocd
fi

# tie cdpath array to CDPATH string
bind-var CDPATH cdpath

# persist CDPATH changes to shellenv
[[ -z "${CDPATH+x}" ]] && export CDPATH=""
shellenv sync CDPATH

