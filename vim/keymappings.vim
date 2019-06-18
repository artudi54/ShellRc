" Alt keymappings
let c='a'
while c <= 'z'
  exec "set <a-".c.">=\e".c
  exec "imap \e".c." <a-".c.">"
  let c = nr2char(1+char2nr(c))
endw
set ttimeout ttimeoutlen=50

" Alt + lowercase
inoremap ð <C-c>p
inoremap ù <C-c>y
inoremap æ <C-c>f
inoremap ã <C-c>c
inoremap ç <C-c>g
inoremap ò <C-c>r
inoremap ì <C-c>l
inoremap á <C-c>a
inoremap ï <C-c>o
inoremap å <C-c>e
inoremap õ <C-c>u
inoremap é <C-c>i
inoremap ä <C-c>d
inoremap è <C-c>h
inoremap ô <C-c>t
inoremap î <C-c>n
inoremap ó <C-c>s
inoremap ñ <C-c>q
inoremap ê <C-c>j
inoremap ë <C-c>k
inoremap ø <C-c>x
inoremap â <C-c>b
inoremap í <C-c>m
inoremap ÷ <C-c>w
inoremap ö <C-c>v
inoremap ú <C-c>z
" Alt + uppercase
inoremap Ð <C-c>P
inoremap Ù <C-c>Y
inoremap Æ <C-c>F
inoremap Ã <C-c>C
inoremap Ç <C-c>G
inoremap Ò <C-c>R
inoremap Ì <C-c>L
inoremap Á <C-c>A
inoremap Ï <C-c>O
inoremap Å <C-c>E
inoremap Õ <C-c>U
inoremap É <C-c>I
inoremap Ä <C-c>D
inoremap È <C-c>H
inoremap Ô <C-c>T
inoremap Î <C-c>N
inoremap Ó <C-c>S
inoremap Ñ <C-c>Q
inoremap Ê <C-c>J
inoremap Ë <C-c>K
inoremap Ø <C-c>X
inoremap Â <C-c>B
inoremap Í <C-c>M
inoremap × <C-c>W
inoremap Ö <C-c>V
inoremap Ú <C-c>Z

" Missed case save commands
:command Q q
:command Qa qa
:command QA qa
:command W w
:command Wa wa
:command WA wa
:command Wq wq
:command WQ wq
:command Wqa wqa
:command WQa wqa
:command WQA wqa

" Window manage remap
inoremap <C-E> <C-O><C-W>
nnoremap <C-E> <C-W>
inoremap <A-j> <C-O>:wincmd w<CR>
inoremap <A-J> <C-O>:wincmd w<CR>
nnoremap <A-j> :wincmd w<CR>
nnoremap <A-J> :wincmd w<CR>
inoremap <A-k> <C-O>:wincmd W<CR>
inoremap <A-K> <C-O>:wincmd W<CR>
nnoremap <A-k> :wincmd W<CR>
nnoremap <A-K> :wincmd W<CR>

" Clipboard mappings
set clipboard=unnamedplus
vnoremap <C-C> y<Esc>
vnoremap <C-X> d<Esc>
inoremap <C-V> <Esc>pi
nnoremap <C-V> p
vnoremap <C-V> <Esc>pi

" Tab navigation
inoremap <C-k> <C-O>:tabnext<CR>
inoremap <C-j> <C-O>:tabprev<CR>
nnoremap <C-k> :tabnext<CR>
nnoremap <C-j> :tabprev<CR>

" Shift Selecting
inoremap <S-Up> <C-O>vk
nnoremap <S-Up> vk
vnoremap <S-Up> k
inoremap <S-Down> <C-O>vj
nnoremap <S-Down> vj
vnoremap <S-Down> j
inoremap <S-Left> <C-O>vh
nnoremap <S-Left> vh
vnoremap <S-Left> h
inoremap <S-Right> <C-O>vl
nnoremap <S-Right> vl
vnoremap <S-Right> l

" Scrolling
" <Up> cursor line up 
" <Down> cursor line down
inoremap <C-Up> <C-O><C-E>
inoremap <C-Down> <C-O><C-Y>
nnoremap <C-Up> <C-E>
nnoremap <C-Down> <C-Y>

" Undo and redo
nnoremap u <NOP>
nnoremap <C-R> <NOP>
inoremap <C-z> <C-O>:undo<CR>
inoremap <C-y> <C-O>:redo<CR>
nnoremap <C-z> :undo<CR>
nnoremap <C-y> :redo<CR>

" Select whole line
inoremap <C-C> <Esc>V
nnoremap <C-C> <Esc>V

" Duplicate line
inoremap <C-d> <Esc>Ypi
nnoremap <C-d> Yp

" Select current word
inoremap <C-w> <Esc>lviw
nnoremap <C-w> viw

" Move line up or down
inoremap <A-Up> <C-O>:move -2<CR>
inoremap <A-Down> <C-O>:move +1<CR>
nnoremap <A-Up> :move -2<CR>
nnoremap <A-Down> :move +1<CR>

" Jump to line (start entering command)
nnoremap <C-G> :
inoremap <C-G> <C-O>:
vnoremap <C-G> <Esc>:

" Go back and forward remap
nnoremap go <C-O>
nnoremap gi <C-I>

" Quick menu
call g:quickmenu#reset()
nnoremap <silent><F2> :call quickmenu#toggle(0)<cr>
inoremap <silent><F2> <C-O>:call quickmenu#toggle(0)<cr>
call g:quickmenu#header('Menu')
call g:quickmenu#append('# navigation', '')
call g:quickmenu#append('Go back', 'execute "normal go"')
call g:quickmenu#append('Go forward', 'execute "normal gi"')
call g:quickmenu#append('Go to definition', 'YcmCompleter GoToDefinition')
call g:quickmenu#append('Go to declaration', 'YcmCompleter GoToDeclaration')
call g:quickmenu#append('# edition', '')
call g:quickmenu#append('Undo', 'undo')
call g:quickmenu#append('Redo', 'redo')
call g:quickmenu#append('# environment', '')
call g:quickmenu#append('Refresh Completions', 'YcmGenerateConfig -f | YcmRestartServer')
call g:quickmenu#append('Refresh Completions', 'echo "ok" | echo "gej"')

" Directory view
let NERDTreeMapOpenInTab='<ENTER>'
let NERDTreeMapOpenSplit="s"
let NERDTreeMapOpenVSplit="v"
inoremap <C-O> <C-O>:NERDTreeTabsToggle<CR>
nnoremap <C-O> :NERDTreeTabsToggle<CR>

