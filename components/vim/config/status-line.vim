" Status line options
set laststatus=2
set noshowmode

function! LightlineFilename()
    return expand('%')
endfunction

let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'component_function': {
    \   'filename' : 'LightlineFilename'
    \ }
\ }

