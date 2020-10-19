set nocp
let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! Foo()
  keeppatterns /[
  normal! va[
endfun

xnoremap F :<C-U> call Foo()<CR>
nnoremap F Foo()

let &cpo = s:save_cpo
