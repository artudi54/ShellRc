__wget_dir="$(script_directory)"

export WGETRC="$__wget_dir/wget.conf.gen"

__wget-generate-wgetrc() {
    envsubst > "$__wget_dir/wget.conf.gen" < "$__wget_dir/wget.conf"
}

__wget-generate-wgetrc
precmd_functions+=(__wget-generate-wgetrc)

