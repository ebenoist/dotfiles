autocmd BufNewFile,BufRead PULLREQ_EDITMSG set syntax=gitcommit
autocmd BufNewFile,BufRead COMMIT_EDITMSG set syntax=gitcommit

setlocal columns=98
setlocal spell
setlocal spelllang=en
setlocal spellfile=$HOME/.config/nvim/spell/en.utf-8.add

" Set width to 80 columns with softwraps and keep it that way
setlocal wrap
setlocal linebreak
setlocal nolist  " list disables linebreak
setlocal textwidth=0
setlocal wrapmargin=0

" Remap navigation to be more familiar
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$
