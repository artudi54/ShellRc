# Link XDG wrapper executables and desktop entries for installed apps.
# lib/<app> and lib/desktop/<app>.desktop are linked into bin/ (on PATH) and
# the applications dir while /usr/bin/<app> exists, and dropped otherwise.
# lib/ and lib/desktop/ always hold at least one entry, so their globs match.

dir="$(script_directory)"
lib_dir="$dir/lib"
bin_dir="$dir/bin"
desktop_dir="$lib_dir/desktop"
applications_dir="$XDG_DATA_HOME/applications"

mkdir -p "$applications_dir"

# expose the wrappers on PATH
mkdir -p "$bin_dir"
if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
    PATH="$bin_dir:$PATH"
fi

# executables: lib/<app> -> bin/<app>
for wrapper in "$lib_dir"/*; do
    [[ -f "$wrapper" ]] || continue
    app="${wrapper##*/}"
    if [[ -e "/usr/bin/$app" ]]; then
        ln -sfT "$wrapper" "$bin_dir/$app"
    elif [[ -L "$bin_dir/$app" ]]; then
        rm -f "$bin_dir/$app"
    fi
done

# desktop entries: lib/desktop/<app>.desktop -> applications dir (only our own
# links are ever removed)
for entry_path in "$desktop_dir"/*.desktop; do
    entry="${entry_path##*/}"
    app="${entry%.desktop}"
    target="$applications_dir/$entry"
    if [[ -e "/usr/bin/$app" ]]; then
        ln -sfT "$entry_path" "$target"
    elif [[ -L "$target" && "$(readlink "$target")" == "$desktop_dir"/* ]]; then
        rm -f "$target"
    fi
done

unset dir lib_dir bin_dir desktop_dir applications_dir wrapper app entry entry_path target

