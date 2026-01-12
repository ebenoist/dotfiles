" Set markdown for notes mode

" Set width to 80 columns with softwraps and keep it that way
set wrap
set linebreak
set nolist  " list disables linebreak

" Spelling
set spell
set spelllang=en
set spellfile=$HOME/.config/nvim/spell/en.utf-8.add

" Remap navigation to be more familiar
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$
