# Link XDG wrapper executables and desktop entries for installed apps.
# Each app is a folder lib/<app>/ gated on /usr/bin/<app>. While the app is
# installed, its wrapper(s) are linked into bin/ (on PATH) and its *.desktop
# entries into the applications dir; both are dropped otherwise. A folder may
# hold several desktop entries (e.g. code + code-url-handler) or extra wrappers.

dir="$(script_directory)"
lib_dir="$dir/lib"
bin_dir="$dir/bin"
applications_dir="$XDG_DATA_HOME/applications"

mkdir -p "$applications_dir"

# expose the wrappers on PATH
mkdir -p "$bin_dir"
if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
    PATH="$bin_dir:$PATH"
fi

# reconcile every app folder against /usr/bin/<app>
for app_dir in "$lib_dir"/*/; do
    app="${app_dir%/}"
    app="${app##*/}"
    installed=0
    [[ -e "/usr/bin/$app" ]] && installed=1

    for src in "$app_dir"*; do
        [[ -e "$src" ]] || continue
        name="${src##*/}"
        if [[ "$name" == *.desktop ]]; then
            target="$applications_dir/$name"
        else
            target="$bin_dir/$name"
        fi

        if (( installed )); then
            ln -sfT "$src" "$target"
        elif [[ -L "$target" && "$(readlink "$target")" == "$app_dir"* ]]; then
            # only ever remove links that point back into this app folder
            rm -f "$target"
        fi
    done
done

unset dir lib_dir bin_dir applications_dir app_dir app installed src name target
