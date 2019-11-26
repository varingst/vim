setlocal nolist
if winwidth('.') > 140
  wincmd L
endif

if exists(':Greqf')
  command! -buffer Index Greqf \*\k\+\*
endif
