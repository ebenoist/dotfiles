call plug#begin('~/.config/nvim/plugged')

" General
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'w0rp/ale'
Plug 'diepm/vim-rest-console'
Plug 'jlanzarotta/bufexplorer'
Plug 'ervandew/supertab'

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

" Docs
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

call plug#end()
