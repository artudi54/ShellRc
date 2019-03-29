source $SHELLRC_DIR/vim/autoload/pathogen.vim
set viminfo+=n$SHELLHISTORY_DIR/viminfo.log

set encoding=utf-8
set number
set mouse=a
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent

:command Q q
:command W w
:command WQ wq
:command Wq wq

set wildmode=longest,list,full
set wildmenu

execute pathogen#infect("$SHELLRC_DIR/vim/bundle/{}")
syntax on
filetype plugin indent on


set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

colorscheme wombat

let NERDTreeMapOpenInTab='<ENTER>'
map <C-o> :NERDTreeTabsToggle<CR>

let g:ycm_global_ycm_extra_conf = '$SHELLRC_DIR/vim/ycm_extra_conf.py'
let g:ycm_server_python_interpreter = '/usr/bin/python3'
let g:ycm_confirm_extra_conf = 0
set completeopt-=preview
let g:ycm_semantic_triggers = {'haskell' : ['.']}
let g:ycm_key_list_stop_completion = []

let g:cpp_class_scope_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1

" key mappings
source $SHELLRC_DIR/vim/keymappings.vim

