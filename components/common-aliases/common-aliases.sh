# Common aliases for interactive shells
[[ $- != *i* ]] && return

include "cd.sh"
include "cmake.sh"
include "grep.sh"
include "java.sh"
include "memory-management.sh"
include "network.sh"
include "permissions.sh"
include "sudo.sh"
include "systemd.sh"
include "terminal.sh"

