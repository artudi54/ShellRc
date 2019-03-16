# functions for screen profiles

screen-basic() {
    screen -c "$SHELLRC_DIR/screen/rc/basicrc.sh" "$@"
}

screen-basic-split() {
    screen -c "$SHELLRC_DIR/screen/rc/basicsplitrc.sh" "$@"
}
