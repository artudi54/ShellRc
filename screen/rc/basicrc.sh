source "$SHELLRC_DIR/screen/rc/screenrc.sh"

bindkey LLS stuff 'cd "$START"'^M

screen -t "Home" 0 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W0"
screen -t "Downloads" 1 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W1"
screen -t "Documents" 2 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W2"
screen -t "Desktop" 3 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W3"
screen -t "FilesystemRoot" 4 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W4"
screen -t "Usr" 5 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W5"
screen -t "Share" 6 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W6"
screen -t "Local" 7 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W7"
screen -t "Opt" 8 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W8"
screen -t "Temp" 9 bash -c ". '$SHELLRC_DIR/screen/scripts/basic/start.sh' W9"

select 0
