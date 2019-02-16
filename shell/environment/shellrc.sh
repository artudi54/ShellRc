# ShellRc directory
if [ -n "$BASH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "$(dirname "$BASH_SOURCE")")")"
elif [ -n "$ZSH_VERSION" ]; then
    export SHELLRC_DIR="$(dirname "$(dirname "$(dirname "${(%):-%N}")")")"
fi