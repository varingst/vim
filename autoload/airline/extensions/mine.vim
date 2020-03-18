let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! airline#extensions#mine#status() abort
  let msg = ''
  let msg ..= !empty(gutentags#statusline()) ? g:sym.tag : ''
  let msg ..= get(g:, 'coc_process_pid') ? g:sym.complete : ''
  let msg ..= keys#statusline()
  return msg
endfun

let &cpo = s:save_cpo
