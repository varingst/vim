if has('patch-8.1.1116')
  scriptversion 3
endif

fun! fs#MkMissingDir(filename) abort
  let dirs = fnamemodify(a:filename, ':h')
  if a:filename !~? ':' && !isdirectory(dirs)
    call mkdir(dirs, 'p')
  endif
endfun

fun! fs#SetExeOnShebang(filetype, filename) abort
  if empty(a:filetype)
   \ && fnamemodify(a:filename, ':t') !~# '\.'
   \ && getline(1) =~# '^#!'
    filetype detect
    call setfperm(a:filename,
          \       substitute(getfperm(a:filename),
          \                  '\(r[w-]\)-', '\1x', 'g'))
  endif
endfun
