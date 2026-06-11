dir="$(script_directory)"
libexecdir="$dir/lesspipe"

mkdir -p "$dir/completions/bash"
mkdir -p "$dir/completions/zsh"

sed "s|__LIBEXECDIR__|$libexecdir|g" "$dir/lesspipe/bash_completion" > "$dir/completions/bash/less"

{
    echo '_less() {'
    sed -e '1d' -e "s|__LIBEXECDIR__|$libexecdir|g" "$dir/lesspipe/zsh_completion"
    echo '}'
    echo 'compdef _less less'
} > "$dir/completions/zsh/less"
