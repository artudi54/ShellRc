dir="$(script_directory)"
[[ ! -d "$dir/vcpkg" ]] && git clone https://github.com/microsoft/vcpkg "$dir/vcpkg"
"$dir/vcpkg/bootstrap-vcpkg.sh"
mkdir -p "$dir/bin"
ln -sfT "$dir/vcpkg/vcpkg" "$dir/bin/vcpkg"

