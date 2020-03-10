echo "source "\"$SHELLRC_DIR/shellrc.sh\""" > "$HOME/.bashrc"
ln -s ".bashrc" "$HOME/.zshrc"
    
echo "source "\"$SHELLRC_DIR/shellrc.sh\""" > "$HOME/.profile"
ln -s ".profile" "$HOME/.zprofile"

