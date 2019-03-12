" Shift+Arrow navigation
map <S-Right> :tabnext<CR>
map <S-Left> :tabprev<CR>

" Undo and redo
inoremap <C-z> <C-O>:undo<CR>
inoremap <C-y> <C-O>:redo<CR>
nnoremap <C-z> :undo<CR>
nnoremap <C-y> :redo<CR>

" Duplicate line
inoremap <C-d> <Esc>Ypi
nnoremap <C-d> Yp
