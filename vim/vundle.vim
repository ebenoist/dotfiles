call plug#begin()

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
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

" JS
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'mustache/vim-mustache-handlebars'
Plug 'othree/html5.vim'

" Go
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'Shougo/deoplete.nvim', { 'for': ['go','c','c++'] }
Plug 'zchee/deoplete-go', {'do': 'make', 'for': 'go'}

" Ruby
Plug 'thoughtbot/vim-rspec', {'for': 'ruby'}
Plug 'tpope/vim-endwise', {'for': 'ruby'}
Plug 'tpope/vim-rails', {'for': 'ruby'}
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}

" C/C++/ObjC
Plug 'zchee/deoplete-clang'
Plug 'rhysd/vim-clang-format'
Plug 'octol/vim-cpp-enhanced-highlight'

call plug#end()
