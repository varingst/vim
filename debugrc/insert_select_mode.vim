let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

" stranger things

fun! s:insert_select_mode()
  fun! s:select()
    call search('\<', 'b')
    exe "normal! \<ESC>gh"
    let g:mode = printf('insert_select_mode() mode: "%s"', mode(1))
    let g:state = printf('insert_select_mode() state: "%s"', state())
    call search('\>')
    " stopinsert
    " normal! 
    " exe "normal! \<ESC>"
  endfun

  fun! s:select()
    let g:mode = mode(1)
    exe "normal! :let g:mode = mode(1)\<CR>"
  endfun

  au CompleteDone <buffer> ++once call <SID>select()
  call complete(col('.'), ['foo', 'bar'])
  return ''
endfun

inoremap <C-X>? <C-R>=<SID>insert_select_mode()<CR>

fun! s:select_mode()
  fun! s:select()
    normal! gh
    let g:mode = printf('select_mode() reports mode "%s"', mode(1))
    let g:state = printf('select_mode() reports state "%s"', state())
  endfun
  au InsertLeave <buffer> ++once call <SID>select()
  stopinsert
  return ''
endfun
inoremap <C-F> <C-R>=<SID>select_mode()<CR>

fun! s:normal_mode()
  fun! s:normal()
    let g:mode = mode(1)
  endfun
  au InsertLeave <buffer> ++once call <SID>normal()
  stopinsert
  return ''
endfun
inoremap <C-F> <C-R>=<SID>normal_mode()<CR>


let &cpo = s:save_cpo
