dir="$(script-directory)"
mkdir -p "$XDG_CONFIG_HOME/git"
echo "[include]\n    path = \"$dir/gitconfig.ini\"" >"$XDG_CONFIG_HOME/git/config" 
