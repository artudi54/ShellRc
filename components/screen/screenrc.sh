startup_message off
defscrollback 20000

caption always "%{7;4}%-w%{7;12} %n %t %{-}%+w %-="
hardstatus alwayslastline "%{0;3} [%S | $SHELL] %{+b 7;2} $USER@%H | %1` | %2` | up %3`  %-= %{= yk} %LD %d %LM %Y - %c "

# Status bar info commands
backtick 1 30 30 sh -c 'ip -4 route get 1.1.1.1 2>/dev/null | grep -oP "src \K[^ ]+" || hostname -I 2>/dev/null | cut -d" " -f1'
backtick 2 10 10 sh -c 'free -h | awk "/Mem:/{print \$3\"/\"\$2}"'
backtick 3 30 30 sh -c 'uptime -p | sed "s/^up //"'

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

# Splits (Prefix + Shift+1/2/3/4)
bind ! eval "only"
bind @ eval "only" "split -v" "focus left"
bind \# eval "only" "split -v" "focus right" "split" "focus left"
bind $ eval "only" "split" "split -v"  "focus down" "split -v" "focus up" "focus left"

term xterm-256color

defmousetrack on
layout save default
altscreen

