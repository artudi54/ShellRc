#!/bin/bash
source "$SHELLRC_DIR/components/screen/scripts/util/cdc.sh"

cdc "$1"
clear
exec $SHELL
