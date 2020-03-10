
dir="$(script-directory)"
ln -s "$dir/konsole.ini" "$XDG_CONFIG_HOME/konsolerc"
ln -s "$dir/config" "$XDG_DATA_HOME/konsole"
git update-index --assume-unchanged "$dir/konsole.ini"

