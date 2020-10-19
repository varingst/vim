set nocp
let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif
set noswapfile

let g:sym = {}
let g:qf_disable_statusline = 1
let g:statusline = stl#statusline()
set tabline=%!stl#tabline()
set laststatus=2
set showtabline=2

augroup test
  au VimEnter * call Run()
augroup END

fun! Run()
  e ~/.vimrc
  for _ in range(5)
    split ~/.vim/autoload/stl.vim
  endfor
  copen
  wincmd w

  profile start /tmp/vim_stl_profile.txt

  profile func *

  let times = []
  let n = empty($RUNS) ? 1000 : str2nr($RUNS)

  while n
    let start = reltime()
    wincmd w
    redrawstatus!
    let end = reltime()
    call add(times, reltimefloat(reltime(start, end)))
    let n -= 1
  endwhile

  let sum = 0
  for t in times
    let sum += t
  endfor

  call writefile([
        \ 'avg: '..printf('%f', sum / len(times)),
        \], '/tmp/vim_stl_profile_avg.txt', 's')

  qa!
endfun

let &cpo = s:save_cpo
