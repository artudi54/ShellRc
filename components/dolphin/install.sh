
dir="$(script_directory)"
ln -s "$dir/dolphin.ini" "$XDG_CONFIG_HOME/dolphinrc"
mkdir -p "$XDG_DATA_HOME/kxmlgui5"
ln -s "$dir/menus" "$XDG_DATA_HOME/kxmlgui5/dolphin"
