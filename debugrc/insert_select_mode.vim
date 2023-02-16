let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

" stranger things
"

    " stopinsert
    " normal! 
    " exe "normal! \<ESC>"
    "

  " fun! s:select()
  "   let g:mode = mode(1)
  "   " exe "normal! :let g:mode = mode(1)\<CR>"
  " endfun
  "
    fun! s:insert_select_mode()
      fun! s:select()
        call search('\<', 'b')
        let g:mode_before = mode(1)
        normal! gh
        let g:mode = mode(1)
        call search('\>')
        stopinsert
      endfun

      au CompleteDone <buffer> ++once call <SID>select()
      call complete(col('.'), ['foo', 'bar'])
      return ''
    endfun

    inoremap <C-X>? <C-R>=<SID>insert_select_mode()<CR>

" inoremap <C-Q> <Insert>

" fun! s:select_mode()
"   fun! s:select()
"     normal! gh
"     let g:mode = printf('select_mode() reports mode "%s"', mode(1))
"     let g:state = printf('select_mode() reports state "%s"', state())
"   endfun
"   au InsertLeave <buffer> ++once call <SID>select()
"   stopinsert
"   return ''
" endfun
" inoremap <C-F> <ESC>:echo "foo!"<CR>

" fun! s:normal_mode()
"   fun! s:normal()
"     let g:mode = mode(1)
"   endfun
"   au InsertLeave <buffer> ++once call <SID>normal()
"   stopinsert
"   return ''
" endfun
" inoremap <C-F> <C-R>=<SID>normal_mode()<CR>


let &cpo = s:save_cpo
