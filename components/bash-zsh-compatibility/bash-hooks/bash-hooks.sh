# Hooks support for bash.
# Includes chpwd, precmd and preexec
# Uses PROMPT_COMMAND - should not be used anywehere else

# Currently supported: chpwd, precmd, preexec

[[ ! -v BASH_VERSION ]] && return

# interactive shell only
[[ $- != *i* ]] && return

# chpwd hook
include "bash-chpwd.sh"
include "bash-preexec/bash-preexec.sh"

declare -ga precmd_functions=("${precmd_functions[@]}")
declare -ga preexec_functions=("${preexec_functions[@]}")

