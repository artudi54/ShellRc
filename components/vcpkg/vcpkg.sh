dir="$(script_directory)"

export VCPKG_DISABLE_METRICS="1"
export VCPKG_ROOT="$dir/vcpkg"
array-append-unique path "$dir/bin"

# completions
[[ $- != *i* ]] && return
source "$VCPKG_ROOT/scripts/vcpkg_completion.bash"

