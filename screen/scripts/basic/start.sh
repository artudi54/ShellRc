#!/bin/bash
source "$SHELLRC_DIR/screen/scripts/utils.sh"

cdc "$1"
clear
exec $SHELL
