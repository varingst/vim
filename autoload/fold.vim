if has('patch-8.1.1116')
  scriptversion 3
endif

fun! fold#SetMarker(level) " {{{1
  let line = getline('.')
  let open_fold = split(&foldmarker, ',')[0]
  let pat = open_fold .. '\d'

  if a:level == 0
    " level = 0 => clear marker
    let cmtopen = split(printf(&commentstring, '|'), '|')[0]

    let marker_start = match(line, '\s*\(' .. cmtopen .. '\s*\)\?' .. open_fold)
    if marker_start >= 0
      let line = line[0:marker_start - 1]
    else
      return
    endif
  else
    " level > 0 => add/update marker
    if match(line, pat) >= 0
      " update existing marker with new level
      let line = substitute(line, pat, open_fold .. a:level, '')
    else
      let line ..= printf((s:IsAlreadyComment(line)
                         \ ? ' %s'
                         \ : ' '..&commentstring),
                         \ open_fold..a:level)
    endif
  endif

  call setline('.', line)
endfun

fun! s:IsAlreadyComment(line) " {{{1
  return synIDattr(synID(line('.'), strwidth(a:line), 1), 'name') =~? 'comment'
endfun
