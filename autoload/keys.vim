
let s:all_ft = '*'

fun! keys#init()
  let s:keys = {}
  let s:width = {}
endfun

fun! keys#list(...)
  let keys = filter(get(s:keys, &filetype, []) + s:keys[s:all_ft],
                  \ a:0 ? a:1 : {idx, val -> 1})

  if !len(keys)
    echo 'no keys to list ..'
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

fun! s:AddKey(ft, ...)
  let entry = {
        \ 'text': a:1,
        \ 'keys': a:2,
        \ 'mode': a:0 > 2 ? a:3 : 'n'
        \ }
  call add(s:KeyList(a:ft), entry)

  for k in ['keys', 'mode', 'text']
    let s:width[k] = max([get(s:width, k, 0), strdisplaywidth(entry[k])])
  endfor
endfun

fun! s:KeyList(...)
  let ft = a:0 ? a:1 : s:all_ft

  if !has_key(s:keys, ft)
    let s:keys[ft] = []
  endif
  return s:keys[ft]
endfun

command! -nargs=+ Key call s:AddKey(s:all_ft, <args>)
command! -nargs=+ FtKey call s:AddKey(<args>)
