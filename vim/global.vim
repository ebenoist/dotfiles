" MISC
"-------------------------------------------------
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
set t_Co=256                               " Support for xterm with 256 colors (gets overriden in .gvimrc)
set autoread                               " Autoload files
set tags+=tags                            " Set ctags
set tags+=.tags
set tags+=.gemtags                         " Set ctags
set clipboard+=unnamed                     " Set system clipboard
scriptencoding utf-8

" INDENTATION
"-------------------------------------------------
set shiftwidth=2                           " Number of spaces to use in each autoindent step
set tabstop=2                              " Two tab spaces
set softtabstop=2                          " Number of spaces to skip or insert when <BS>ing or <Tab>ing
set expandtab                              " Spaces instead of tabs for better cross-editor compatibility
set autoindent                             " Keep the indent when creating a new line
set smarttab                               " Use shiftwidth and softtabstop to insert or delete (on <BS>) blanks
set cindent                                " Recommended seting for automatic C-style indentation
set autoindent                             " Automatic indentation in non-C files

" WRAP
"-------------------------------------------------
set nowrap                                 " Dont wrap lines
set wildmenu                               " Make tab completion act more like bash
set wildmode=longest,list,full             " Tab complete to longest common string, like bash
set completeopt+=longest                   " Tab complete type to search
set switchbuf=useopen                      " Don't re-open already opened buffers

" MOVING AROUND / EDITING
"-------------------------------------------------
set nostartofline                          " Avoid moving cursor to BOL when jumping around
set scrolloff=3                            " Keep 3 context lines above and below the cursor
set backspace=2                            " Allow backspacing over autoindent, EOL, and BOL
set showmatch                              " Briefly jump to a paren once it's balanced
set matchtime=2                            " (for only .2 seconds).

" BACKUPS
"-------------------------------------------------
set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/backup

" PERSISTENT UNDO
"-------------------------------------------------
set undodir=$HOME/.vim/undodir
set undofile
set undolevels=10000
set undoreload=10000

" SEARCHING
"-------------------------------------------------
set ignorecase                             " Ignore case by default when searching
set smartcase                              " Switch to case sensitive mode if needle contains uppercase characters

" DEFAULT COLOURS FOR VIM - GVIMRC OVERRIDES THIS
"-------------------------------------------------

colorscheme jellybeans
set background=dark

if has("mouse")
  set mouse=a
endif

" Save on FocusLost
au FocusLost * :silent! wall

" REMOVE TRAILING WHITESPACE
autocmd BufWritePre * :%s/\s\+$//e

" Change cursor type for iTerm2
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

