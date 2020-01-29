# Vim plugins location
export SHELLRC_VIM_PLUGIN_DIR="$(script-directory)/plugins"
# Vim startup
export VIMINIT="let \$MYVIMRC='$(script-directory)/vimrc.vim' | source \$MYVIMRC"

