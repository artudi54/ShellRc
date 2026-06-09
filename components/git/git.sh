dir="$(script_directory)"


if [[ "$PATH" != *"$dir/bin"* ]]; then
    export PATH="$PATH:$dir/bin"
fi

if [[ "$MANPATH" != *"$dir/man"* ]]; then
    export MANPATH="$MANPATH:$dir/man"
fi


# interactive shell only
[[ $- != *i* ]] && return

if [[ -n "$BASH_VERSION" ]]; then
    for f in "$dir"/completions/bash/*; do
        include "$f"
    done
elif [[ -n "$ZSH_VERSION" ]]; then
    for f in "$dir"/completions/zsh/*; do
        include "$f"
    done
fi
