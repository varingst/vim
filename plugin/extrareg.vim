let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

if !exists('g:x')
  unlockvar 2 g:x
  let g:x = []
  lockvar 2 g:x
endif

if !exists('g:y')
  unlockvar 2 g:y
  let g:y = []
  lockvar 2 g:y
endif

command! -bang Registers
      \    if !empty(g:x)
      \  |   echohl Title
      \  |   echo "Small Deletes"
      \  |   echohl None
      \  |   for i in range(len(g:x))
      \  |     echo printf('x[%d]  %s', i, empty(<q-bang>) ? g:x[i] : '<'..strtrans(g:x[i])..'>')
      \  |   endfor
      \  | endif
      \  | if !empty(g:x)
      \  |   echohl Title
      \  |   echo "Yank History"
      \  |   echohl None
      \  |   for i in range(len(g:y))
      \  |     echo printf('y[%d]  %s', i, empty(<q-bang>) ? g:y[i] : '<'..strtrans(g:y[i])..'>')
      \  |   endfor
      \  | endif

augroup extra_reg
  au!
  au TextYankPost * if @- != get(g:x, 0, '') && index(g:x, @-) == -1
        \         |   unlockvar 2 g:x
        \         |   call insert(g:x, @-)
        \         |   let g:x = g:x[:9]
        \         |   lockvar 2 g:x
        \         | endif
        \         | if @0 != get(g:y, 0, '') && index(g:y, @0) == -1
        \         |   unlockvar 2 g:y
        \         |   call insert(g:y, @0)
        \         |   let g:y = g:y[:9]
        \         |   lockvar 2 g:y
        \         | endif
augroup END

let &cpo = s:save_cpo
