dir="$(script_directory)"

export WGETRC="$dir/wget.conf.gen"
# generate the file
cat "$dir/wget.conf" | envsubst > "$dir/wget.conf.gen"
