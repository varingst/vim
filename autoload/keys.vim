
let s:all_ft = '*'

fun! keys#clear()
  let s:keys = {}
  let s:width = {}
endfun

fun! keys#add(...)
  call s:Add(s:all_ft, a:000)
endfun

fun! keys#add_ft(ft, ...)
  for ft in split(a:ft, ',')
    call s:Add(ft, a:000)
  endfor
endfun

fun! keys#list(...)
  let keys = filter(get(s:keys, &ft, []) + s:keys[s:all_ft],
                  \ a:0 ? a:1 : {idx, val -> 1})

  if !len(keys)
    echo "no keys to list .."
    return
  endif

  let format = '%-'.(s:width['keys'] + 2).'s%-'.(s:width['mode'] + 2).'s%s'
  let available_width = &columns - strdisplaywidth(printf(format, '', '', '  '))

  for entry in keys
    echo printf(format, entry['keys'], entry['mode'],
          \ strdisplaywidth(entry['text']) > available_width
          \ ? entry['text'][:available_width - 2].'..'
          \ : entry['text'])
  endfor
endfun

fun! s:Add(ft, args)
  let entry = { 'keys': a:args[0] }
  if len(a:args) == 2
    let entry['mode'] = 'n'
    let entry['text'] = a:args[1]
  else
    let entry['mode'] = a:args[1]
    let entry['text'] = a:args[2]
  endif

  call add(s:KeyList(a:ft), entry)

  for k in ['keys', 'mode', 'text']
    let s:width[k] = max([get(s:width, k, 0), strdisplaywidth(entry[k])])
  endfor
endfun

fun s:KeyList(...)
  let ft = a:0 ? a:1 : s:all_ft

  if !has_key(s:keys, ft)
    let s:keys[ft] = []
  endif
  return s:keys[ft]
endfun

