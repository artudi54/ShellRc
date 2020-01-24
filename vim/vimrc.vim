source $SHELLRC_DIR/vim/autoload/pathogen.vim
set viminfo+=n$SHELLHISTORY_DIR/viminfo.log

set encoding=utf-8
set number
set splitright
set mouse=a
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent



set wildmode=longest,list,full
set wildmenu

execute pathogen#infect("$SHELLRC_DIR/vim/bundle/{}")
syntax on
filetype plugin indent on

" Tab bar options
:tab all
set showtabline=2

" Status line options
function! LightlineFilename()
    return expand('%')
endfunction

" NERDTree options
let NERDTreeNaturalSort = 1

set laststatus=2
set noshowmode

let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'component_function': {
    \   'filename' : 'LightlineFilename'
    \ }
\ }

colorscheme wombat

" Code completions
let g:ycm_use_clangd = 1
let g:ycm_global_ycm_extra_conf = '$SHELLRC_DIR/vim/ycm_extra_conf.py'
let g:ycm_server_python_interpreter = '/usr/bin/python3'
let g:ycm_confirm_extra_conf = 0
set completeopt-=preview
let g:ycm_semantic_triggers = {'haskell' : ['.']}
let g:ycm_key_list_stop_completion = []

call lh#alternate#register_extension('g', 'h'  , g:alternates.extensions.h + ['tpp'])
call lh#alternate#register_extension('g', 'hpp', g:alternates.extensions.hpp + ['tpp'])
call lh#alternate#register_extension('g', 'tpp', ['h', 'hpp'])
let g:alternates.fts.cpp += ['tpp']
let g:alternates.searchpath ='reg:/inc/src/g/,reg:/include/src/g/,reg:/src/inc/g/,reg:/src/include/g/'

let g:cpp_class_scope_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1

" key mappings
source $SHELLRC_DIR/vim/keymappings.vim

" clear jumplist
let i = 0 | while i < 100 | mark ' | let i = i + 1 | endwhile

" Synthax higlighting
let g:color_coded_enabled = 1
let g:color_coded_filetypes = ['c', 'cc', 'cpp', 'objc', 'h', 'hpp']
let java_highlight_functions = 1
let java_highlight_all = 1
highlight link javaScopeDecl Statement
highlight link javaType Type
highlight link javaDocTags PreProc
