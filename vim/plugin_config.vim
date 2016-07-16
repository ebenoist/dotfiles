" NERDTree:
let NERDChristmasTree = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
let NERDTreeHijackNetrw = 1
let NERDTreeIgnore=['\.$', '\~$', '.DS_Store']

" RubyAndRails:
" Highlight ruby operators
let ruby_operators = 1

" NERDCommenter:
let NERDDefaultNesting = 0
let NERDRemoveExtraSpaces = 1
let NERDSpaceDelims = 1

" CtrlP
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*Godeps/*,*vendor/*
let g:ctrlp_max_height = 40
let g:ctrlp_clear_cache_on_exit   = 1
let g:ctrlp_working_path_mode     = "ra"
let g:ctrlp_match_window_reversed = 0

let g:ctrlp_user_command = {
  \ 'types': {
     \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others | sed "/Godeps/d"'],
   \ },
  \ 'fallback': 'find %s -type f'
\ }


" SYNTAX
" let g:syntastic_ruby_checkers=['rubylint']
let g:syntastic_javascript_checkers = ['eslint']

" Rspec
let g:rspec_command = "!bundle exec rspec -fd --tty --color {spec}"

" Let ack/vim use ag for search
let g:ackprg = 'ag --nogroup --nocolor --column'

" SuperTab
set omnifunc=syntaxcomplete#Complete
au FileType go let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1

" GO
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:deoplete#enable_at_startup = 1
let g:go_list_type = "quickfix"
set completeopt+=noinsert
set completeopt+=noselect
