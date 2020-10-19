if has('patch-8.1.1116')
  scriptversion 3
endif

fun! fold#SetMarker(level)
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

fun! s:IsAlreadyComment(line)
  return synIDattr(synID(line('.'), strwidth(a:line), 1), 'name') =~? 'comment'
endfun

let s:ft = {}

fun! s:MatchPattern()
  let rtn = [[], []]

  for pat in map(split(get(b:, 'match_words', '{:}'),
            \          '[^\\]\zs,'),
            \    { _, s -> split(s, '[^\\]\zs:') })
    call add(rtn[0], pat[0])
    call add(rtn[1], pat[-1])
  endfor

  return map(rtn, { _, l -> '^\s*\('..join(l, '\|')..'\)' })
endfun

fun! fold#expr(lnum)
  let line = getline(a:lnum)

  if empty(line)
    return empty(synstack(a:lnum, 1)) ? 0 : '='
  endif

  if !has_key(s:ft, &filetype)
    let s:ft[&filetype] = s:MatchPattern()
  endif

  if match(line, s:ft[&filetype][0]) != -1
    return "a1"
  elseif match(line, s:ft[&filetype][-1]) != -1
    return "s1"
  else
    return '='
  endif
endfun

let s:ignore = {
      \ '\<brea\%[k]\>': 1,
      \ '\<retu\%[rn]\>': 1,
      \}

fun! s:MatchPattern()
  let rtn = []
  for pat in map(split(get(b:, 'match_words', '{:}'),
            \          '[^\\]\zs,'),
            \    { _, s -> split(s, '[^\\]\zs:') })
    call extend(rtn, filter(pat, '!has_key(s:ignore, v:val)'))
  endfor

  return '^\s*\('..join(rtn, '\|')..'\)'
endfun

fun! fold#expr(lnum)
  let line = getline(a:lnum)
  let level = indent(a:lnum) / shiftwidth()

  if empty(line)
    return empty(synstack(a:lnum, 1)) ? 0 : '='
  endif

  if !has_key(s:ft, &filetype)
    let s:ft[&filetype] = s:MatchPattern()
  endif

  if match(line, s:ft[&filetype]) != -1
    return level + 1
  else
    return level
  endif
endfun
