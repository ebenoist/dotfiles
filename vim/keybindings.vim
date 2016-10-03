" Map Leader: Reset from \ to ,
let mapleader = ","

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" jj for esc
imap jj <Esc>

" NERDTree
nmap <Leader>N :NERDTreeToggle<CR>
nmap <Leader>nf :NERDTreeFind<CR>

" AckVim: <leader>f to search
map <leader>f :Ack<Space>
map <leader>s :Ack <cword><CR>

" Toggle line numbers
nmap <Leader>n :set number! number?<cr>

" Toggle search highlights
nmap <Leader>h :set hlsearch! hlsearch?<cr>

" Shortcuts for writing the file...
map <Leader>w :w<cr>
imap <Leader>w <esc>:w<cr>

" and quitting
map <Leader>q :qall<cr>
imap <Leader>q <esc>:qall<cr>

" FZF
nnoremap <Leader>t :FZF<CR>

" Copy/Paste
map <Leader>cf :let @*=expand("%")<CR>
map <Leader>cff :let @*=expand("%:p")<CR>

" Fugitive
map <leader>gb :Gblame<CR>

"Autocomplete
inoremap <c-x><c-]> <c-]>

" New  Tags
map <Leader>rt :!bash -ic re-ctags

" NeoTerm
nnoremap <silent> ,ra :call neoterm#test#run('all')<cr>
nnoremap <silent> ,rf :call neoterm#test#run('file')<cr>
nnoremap <silent> ,rl :call neoterm#test#run('current')<cr>
nnoremap <silent> ,rr :call neoterm#test#rerun()<cr>
nnoremap <silent> ,th :call neoterm#close()<cr>

" Quick Navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-x> <C-w>q

" Neovim
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
"Hack to get C-h working in neovim
nmap <BS> <C-W>h

" GO
au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gb <Plug>(go-build)
au FileType go nmap <leader>gt <Plug>(go-test)
au FileType go nmap <leader>gc <Plug>(go-coverage)
au FileType go nmap <Leader>ge <Plug>(go-rename)
au FileType go nmap <Leader>gdb <Plug>(go-doc-browser)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

" Tagbar
nmap <leader>T :TagbarToggle<CR>
