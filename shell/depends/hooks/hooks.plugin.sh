# Hooks support for bash.
# Includes chpwd, precmd and preexec
# Uses PROMPT_COMMAND - should not be used anywehere else

# Currently supported: chpwd, precmd, preexec

if [ ! -z "$BASH_VERSION" ]; then
    # chpwd hook
    source "$SHELLRC_DIR/shell/depends/hooks/bash-chpwd.sh"
    # modified version of https://github.com/rcaloras/bash-preexec
    source "$SHELLRC_DIR/shell/depends/hooks/bash-precmd-preexec.sh"
fi
