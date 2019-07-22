" Map Leader: Reset from \ to ,
let mapleader = ","

nnoremap Y y$

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

" FZF
nnoremap <Leader>t :FZF<CR>

" Copy/Paste Current Directory
map <Leader>cf :let @*=expand("%")<CR>
map <Leader>cff :let @*=expand("%:p")<CR>

" Fugitive
map <leader>gb :Gblame<CR>

"Autocomplete
inoremap <c-x><c-]> <c-]>

" New Tags
map <Leader>rt :!bash -ic re-ctags

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

" Hellow new MBP
inoremap jj <esc>

" GO
au FileType go nmap <leader>gr <Plug>(go-run)
au FileType go nmap <leader>gb <Plug>(go-build)
au FileType go nmap <leader>gt <Plug>(go-test)
au FileType go nmap <leader>gc <Plug>(go-coverage)
au FileType go nmap <Leader>ge <Plug>(go-rename)
au FileType go nmap <Leader>gdb <Plug>(go-doc-browser)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

au TermOpen * tnoremap <Esc> <c-\><c-n>
au BufEnter * tnoremap <Esc> <c-\><c-n>
au FileType fzf tunmap <Esc>
