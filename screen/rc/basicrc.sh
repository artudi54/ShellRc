source "$SHELLRC_DIR/screen/rc/screenrc.sh"

bindkey LLS stuff 'cd "$START"'^M

screen -t "Home" 0 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W0"
screen -t "Downloads" 1 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W1"
screen -t "Documents" 2 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W2"
screen -t "Desktop" 3 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W3"
screen -t "FilesystemRoot" 4 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W4"
screen -t "Usr" 5 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W5"
screen -t "Share" 6 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W6"
screen -t "Local" 7 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W7"
screen -t "Opt" 8 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W8"
screen -t "Temp" 9 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W9"

select 0
