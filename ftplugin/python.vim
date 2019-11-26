if has_key(g:, 'coc_user_config')
  if !has_key(g:coc_user_config, 'python.jediPath')
    let path = matchstr(get(filter(systemlist('pip show jedi'),
          \                        { _, line -> line =~ '^Location:' }),
          \                 0, ''),
          \             '^Location: \zs\f\+')
    if !empty(path)
      let g:coc_user_config['python.jediPath'] = path
    endif
  endif
endif
