let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! airline#extensions#mine#status() abort
  let msg = ''
  let msg ..= !empty(gutentags#statusline()) ? g:sym.tag : ''
  let msg ..= get(g:, 'coc_process_pid') ? g:sym.complete : ''
  return msg
endfun

" fun! airline#extensions#mine#init(ext) abort
"   call airline#parts#define_function('mine', 'airline#extensions#mine#status')
" endfun

let &cpo = s:save_cpo
