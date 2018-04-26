
" Matchit support:
if exists("loaded_matchit")
  if !exists("b:match_words")
    let b:match_ignorecase = 0
    let b:match_words =
\ '\%(\%(\%(^\|[;=]\)\s*\)\@<=\%(class\|module\|while\|begin\|until\|for\|if\|unless\|def\|case\)\|\<do\)\>:' .
\ '\<\%(else\|elsif\|ensure\|rescue\|when\)\>:\%(^\|[^.]\)\@<=\<end\>'
  endif
endif

nnoremap <leader>ri :call ri#OpenSearchPrompt(1)<CR>
nnoremap <leader>rw :call ri#LookupNameUnderCursor()<CR>
