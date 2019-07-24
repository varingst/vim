if expand("%:e") ==# "spice"
  command! -nargs=? -buffer SpiceControl
    \   let s:generated = expand("%")
    \ | exe 'split '.fnamemodify(strlen(<q-args>) ? <q-args> : s:generated, ":r").".sp"
else
  command! -nargs=0 -buffer SpiceRun  write | term ngspice --batch %
  command! -nargs=0 -buffer SpiceRunI write | term ngspice --interactive %

  if line('$') == 1 && getline(1) == ''
    call setline(1, [
          \ ".title ".expand("%:r"),
          \ ".include ".get(s:, 'generated', ''),
          \ ".control",
          \ "",
          \ ".endc"])
    normal! 4G
  endif
endif
