#!/bin/bash
source "$SHELLRC_DIR/screen/scripts/utils.sh"
source "$SHELLRC_DIR/screen/scripts/basic/directories.sh"
eval cdc "\$$1"
export-start
clear
$SHELL
