
dir="$(script_directory)"
ln -s "$dir/konsole.ini" "$XDG_CONFIG_HOME/konsolerc"
ln -s "$dir/config" "$XDG_DATA_HOME/konsole"
mkdir -p "$XDG_DATA_HOME/kxmlgui5"
ln -s "$dir/menus" "$XDG_DATA_HOME/kxmlgui5/konsole"

