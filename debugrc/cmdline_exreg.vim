set nocp

augroup test
  au!
  au CmdlineEnter * const g:exreg = getreg('=', 1)
  au CmdlineLeave * call setreg('=', g:exreg) | unlockvar g:exreg | unlet g:exreg
augroup END

nnoremap <Plug>(foo) :<C-U>call search('bar')<CR>
normal! gg0
nnoremap <Plug>(foo) :<C-U>call search('bar')<CR>
normal! gg0

call feedkeys("\<Plug>(foo)")
normal! gg0
call feedkeys("\<Plug>(foo)")
normal! gg0


