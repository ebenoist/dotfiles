call plug#begin('~/.config/nvim/plugged')

" General
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'neomake/neomake'
Plug 'tpope/vim-fugitive'
Plug 'kassio/neoterm'
Plug 'Shougo/deoplete.nvim'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'diepm/vim-rest-console'

" JS
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'othree/html5.vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'leafgarland/typescript-vim'

" Go
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'zchee/deoplete-go', {'do': 'make', 'for': 'go'}

" Ruby
Plug 'thoughtbot/vim-rspec', {'for': 'ruby'}
Plug 'tpope/vim-endwise', {'for': 'ruby'}
Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}

call plug#end()
