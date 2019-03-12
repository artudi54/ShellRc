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

" Quick menu
call g:quickmenu#reset()

nnoremap <silent><F2> :call quickmenu#toggle(0)<cr>
inoremap <silent><F2> <C-O>:call quickmenu#toggle(0)<cr>

call g:quickmenu#header('Menu')

call g:quickmenu#append('# Navigation', '')
call g:quickmenu#append('Go to definition', 'YcmCompleter GoToDefinition')
call g:quickmenu#append('Go to declaration', 'YcmCompleter GoToDeclaration')
