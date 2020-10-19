let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

let s:obj = {}
for [keys, matches] in items({
      \ '[]': ['[',']'],
      \ '()b': ['(',')'],
      \ 't': ['<\(br\|meta\|/\)\@![^>]\+>', '</[^>]\+>'],
      \ '<>': ['<', '>'],
      \ '{}B': ['{', '}'],
      \})
  for key in split(keys, '\zs')
    let s:obj[key] = matches
  endfor
endfor

fun! S(state)
  return get(s:, a:state)
endfun

fun! nextobj#foo()
  " keeppatterns /[
  call search('[', 'Wz')
  " return "\<ESC>va["
  return ''
endfun

fun! nextobj#(keys, count, mode)
  let c = a:count
  let keys = matchlist(a:keys, '\v(.)(.)(.+)')
  if empty(keys)
    return
  endif
  let [type, direction, object] = keys[1:3]

  let @n = type..'n'..object
  let @p = type..'N'..object

  if !has_key(s:obj, object)
    return ''
  endif

  let flags ='Wz'..(direction ==# 'n' ? '' : 'b')
  let pat = s:obj[object][direction !=# 'n']
  while c
    call search(pat, flags)
    let c -= 1
  endwhile
  exe "normal! \<ESC>"..visualmode()..type..object
endfun

let &cpo = s:save_cpo
