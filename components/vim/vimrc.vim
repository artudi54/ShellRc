let $VIMDIR=fnamemodify(expand("$MYVIMRC"), ":h")
source $VIMDIR/autoload/pathogen.vim
execute pathogen#infect("$SHELLRC_VIM_PLUGIN_DIR/{}")

set viminfo+=n$SHELLRC_STATE_DIR/viminfo.log

source $VIMDIR/config/autocompletion.vim
source $VIMDIR/config/command-input.vim
source $VIMDIR/config/editor-layout.vim
source $VIMDIR/config/file-explorer.vim
source $VIMDIR/config/keymappings.vim
source $VIMDIR/config/tab-bar.vim
source $VIMDIR/config/status-line.vim
source $VIMDIR/config/synthax-highlight.vim

colorscheme wombat

