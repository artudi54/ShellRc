source $SHELLRC_DIR/vim/autoload/pathogen.vim
set viminfo+=n~/.config/vim/viminfo

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

map <S-Right> :tabnext<CR>
map <S-Left> :tabprev<CR>

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
set completeopt-=preview
let g:ycm_semantic_triggers = {'haskell' : ['.']}
