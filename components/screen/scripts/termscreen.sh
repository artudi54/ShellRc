# Functions for using termscreen - persistent screen session using basic setup

termscreen() {
    if screen -ls | grep 'termscreen' 2>&1 >/dev/null; then
        screen -r termscreen
    else
        screenprofile basic -S termscreen
    fi
}
