if has('patch-8.1.1116')
  scriptversion 3
endif

let s:snips = get(s:, 'snips', {})

fun! snip#(char, filetype)
  if a:char == '?'
    call timer_start(0, {->snip#tooltip(a:filetype)})
    return ''
  else
    if !has_key(s:snips, a:filetype)
      try
        let s:snips[a:filetype] = snip#{a:filetype}#()
      catch /^Vim\((\a\+)\)\=:E117:/
        let s:snips[a:filetype] = {}
      endtry
    endif
    return get(get(s:snips, a:filetype, {}), a:char, '')
  endif
endfun

fun! snip#tooltip(filetype)
  let l:snips = get(s:snips, a:filetype, {})
  if !empty(l:snips)
    call popup_atcursor(map(items(l:snips),
          \                 { _,v -> printf('%s : %s', v[0], v[1])}),
          \             {
          \               'pos': 'botright',
          \               'filter': function('s:Filter', [l:snips]),
          \               'callback': function('s:Callback', [a:filetype]),
          \               'padding': [0, 1, 0, 1],
          \             })
  endif
  return ''
endfun

fun s:Filter(snips, winid, key)
  if has_key(a:snips, a:key) || a:key == "x"
    call popup_close(a:winid, get(a:snips, a:key, a:key))
    return v:true
  else
    return v:true
  endif
endfun

fun! s:Callback(filetype, winid, result)
  if a:result == -1 || a:result == "x"
    return
  endif
  call feedkeys(a:result, 'n')
endfun
