# Adds support for autoloading functions with FPATH and some autoload zsh functions
if [ ! -z "$BASH_VERSION" ]; then
    source "$SHELLRC_DIR/shell/depends/autoload/bash-autoload/bash-autoload.sh"
fi

