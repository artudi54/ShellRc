source "$SCREEN_PROFILES/defaultrc.sh"

screen -t "Home"            0 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '$HOME'"
screen -t "Downloads"       1 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '$HOME/Downloads'"
screen -t "Documents"       2 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '$HOME/Documents'"
screen -t "Desktop"         3 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '$HOME/Desktop'"
screen -t "FilesystemRoot"  4 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '/'"
screen -t "Usr"             5 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '/usr'"
screen -t "Share"           6 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '/usr/share'"
screen -t "Local"           7 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '/usr/local'"
screen -t "Opt"             8 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '/usr/local'"
screen -t "Temp"            9 $SHELL -c ". '$SCREEN_PROFILES/../scripts/util/start.sh' '/tmp'"

select 0

