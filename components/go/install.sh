dir="$(script_directory)"
rm -rf "$XDG_CONFIG_HOME/go"
ln -sfT "$(script_directory)/config" "$XDG_CONFIG_HOME/go"

