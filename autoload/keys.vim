
let s:all_ft = '*'

fun! keys#init()
  let s:keys = {}
  let s:width = {}
  let s:fkeys = {}
endfun

fun! keys#list(...)
  let args = a:0 ? a:1 : { 'all': 1 }

  let filetype = get(args, 'filetype', &filetype)

  let keys = get(s:keys, filetype, [])

  if get(args, 'all', 0)
    let keys += s:keys[s:all_ft]
  endif

  let keys = filter(keys, get(args, 'filter', {idx, val -> 1}))

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

fun! s:MapFkeys(keys)
  for [key, cmd] in items(a:keys)
    let s:fkeys[key] = cmd
    exe 'nnoremap ' . key . ' ' . cmd . '<CR>'
    exe 'inoremap ' . key . ' <ESC>' . cmd . '<CR>'
  endfor
endfun

fun! keys#flist(...)
  let rows = [['']]
  let format = '%-7s'
  for pre in a:0 ? a:000 : ['', '<leader>']
    call add(rows[0], pre)
    let max_width = strdisplaywidth(pre)

    for i in range(1, 12)
      let key = '<F'.i.'>'
      if len(rows) < i + 1
        call add(rows, [])
        call add(rows[-1], key)
      endif
      let key = pre.key
      let mapping = get(s:fkeys, key, '')
      let max_width = max([max_width, strdisplaywidth(mapping)])
      call add(rows[i], mapping)
    endfor

    let format .= '%-'.(max_width + 2).'s'
  endfor

  for row in rows
    echo call('printf', [format] + row)
  endfor
endfun

command! -nargs=+ Key call s:AddKey(s:all_ft, <args>)
command! -nargs=+ FtKey call s:AddKey(<args>)
command! -nargs=1 FKeys call s:MapFkeys(<args>)
