function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")

  " Do the business:
  %s/\s\+$//e

  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

autocmd BufWritePre *.rb,*.haml :call <SID>StripTrailingWhitespaces()

autocmd BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru,*.god}     set ft=ruby
autocmd BufRead,BufNewFile {*.md,*.mkd,*.markdown}                         set ft=markdown
autocmd BufRead,BufNewFile {COMMIT_EDITMSG}                                set ft=gitcommit
autocmd BufRead,BufNewFile *.es6 setfiletype javascript
autocmd! BufWritePost * Neomake
autocmd bufwritepost .vimrc source $MYVIMRC