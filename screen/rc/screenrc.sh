startup_message off
defscrollback 20000

caption always "%{= bw}%-w%{= BW}%n %t%{-}%+w %-= @%H - %LD %d %LM - %c"

bindkey "^[[1;3D" prev
bindkey "^[^[[D" prev
bindkey "^[[1;3C" next
bindkey "^[^[[C" next

bindkey "^[[1;6D" focus prev
bindkey "^[[1;6C" focus next

bindkey SS! eval "split -v" "focus right" "split" "focus left"
bindkey SS@ only

term xterm-256color

