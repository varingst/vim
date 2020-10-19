let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! s:stringlist(input, wrap)
  if match(a:input, "\<C-J>") != -1
    let sub = printf('%s&%s,', a:wrap, a:wrap)
    return split(a:input, "\<C-J>")
          \ ->map({ _, s -> substitute(s, '\s\+\zs.*', sub, 'g') })
  else
    return split(a:input, '[^\\]\zs\s')
          \ ->map({ _, s -> a:wrap..substitute(s, '\\ ', ' ', 'g')..a:wrap })
          \ ->join(', ')
  endif
endfun

xnoremap <Plug>(stringlist-single) c<C-R><C-O>=<SID>stringlist(@", "'")<CR>
xnoremap <Plug>(stringlist-double) c<C-R><C-O>=<SID>stringlist(@", '"')<CR>

imap <Plug>(stringlist-single) <ESC>vi[<Plug>(stringlist-single)
imap <Plug>(stringlist-double) <ESC>vi[<Plug>(stringlist-double)

let &cpo = s:save_cpo
