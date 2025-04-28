
dir="$(script_directory)"
ln -s "$dir/ark.ini" "$XDG_CONFIG_HOME/arkrc"
mkdir -p "$XDG_DATA_HOME/kxmlgui5"
ln -s "$dir/menus" "$XDG_DATA_HOME/kxmlgui5/ark"
