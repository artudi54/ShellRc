# Script sourcing utilities
source "$SHELLRC_DIR/src/script-sourcing/script-sourcing.sh"

# Directory setup
include "directory-setup/xdg-dirs.sh"
include "directory-setup/shellrc-dirs.sh"

# Bash-Zsh compatibility
include "bash-zsh-comp/completion.sh"
include "bash-zsh-comp/hooks.sh"

# Builtin overrides
include "overrides/alias.sh"

# Shellenv
include "shellenv/shellenv.sh"

# Environment
include "environment/path.sh"
