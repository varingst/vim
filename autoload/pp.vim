let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! pp#(...) " {{{1
  if !a:0
    return
  endif
  if type(a:1) is v:t_list
    if empty(a:1)
      return
    endif
    if type(a:1[0]) is v:t_dict
      call pp#EchoList(call('pp#DictList', a:000), &columns)
    else
      call pp#EchoList(a:1, &columns)
    endif
  elseif type(a:1) is v:t_dict
    call pp#EchoList(call('pp#Dict', a:000), &columns)
  else
    echo a:1
  endif
endfun

fun! pp#DictList(dictlist, ...) " {{{1
  let widths = {}
  for dict in a:dictlist
    call map(dict, { _, value -> type(value) is v:t_string ? value : string(value) })
    for [key, value] in items(dict)
      if strwidth(value) > get(widths, key, 0)
        let widths[key] = strwidth(value)
      endif
    endfor
  endfor
  call map(widths, { key, width -> max([width, strwidth(key)]) })
  let order = a:0 ? a:000 : sort(keys(widths))
  let format = ''
  for key in order
    let format ..= printf('%%-%ds', 2 + widths[key])
  endfor
  let lines = [
        \ call('printf', [format]+order),
        \ call('printf', [format]+map(copy(order), { _, key -> repeat('-', widths[key]) })),
        \]

  for dict in a:dictlist
    call add(lines, call('printf', [format] + map(copy(order), { _, key -> get(dict, key, '') })))
  endfor

  return map(lines, 'trim(v:val)')
endfun

fun! pp#Dict(dict, ...) " {{{1
  let dict = a:dict
  let order = a:0 ? a:000 : sort(keys(a:dict))
  let width = 0
  call map(dict, { _, value -> type(value) is v:t_string ? value : string(value) })
  for [k, v] in items(dict)
    if strwidth(k) > width
      let width = strwidth(k)
    endif
  endfor
  let format = printf('%%-%ds => %%s', width)

  return map(order, { _, key -> printf(format, key, dict[key]) })
endfun

fun! pp#EchoList(list, width) " {{{1
  for line in a:list
    echo strdisplaywidth(line) > a:width - 2
          \ ? line[:a:width - 4]..'..'
          \ : line
  endfor
endfun

fun! pp#IsKeyword() " {{{1
  let out = []
  for part in split(&iskeyword, ',')
    if part == '@'
      call add(out, '\w')
    elseif part =~# '\d\+-\d\+'
      call add(out, join(map(call('range', split(part, '-')), 'nr2char(v:val)'), ''))
    elseif part =~# '\d\+'
      call add(out, nr2char(part))
    else
      call add(out, part)
    endif
  endfor
  return join(out, ',')
endfun

let &cpo = s:save_cpo
