
dir="$(script_directory)"
ln -sfT "$dir/dolphin.ini" "$XDG_CONFIG_HOME/dolphinrc"
mkdir -p "$XDG_DATA_HOME/kxmlgui5"
ln -sfT "$dir/menus" "$XDG_DATA_HOME/kxmlgui5/dolphin"
mkdir -p "$XDG_DATA_HOME/kio"
ln -sfT "$dir/servicemenus" "$XDG_DATA_HOME/kio/servicemenus"
