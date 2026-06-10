dir="$(script_directory)"


array-append-unique path "$dir/bin"
array-append-unique manpath "$dir/man"


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
