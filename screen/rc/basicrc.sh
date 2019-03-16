source "$SHELLRC_DIR/screen/rc/screenrc.sh"

screen -t "Home" 0 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '$HOME'"
screen -t "Downloads" 1 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '$HOME/Downloads'"
screen -t "Documents" 2 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '$HOME/Documents'"
screen -t "Desktop" 3 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '$HOME/Desktop'"
screen -t "FilesystemRoot" 4 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '/'"
screen -t "Usr" 5 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '/usr'"
screen -t "Share" 6 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '/usr/share'"
screen -t "Local" 7 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '/usr/local'"
screen -t "Opt" 8 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '/usr/local'"
screen -t "Temp" 9 $SHELL -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' '/tmp'"

select 0
