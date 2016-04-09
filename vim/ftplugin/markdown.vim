" Set markdown for notes mode

" Set width to 80 columns with softwraps and keep it that way
set wrap
set linebreak
set nolist  " list disables linebreak
set columns=80
autocmd VimResized * if (&columns > 80) | set columns=80 | endif

" Spelling
set spell
set spelllang=en
set spellfile=$HOME/.vim/spell/en.utf-8.add

" Remap navigation to be more familiar
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$
