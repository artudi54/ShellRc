dir="$(script_directory)"

echo "source "\"$SHELLRC_DIR/shellrc.sh\""" > "$HOME/.bashrc"
echo "source "\"$SHELLRC_DIR/shellrc.sh\""" > "$HOME/.profile"
sudo "$dir/install-zdotdir.py"

