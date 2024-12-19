source $SHELLRC_DIR/components/screen/screenrc.sh

caption always "%{= bw}%-w%{= BW}%n %t%{-}%+w %-="
hardstatus alwayslastline "%{= yk} [%S | $SHELL] %{= gW} $USER@%H  %-= %{= yk} %LD %d %LM %Y - %c"
