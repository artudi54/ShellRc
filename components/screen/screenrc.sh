startup_message off
defscrollback 20000
caption always "%{= bw}%-w%{= BW}%n %t%{-}%+w %-="
hardstatus alwayslastline "%{= yk} [%S | $SHELL] %{= gW} $USER@%H  %-= %{= yk} %LD %d %LM %Y - %c"

# Remove annoying binds
bindkey -k k4

# Screen menu
escape "^Bb"

# Navigate windows
bindkey "^[[1;3D" prev
bindkey "^[^[[D" prev
bindkey "^[[1;3C" next
bindkey "^[^[[C" next

# Move windows
bindkey "^[[1;8D" number -1
bindkey "^[[1;8C" number +1

# Navigate regions
bindkey "^[[1;6D" focus prev
bindkey "^[[1;6C" focus next

# Splits
bindkey SS! eval "only"
bindkey SS@ eval "only" "split -v" "focus left"
bindkey SS# eval "only" "split -v" "focus right" "split" "focus left"
bindkey SS$ eval "only" "split" "split -v"  "focus down" "split -v" "focus up" "focus left"

term xterm-256color

defmousetrack on
layout save default
altscreen

