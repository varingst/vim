if empty($TESTOUT)
  normal! cq
endif

fun! Bail(bang)
  if len(v:errors)
    call writefile(map(v:errors, { _, err ->
          \ matchstr(err, '\f\+ line \zs\d\+:.*')}), $TESTOUT)
    normal! ZQ
  endif
endfun

fun! Log(...)
  call writefile([call('printf', a:000)], $TESTOUT, 'a')
endfun

fun! WaitFor(P, timeout, desc) abort
  let timeout = a:timeout + localtime()
  while !a:P()
    if localtime() >= timeout
      call assert_report(printf('"%s" timed out after %d seconds', a:desc, localtime() - (timeout - a:timeout)))
      return
    endif
    sleep 100ms
  endwhile
endfun

let g:EnsureList = { v -> type(v) is v:t_list ? v : [] }

fun! ExtState(extid)
  return get(filter(g:EnsureList(CocAction('extensionStats')),
  \                 { _, ext -> ext.id == a:extid }),
  \          0, { 'state': 'missing' })
endfun

fun! WaitForExtension(ext)
  call WaitFor({ -> ExtState(a:ext).state == 'activated' },
        \      5,
        \      a:ext.' activation')
endfun

command -bang Bail call Bail(<q-bang>)

augroup CocTest
  au!
  au User CocNvimInit try
        \           |   exe 'source '.$TESTIN
        \           |   call Bail('')
        \           | catch
        \           |   call Log(v:exception)
        \           | finally
        \           |   normal! ZQ
        \           | endtry
augroup END

if !get(g:, 'coc_start_at_startup', 1)
  CocStart
endif
