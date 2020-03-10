include "history.sh"

# shell config
if [ -n "$BASH_VERSION" ]; then
    include "shell/bash-config.sh"
elif [ -n "$ZSH_VERSION" ]; then
    include "shell/zsh-config.sh"
fi

# environmental variables
include "shell/environment/environment.sh"

# functions
include "shell/functions/functions.sh"

# aliases
include "shell/aliases/aliases.sh"

# promt settings
include "shell/prompt/prompt.sh"

# plugins
include "shell/plugins/plugins.sh"

