include "install.sh"
include "user-dirs.dirs"

# create directories
while read xdgVar; do
    local xdgValue="$(eval "echo \${$xdgVar}")"
    mkdir -p "$xdgValue";
done < <(awk -F'=' '($1 !~ /^#/) {print $1}' "$(script_directory)/user-dirs.dirs")
unset xdgVar xdgValue

