#append history bash-zsh compatible
if [ -n "$BASH_VERSION" ]; then
    append-history() {
        history -a
        history -c
        history -r
    }
elif [ -n "$ZSH_VERSION" ]; then
    append-history() {
        fc -W
    }
fi
