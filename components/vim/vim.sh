# Vim plugins location
export SHELLRC_VIM_PLUGIN_DIR="$(script_directory)/plugins"
# Vim startup
export VIMINIT="let \$MYVIMRC='$(script_directory)/vimrc.vim' | source \$MYVIMRC"

