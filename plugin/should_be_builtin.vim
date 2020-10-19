let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! Fold(list, F, ...) abort
  let list = a:0 ? extend([a:1], a:list) : copy(a:list)

  try
    return map(list, 'v:key ? a:F(list[v:key-1], v:val) : v:val')[-1]
  catch /^Vim\((\a\+)\)\=:E684:/
    throw "Fold: thou can'st not fold that which is empty"
  endtry
endfun

fun! EachWith(col, F, ...) abort
  if type(a:col) is v:t_list
    let acc = a:0 ? a:1 : []
    for e in a:col
      call a:F(acc, e)
    endfor
    return acc
  elseif type(a:col) is v:t_dict
    let acc = a:0 ? a:1 : {}
    for [k, v] in items(a:col)
      call a:F(acc, k, v)
    endfor
    return acc
  elseif type(a:col) is v:t_string
    return join(EachWith(split(a:col, '\zs'), F), '')
  else
    throw printf("EachWith: not handling type '%s'", type(a:col))
  endif
endfun

fun! Flatten(list, ...) abort
  let out = a:0 ? a:1 : []

  call map(copy(a:list), 'type(v:val) is v:t_list
        \ ? Flatten(v:val, out)
        \ : add(out, v:val)')

  return out
endfun

fun! Zip(...) abort
  if !a:0
    throw 'Zip: nothing to zip ..'
  endif

  let rtn = []

  try
    for i in range(len(a:1))
      call add(rtn, [])
      for list in a:000
        call add(rtn[-1], list[i])
      endfor
    endfor
  catch /^Vim\((\a\+)\)\=:E684:/
    throw 'Zip: unequal length lists'
  endtry

  return rtn
endfun

fun! Visual() abort
  let _sel = &selection
  set selection=inclusive
  let _reg = @@
  let _reg0 = @0
  silent noautocmd normal! gvy
  let rtn = @@
  let @@ = _reg
  let @0 = _reg0
  let &selection = _sel
  return split(rtn, "\n")
endfun

fun! GetChar(inputsave, ...) abort
  let C = function('getchar', a:000)

  if a:inputsave
    call inputsave()
  endif

  let c = C()
  while c == "\<CursorHold>"
    let c = C()
  endwhile

  if a:inputsave
    call inputrestore()
  endif

  return type(c) is v:t_number
        \ ? nr2char(c)
        \ : c
endfun

fun! GetCached(dict, key, Gen, ...) abort
  if !has_key(a:dict, a:key) || a:0
    let a:dict[a:key] = a:Gen(a:key)
  endif
  return a:dict[a:key]
endfun

fun! Error(...) abort
  let ex = (a:0 ? a:1 : v:exception)
  let g:throwpoint = v:throwpoint
  let g:exception = v:exception
  let default = [v:throwpoint..' => '..v:exception]

  let defmatch = matchlist(v:throwpoint, 'function \([^,]\+\), line \(\d\+\)')
  if empty(defmatch)
    return default
  endif

  let stacktrace = []

  for fcall in reverse(split(defmatch[1]..'['..defmatch[2]..']', '\.\.'))
    let funmatch = matchlist(fcall, '\v(\k+)(\[(\d+)\])?')
    if empty(funmatch)
      continue
    endif

    if funmatch[1] =~ '^\d\+$'
      let isnumfunc = v:true
      let funname = '{'..funmatch[1]..'}'
    else
      let isnumfunc = v:false
      let funname = funmatch[1]
    endif
    try
      let fundef = execute('verbose function '..funname)
      " Log fundef
      let match = matchlist(fundef, 'Last set from \(\S\+\) line \(\d\+\)')
    catch /E128/
    endtry

    if empty(match)
      continue
    endif

    let elnum = match[2] + (empty(funmatch[3]) ? 0 : funmatch[3])
    let script = match[1]

    call add(stacktrace, printf('%s:%d:%s', script, elnum, ex))
  endfor

  return empty(stacktrace) ? default : stacktrace
endfun

command! -nargs=+ Try
      \   try
      \ |   <args>
      \ |   cclose
      \ | catch
      \ |   let errout = Error()
      \ |   call setqflist([], ' ', { 'title': g:throwpoint..' => '..g:exception, 'lines': errout })
      \ |   exe 'cwindow '..len(errout)
      \ |   unlet errout
      \ | endtry

let &cpo = s:save_cpo
