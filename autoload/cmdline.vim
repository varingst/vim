if has('patch-8.1.1116')
  scriptversion 3
endif

fun! cmdline#(F, ...)
  let cmd = getcmdline()
  let pos = getcmdpos()

  let [newcmd, delta] = call(a:F, [cmd] + a:000)
  call setcmdpos(pos + delta)

  return newcmd
endfun

fun! cmdline#ToggleWordBoundary()
  let cmdline = getcmdline()
  if cmdline =~ '^\\<'
    let cmdline = cmdline[2:]
    let shift = -2
  else
    let cmdline = '\<'..cmdline
    let shift = 2
  endif

  call setcmdpos(getcmdpos() + shift)
  return cmdline
endfun

fun! cmdline#intercept()
  let cmd = getcmdline()

  try
    for [pat, l:S] in items(get(g:, 'cmdline_sugar', {}))
      if cmd =~# pat
        let cmd = type(S) is v:t_string ? l:S : l:S(cmd)
      endif
    endfor
  finally
    return cmd
  endtry
endfun

fun! cmdline#CtrlWChar()
  call inputsave()
  let char = nr2char(getchar())
  call inputrestore()
  let cmdline = getcmdline()
  let cmdpos = getcmdpos()
  let head = cmdline[:cmdpos-2]
  let tail = cmdline[cmdpos-1:]
  let newhead = substitute(head, char..'\zs.\{-}$', '', '')
  call setcmdpos(cmdpos - (strlen(head) - strlen(newhead)))
  return newhead..tail
endfun

fun! cmdline#CtrlUWord()
  call setcmdpos(1)
  return substitute(getcmdline(), '^\S*', '', '')
endfun

let s:not_escaped = '\%%(\\\)\@<!%s.*\%(\\\)\@<!%s'
let s:forward_search = printf(s:not_escaped, '/', '/')
let s:backward_search = printf(s:not_escaped, '?', '?')
let s:searchaddrpat = printf('\%%(%s\|%s\)', s:forward_search, s:backward_search)
let s:lastsearchaddrpat = printf('\%%(%s\)*.*\zs%s\ze', s:searchaddrpat, s:searchaddrpat)

fun! cmdline#incstep(cmdline, ...)
  let forward = a:0 ? a:1 : v:true
  let lastmatch = matchstr(a:cmdline, s:lastsearchaddrpat)

  let add = ((forward && lastmatch[0] == '/') || (!forward && lastmatch[0] == '?'))

  return [
        \ substitute(a:cmdline,
        \            s:lastsearchaddrpat,
        \            '\=add ? submatch(0)..submatch(0) : ""',
        \            ''),
        \ add ? strlen(lastmatch) : -strlen(lastmatch)
        \]
endfun
