# shell config
if [ -n "$BASH_VERSION" ]; then
    include "shell/bash-config.sh"
elif [ -n "$ZSH_VERSION" ]; then
    include "shell/zsh-config.sh"
fi

# functions
include "shell/functions/functions.sh"

# promt settings
include "shell/prompt/prompt.sh"

# plugins
include "shell/plugins/plugins.sh"

