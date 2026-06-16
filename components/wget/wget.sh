__wget_dir="$(script_directory)"

export WGETRC="$__wget_dir/wget.conf.gen"

__wget-generate-wgetrc() {
    # use shell parameter expansion instead of envsubst to avoid spawning
    # an external process that inflates the job count in shell-prompt
    local content pattern='$SHELLRC_STATE_DIR'
    content=$(<"$__wget_dir/wget.conf")
    printf '%s\n' "${content//$pattern/$SHELLRC_STATE_DIR}" > "$__wget_dir/wget.conf.gen"
}

__wget-generate-wgetrc
precmd_functions+=(__wget-generate-wgetrc)

