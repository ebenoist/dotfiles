set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle required!
Bundle 'gmarik/vundle'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-endwise'
Bundle 'ervandew/supertab'
Bundle 'fatih/vim-go'
Bundle 'thoughtbot/vim-rspec'
Bundle 'scrooloose/syntastic'
Bundle 'othree/html5.vim'
Bundle "pangloss/vim-javascript"
Bundle "nanotech/jellybeans.vim"
Bundle 'Blackrush/vim-gocode'
Bundle 'vim-ruby/vim-ruby'
Bundle 'mustache/vim-mustache-handlebars'
Bundle 'nsf/gocode', {'rtp': 'vim/'}
Bundle 'mxw/vim-jsx'
Bundle 'majutsushi/tagbar'

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
