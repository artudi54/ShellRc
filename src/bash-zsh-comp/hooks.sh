# Hooks support for bash.
# Includes chpwd, precmd and preexec
# Uses PROMPT_COMMAND - should not be used anywehere else

# Currently supported: chpwd, precmd, preexec

if [[ -v BASH_VERSION ]]; then
    # chpwd hook
    include "bash-chpwd.sh"
    # precmd, preexec hooks - modified version of https://github.com/rcaloras/bash-preexec
    include "bash-precmd-preexec.sh"
fi
