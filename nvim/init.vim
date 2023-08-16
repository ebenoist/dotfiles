" PLUGINS
" ===
call plug#begin('~/.config/nvim/plugged')

" General
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'w0rp/ale'
Plug 'diepm/vim-rest-console'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jparise/vim-graphql'

" JS
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'othree/html5.vim'

" TS
Plug 'peitalin/vim-jsx-typescript'
Plug 'leafgarland/typescript-vim'

" Go
Plug 'fatih/vim-go', {'for': 'go'}

" Ruby
Plug 'thoughtbot/vim-rspec', {'for': 'ruby'}
Plug 'tpope/vim-endwise', {'for': 'ruby'}
Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}

" Python
Plug 'vim-python/python-syntax', { 'for': 'python' }

" Docs
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'hashivim/vim-terraform'
Plug 'wakatime/vim-wakatime'

call plug#end()

" GENERAL CONFIG
" ===
syntax on                                  " Turn on syntax highlighting
filetype on
filetype indent on
filetype plugin on
set hidden                                 " Allow hiding buffers with unsaved changes
set listchars=trail:.,tab:>-,eol:$         " Change the invisible characters
set nolist                                 " Hide invisibles by default
set showcmd                                " Show incomplete cmds down the bottom
set showmode                               " Show current mode down the bottom
set cmdheight=2                            " Make the command line a little taller
set ttyfast                                " More smooth screen redrawing
set incsearch                              " Find the next match as we type the search
set hlsearch                               " Highlight searches by default
set ruler                                  " Show ruler
set number                                 " Show line numbers
set vb t_vb=                               " Turn off bell
set mouse=a                                " Enable the mouse
set linespace=3                            " Spacing between lines
set noswapfile                             " Disable creation of *.swp files
set autoread                               " Autoload files
set tags+=tags                             " Set ctags
set tags+=.tags
set tags+=.gemtags                         " Set ctags
set clipboard^=unnamed,unnamedplus         " Set system clipboard
scriptencoding utf-8
set shiftwidth=2                           " Number of spaces to use in each autoindent step
set tabstop=2                              " Two tab spaces
set softtabstop=2                          " Number of spaces to skip or insert when <BS>ing or <Tab>ing
set expandtab                              " Spaces instead of tabs for better cross-editor compatibility
set autoindent                             " Keep the indent when creating a new line
set smarttab                               " Use shiftwidth and softtabstop to insert or delete (on <BS>) blanks
set cindent                                " Recommended seting for automatic C-style indentation
set autoindent                             " Automatic indentation in non-C files
set nowrap                                 " Dont wrap lines
set wildmenu                               " Make tab completion act more like bash
set wildmode=longest,list,full             " Tab complete to longest common string, like bash
set completeopt+=longest                   " Tab complete type to search
set switchbuf=useopen                      " Don't re-open already opened buffers
set nostartofline                          " Avoid moving cursor to BOL when jumping around
set scrolloff=3                            " Keep 3 context lines above and below the cursor
set backspace=2                            " Allow backspacing over autoindent, EOL, and BOL
set showmatch                              " Briefly jump to a paren once it's balanced
set backupdir=$HOME/.config/nvim/backup
set directory=$HOME/.config/nvim/backup
set undodir=$HOME/.config/nvim/undodir
set undofile
set undolevels=10000
set undoreload=10000
set ignorecase                             " Ignore case by default when searching
set smartcase                              " Switch to case sensitive mode if needle contains uppercase characters
colorscheme Tomorrow-Night
set background=dark
if has("mouse")
  set mouse=a
endif
set updatetime=300
set signcolumn=yes

" REMOVE TRAILING WHITESPACE
autocmd BufWritePre * :%s/\s\+$//e

" Change cursor type for iTerm2
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" KEYBINDINGS START
" ===
" Map Leader: Reset from \ to ,
let mapleader = ","
nnoremap Y y$

" COC
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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

" Autocomplete
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

" Hello new MBP
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

" Markdown
nmap <leader>m <Plug>MarkdownPreview

" PLUGIN CONFIG
let NERDChristmasTree = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
let NERDTreeHijackNetrw = 1
let NERDTreeIgnore=['\.$', '\~$', '.DS_Store']
let NERDDefaultNesting = 0
let NERDRemoveExtraSpaces = 1
let NERDSpaceDelims = 1
let ruby_operators = 1

" FZF
let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'

" Let ack/vim use ag for search
let g:ackprg = 'ag --nogroup --nocolor --column'

" COC
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GO
let g:go_fmt_command = "goimports"
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_def_mode = "gopls"
let g:go_rename_command = 'gopls'
let g:go_metalinter_autosave_enabled = ['typecheck', 'golint']

set completeopt+=noinsert
set completeopt+=noselect
set completeopt-=preview

" Ale + TS
au FileType typescript nmap <C-]> :ALEGoToDefinition<CR>
au FileType typescript.tsx nmap <C-]> :ALEGoToDefinition<CR>

" Ale
au FileType typescript let g:ale_completion_enabled = 1 " Ale autocomplete (just TS)
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
highlight ALEError ctermbg=NONE cterm=NONE
highlight ALEWarning ctermbg=NONE cterm=NONE
let g:ale_linters_ignore = {
    \ 'ruby': ['rubocop']
    \ }
let g:ale_fixers = {
    \ 'ruby': ['standardrb'],
    \ 'python': ['autopep8'],
    \ 'javascript': ['eslint'],
    \ 'typescript': ['eslint']
    \ }
let g:ale_linters = {
    \ 'ruby': ['standardrb']
    \ }

" MARKDOWN
let g:mkdp_markdown_css = '/home/erik/dev/dotfiles/gdocs.css'
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': { 'server': 'http://erikbenoist.com:8181'},
    \ 'maid': {},
    \ 'disable_sync_scroll': 1,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {}
    \ }

" AUTOCOMMANDS
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")

  " Do the business:
  %s/\s\+$//e

  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

autocmd BufWritePre *.rb,*.haml :call <SID>StripTrailingWhitespaces()
autocmd BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru,*.god} set ft=ruby
autocmd BufRead,BufNewFile {*.md,*.mkd,*.markdown} set ft=markdown
autocmd BufRead,BufNewFile {COMMIT_EDITMSG} set ft=gitcommit
autocmd BufRead,BufNewFile {Tiltfile} set ft=python
autocmd BufNewFile,BufRead {*.tsx,*.jsx} set filetype=typescript.tsx
