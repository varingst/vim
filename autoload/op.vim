if has('patch-8.1.1116')
  scriptversion 3
endif

fun! op#Edge(pos, mode)
  let s:edgefmt = 'normal! '..(a:mode ? 'gv' :  '')..'%s'..(a:pos ? '[' : ']')
  set opfunc=op#_edge
  return ''
endfun

fun! op#_edge(type)
  silent exe printf(s:edgefmt, a:type == 'line' ? "'" : "`")
endfun

" -- SHIFT ---------------------------------------------------------------- {{{1

fun! op#Shift(direction, count) "{{{2
  let s:shift_direction = a:direction
  let s:shift_count = a:count
  let &opfunc = s:sid('Shift')
endfun

fun! s:Shift(type) "{{{2
  if a:type == 'line'
    exe "normal! '[v']"..s:count1(s:shift_count)..s:shift_direction
  else
    exe "normal! `[v`]"..s:count1(s:shift_count)..s:shift_direction
  endif
endfun

" -- UTIL ----------------------------------------------------------------- {{{1

fun! op#Expr(func) "{{{2
  " must do it this way to provide register
  let &opfunc = a:func =~ '#' ? a:func : s:sid(a:func)
  return 'g@'
endfun

fun! s:sid(func) "{{{2
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')..a:func
endfun

fun! s:count1(count) "{{{2
  return a:count == 0 ? 1 : a:count
endfun

fun! s:savereg(...) "{{{2
  let s:registers = {}
  for l:reg in range(9) + a:000
    let s:registers[l:reg] = [getreg(l:reg), getregtype(l:reg)]
  endfor
endfun

fun! s:restorereg() "{{{2
  for [reg, pair] in items(get(s:, 'registers', {}))
    call setreg(reg, pair[0], pair[1])
  endfor
endfun
