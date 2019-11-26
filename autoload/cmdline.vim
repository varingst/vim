if has('patch-8.1.1116')
  scriptversion 3
endif

fun! cmdline#ToggleWordBoundary()
  let l:cmdline = getcmdline()
  if l:cmdline =~ '^\\<'
    let l:cmdline = cmdline[2:]
    let l:shift = -2
  else
    let l:cmdline = '\<'..cmdline
    let l:shift = 2
  endif

  call setcmdpos(getcmdpos() + l:shift)
  return l:cmdline
endfun
