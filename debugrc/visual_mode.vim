set nocompatible

fun! Visual(msg) range
  " exe "normal! gvgv\<ESC>"
  normal! gv
  call add(g:out, [mode(), line('.'), line("v"), line("'<"), line("'>"), a:firstline, a:lastline, a:msg])
endfun

fun! VisualPos(msg)
  normal! gv
  call add(g:out, add([getpos('.'), getpos("'<"), getpos("'>")]->map('v:val[1:2]'), a:msg))
endfun

fun! Pos()
  echom [getpos('.'), getpos("'<"), getpos("'>")]
endfun

fun! Pos2()
  exe "normal! gv\<ESC>"
  echom [getpos('.'), getpos("'<"), getpos("'>")]
endfun

fun! Run()
  e $HOME/.vim/debugrc/visual_mode.vim
  let g:out = []
  exe "normal! ggvG:call Visual('visual-line down')\<CR>"
  exe "normal! Gvgg:call Visual('visual-line up')\<CR>"

  exe "normal! ggvG:\<C-U>call Visual('normal down')\<CR>"
  exe "normal! Gvgg:\<C-U>call Visual('normal up')\<CR>"

  exe "normal! ggvG\<ESC>:call Visual('hard normal down')\<CR>"
  exe "normal! Gvgg\<ESC>:call Visual('hard normal up')\<CR>"
endfun

fun! Run2()
  e $HOME/.vim/debugrc/visual_mode.vim
  let g:out = []

  exe "normal! ggvG:\<C-U>call VisualPos('normal down')\<CR>"
  exe "normal! Gvgg:\<C-U>call VisualPos('normal up')\<CR>"
endfun

fun! Report2()
  call Run2()
  call _Report("cur: %s, %s -> %s %s")
endfun

fun! Report()
  call Run()
  call _Report("mode: %s cur: %2d, v: %2d %2d -> %2d, %2d -> %2d %s")
endfun

fun! _Report(fmt)
  for e in g:out
    echo call('printf', ([a:fmt] + e)->map('string(v:val)'))
  endfor
endfun

au VimEnter * call Run()
