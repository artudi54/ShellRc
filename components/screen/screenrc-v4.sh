source $SHELLRC_DIR/components/screen/screenrc.sh

caption always "%{= bw}%-w%{= BW} %n %t %{-}%+w %-="
hardstatus alwayslastline "%{= yk} [%S | $SHELL] %{=b gW} $USER@%H | %1` | %2` | up %3`  %-=%{= yk} %LD %d %LM %Y - %c "
