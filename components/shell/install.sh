echo "source "\"$SHELLRC_DIR/shellrc.sh\""" > "$HOME/.bashrc"    
echo "source "\"$SHELLRC_DIR/shellrc.sh\""" > "$HOME/.profile"

zdotCommand="$(sed -e "s#user#$USER#g" -e "s#dir#$(script_directory)/zdotdir#g" "$(script_directory)/zdotdir/user.sh")"
if ! python3 -c "
               import sys
               text = open('/etc/zsh/zshenv').read()
               sys.exit(0 if sys.argv[1] in text else 1)" \
    "$zdotCommand" 2>/dev/null; then
    printf "\n$zdotCommand\n\n" | sudo tee -a /etc/zsh/zshenv >/dev/null
fi

