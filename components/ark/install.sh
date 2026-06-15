
dir="$(script_directory)"
ln -sfT "$dir/ark.ini" "$XDG_CONFIG_HOME/arkrc"
mkdir -p "$XDG_DATA_HOME/kxmlgui5"
ln -sfT "$dir/menus" "$XDG_DATA_HOME/kxmlgui5/ark"
