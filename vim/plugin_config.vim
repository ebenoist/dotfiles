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

" FZF
let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'

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
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:deoplete#enable_at_startup = 1

set completeopt+=noinsert
set completeopt+=noselect
set completeopt-=preview

let g:deoplete#enable_profile = 1

" C
let g:deoplete#sources#clang#libclang_path = "/usr/local/Cellar/llvm/3.8.1/lib/libclang.dylib"
let g:deoplete#sources#clang#clang_header = "/usr/local/Cellar/llvm/3.8.1/include/clang"
let g:neomake_cpp_clang_args = ["-std=c++11", "-Wextra", "-Wall", "-fsanitize=undefined","-g"]
autocmd FileType c ClangFormatAutoEnable
autocmd FileType cpp ClangFormatAutoEnable
let g:clang_format#code_style="chromium"
let g:neomake_logfile="/Users/ebenoist/dev/neomake/log"

" vim-test
let test#strategy = "neoterm"

" Notes
let vim_markdown_preview_hotkey='<C-m>'
