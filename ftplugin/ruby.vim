" Matchit support:
if exists('loaded_matchit')
  if !exists('b:match_words')
    let b:match_ignorecase = 0
    let b:match_words =
      \ '\%(\%(\%(^\|[;=]\)\s*\)\@<=' .
      \ '\%(class\|module\|while\|begin\|until' .
      \ '\|for\|if\|unless\|def\|case\)\|\<do\)\>:' .
      \ '\<\%(else\|elsif\|ensure\|rescue\|when\)\>' .
      \ ':\%(^\|[^.]\)\@<=\<end\>'
  endif
endif

if has_key(g:, 'coc_user_config')
  if !has_key(g:coc_user_config, 'solargraph.commandPath')
    let path = get(glob('~/.rbenv/versions/*/lib/ruby/gems/*/gems/solargraph-*/bin/solargraph', v:false, v:true), -1, '')
    if !empty(path)
      let g:coc_user_config['solargraph.commandPath'] = path
    endif
  endif
endif
