let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

let s:scrot_options = [
      \ '--silent',
      \]

fun! scrot#(file, ...) abort
  let file = expand(empty(a:file) ? '<cfile>' : a:file)
  let dir = fnamemodify(file, ':h')

  if !isdirectory(dir) && s:confirm("dir %s does not exist, create?", dir)
    call mkdir(dir, 'p')
  endif

  if filereadable(file)
    if s:confirm("file %s already exists, delete?", file)
      call delete(file)
    else
      return
    endif
  endif

  let cmd = add(['scrot']
        \       + get(g:, 'scrot_options', get(s:, 'scrot_options', []))
        \       + a:000, file)

  echo "taking screenshot "..file

  call system(join(cmd))
  if v:shell_error
    echoerr "could not take screenshot, scrot exited with ecode "..v:shell_error
  endif
endfun

fun! s:confirm(...)
  echo call('printf', a:000)..' y/n > '
  return tolower(nr2char(getchar())) == 'y'
endfun

let &cpo = s:save_cpo
