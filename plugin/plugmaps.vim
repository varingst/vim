
inoremap <silent><Plug>(op#CopyLineAbove) <C-\><C-O>:call op#CopyLine('y', line('.')-1)<CR><C-\><C-O>g@
inoremap <silent><Plug>(op#CopyLineBelow) <C-\><C-O>:call op#CopyLine('e', line('.')+1)<CR><C-\><C-O>g@
inoremap <silent><Plug>(op#CopyLine)      <C-\><C-O>:call op#CopyLine('g')<CR><C-\><C-O>g@
inoremap <silent><Plug>(op#FillLineAbove) <C-\><C-O>:call op#FillLine(' ', line('.')-1)<CR><C-\><C-O>g@

nnoremap <silent><Plug>(op#ShiftLeft)  :<C-U>call op#Shift('<', v:count)<CR><ESC>g@
nnoremap <silent><Plug>(op#ShiftRight) :<C-U>call op#Shift('>', v:count)<CR><ESC>g@

nnoremap <silent><expr><Plug>(op#Replace) op#Expr('op#Replace')
xnoremap <silent><Plug>(op#Replace)       :<C-U>call op#Replace(visualmode(), v:true)<CR>

nnoremap <silent><Plug>(op#Substitute) :<C-U>set opfunc=op#Substitute<CR>g@
xnoremap <silent><Plug>(op#Substitute) :<C-U>call op#Substitute(visualmode(), v:true)<CR>
