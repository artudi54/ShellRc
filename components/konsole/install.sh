
dir="$(script_directory)"
ln -sfT "$dir/konsole.ini" "$XDG_CONFIG_HOME/konsolerc"
ln -sfT "$dir/config" "$XDG_DATA_HOME/konsole"
mkdir -p "$XDG_DATA_HOME/kxmlgui5"
ln -sfT "$dir/menus" "$XDG_DATA_HOME/kxmlgui5/konsole"

