if has('patch-8.1.1116')
  scriptversion 3
endif

fun! buffer#Open(files, bang)
  if a:bang
    call buffer#Unlist(0, 0, 0, airline#extensions#tabline#buflist#list())
  endif

  let l:files = reverse(a:files)
  let l:opts = []

  while l:files[-1][0] == '+'
    call add(l:opts, remove(l:files, -1))
  endwhile

  for l:file in reverse(a:files)
    if !isdirectory(l:file)
      exe printf('e %s %s', join(l:opts), l:file)
    endif
  endfor
endfun

fun! buffer#Unlist(airline_buffer, bufnr, ...)
  let l:current_bufnr = bufnr('')
  let l:provided = a:0 && type(a:1) is v:t_list && !empty(a:1)

  if a:0
    let l:bufinfo = []
    for l:bufnr in l:provided ? a:1 : airline#extensions#tabline#buflist#list()
      " don't omit current buffer if we were provided a list
      if l:current_bufnr != l:bufnr || l:provided
        call extend(l:bufinfo, getbufinfo(l:bufnr))
      endif
    endfor
  elseif a:airline_buffer
    let l:bufinfo = getbufinfo(get(airline#extensions#tabline#buflist#list(),
          \                    a:airline_buffer - 1))
  elseif a:bufnr
    let l:bufinfo = getbufinfo(a:bufnr)
  else
    let l:bufinfo = getbufinfo(l:current_bufnr)
  endif

  for l:buf in l:bufinfo
    if l:buf.changed
      continue
    endif

    if l:buf.bufnr == l:current_bufnr && !l:provided
      exe "normal \<Plug>AirlineSelectNextTab"
      let l:current_bufnr = bufnr('')
    endif

    silent exe l:buf.bufnr..'bufdo setlocal nobuflisted'

    for l:winnr in map(l:buf.windows,
          \            {_, winid -> getwininfo(winid)[0].winnr})
      silent! exe l:winnr..'windo close'
    endfor
  endfor

  exe l:current_bufnr..'b'
endfun
