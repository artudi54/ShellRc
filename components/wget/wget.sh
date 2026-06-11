__wget_dir="$(script_directory)"

export WGETRC="$__wget_dir/wget.conf.gen"

__wget-generate-wgetrc() {
    cat "$__wget_dir/wget.conf" | envsubst > "$__wget_dir/wget.conf.gen"
}

__wget-generate-wgetrc
precmd_functions+=(__wget-generate-wgetrc)
