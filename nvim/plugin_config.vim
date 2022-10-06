" NERDTree:
let NERDChristmasTree = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
let NERDTreeHijackNetrw = 1
let NERDTreeIgnore=['\.$', '\~$', '.DS_Store']

" RubyAndRails:
" Highlight ruby operators
let ruby_operators = 1
"
" NERDCommenter:
let NERDDefaultNesting = 0
let NERDRemoveExtraSpaces = 1
let NERDSpaceDelims = 1
"

" Let ack/vim use ag for search
let g:ackprg = 'ag --nogroup --nocolor --column'

" FZF
"let $FZF_DEFAULT_COMMAND = 'ag -l -g ""'

" SuperTab
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
let g:go_def_mode = "gopls"
" let g:go_highlight_diagnostic_errors = 0
" let g:go_highlight_diagnostic_warnings = 0
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

let g:mkdp_markdown_css = '/Users/erik/dev/dotfiles/gdocs.css'

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
