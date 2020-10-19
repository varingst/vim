let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

let b:highlighted_blocks = {}

command! -buffer HighlightBlock
      \ call extend(b:highlighted_blocks, { getline('.')[3:]: v:false }, 'keep')

fun! s:highlight()
  let curpos = getcurpos()
  silent keepjumps keeppatterns g/```\w\+/HighlightBlock
  for [ft, highlighted] in items(b:highlighted_blocks)
    if !highlighted
      let b:highlighted_blocks[ft] = v:true
      exe 'PandocHighlight '..ft
    endif
  endfor
  call setpos('.', curpos)
endfun

call s:highlight()

augroup pandoc_highlight
  au!
  au BufWritePost <buffer> call s:highlight()
augroup END

let &cpo = s:save_cpo
