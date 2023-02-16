let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

inoremap <Plug>(complete#tag-args) <C-R><C-R>=<SID>tag_args()<CR>
nnoremap <Plug>(complete#select-next-arg) :<C-U>call <SID>select_next_arg()<CR>

fun! s:tag_args()
  let pos = getcurpos()
  if !search('\<', 'b', line('.'))
    return ''
  endif

  let tag = expand('<cword>')
  call setpos('.', pos)

  au CompleteDone <buffer> ++once call <SID>finish()
  call taglist('^'..tag..'$')
        \  ->filter("v:val.kind == 'f'")
        \  ->map({_, tag -> matchstr(tag.cmd, '\V\C'..tag.name..'\zs(\.\{-})')})
        \  ->complete(pos[2])

  return ''
endfun

fun! s:select_next_arg(...)
  call search('[(,]\s*\zs', '', line('.'))
  normal! gh
  call search('.\ze[,)]', '', line('.'))
endfun

fun! s:finish()
  if empty(v:completed_item) || v:completed_item.word == '()'
    return
  endif

  call search('.(', 'b')
  call s:select_next_arg()
  exe "normal! \<Right>"
  stopinsert
endfun

augroup plugin_complete
  au!
  au CompleteDonePre *
        \   if complete_info(['mode']).mode == 'tags'
        \ |   call feedkeys("\<Plug>(complete#tag-args)", 'i')
        \ | endif
augroup END

if get(g:, 'plugin_complete_TESTING') || index(v:argv, '--clean') != -1
  let &tags = $HOME..'/.vim/test/data/complete/tags'

  imap <C-X>a <Plug>(complete#tag-args)
  nmap ga <Plug>(complete#select-next-arg)

  fun! SCall(f, ...)
    return call(a:f, a:000)
  endfun
endif

let &cpo = s:save_cpo
