#append history bash-zsh compatible
if [ -n "$BASH_VERSION" ]; then
    append-history() {
        history -a
    }
elif [ -n "$ZSH_VERSION" ]; then
    append-history() {
        fc -W
    }
fi
