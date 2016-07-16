call plug#begin()

" General
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'kien/ctrlp.vim'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'kassio/neoterm'
Plug 'Shougo/deoplete.nvim'

" JS
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'mxw/vim-jsx', {'for': 'javascript'}
Plug 'mustache/vim-mustache-handlebars', {'for': 'handlebars'}
Plug 'othree/html5.vim', {'for': 'html'}

" Go
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'zchee/deoplete-go', {'do': 'make', 'for': 'go'}

" Ruby
Plug 'thoughtbot/vim-rspec', {'for': 'ruby'}
Plug 'tpope/vim-endwise', {'for': 'ruby'}
Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}
call plug#end()
