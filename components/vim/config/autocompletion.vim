" Code completions
let g:ycm_use_clangd = 1
let g:ycm_global_ycm_extra_conf = '$SHELLRC_DIR/vim/ycm_extra_conf.py'
let g:ycm_server_python_interpreter = '/usr/bin/python3'
let g:ycm_enable_semantic_highlighting=1
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

