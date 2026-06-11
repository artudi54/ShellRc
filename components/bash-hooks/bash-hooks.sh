# Hooks support for bash.
# Includes chpwd, precmd and preexec
# Uses PROMPT_COMMAND - should not be used anywehere else

# Currently supported: chpwd, precmd, preexec

[[ ! -v BASH_VERSION ]] && return

# interactive shell only
[[ $- != *i* ]] && return

# chpwd hook
include "bash-chpwd.sh"
# precmd, preexec hooks - https://github.com/rcaloras/bash-preexec
include "bash-preexec/bash-preexec.sh"

