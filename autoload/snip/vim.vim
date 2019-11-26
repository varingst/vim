fun! snip#vim#()
  return {
  \ 'f': "fun! \<C-R>=f#AutoloadPrefix()\<CR>() abort\<CR>endfun\<C-O>:call search('(', 'b')\<CR>",
  \ 's': "fun! s:() abort\<CR>endfun\<C-O>:call search('(', 'b')\<CR>",
  \ 'a': "{ _,  -> }\<C-O>:call search(',  ', 'be')\<CR>",
  \ 'i': "if \<CR>endif\<ESC>:call search(' ', 'be')\<CR>a",
  \ 'w': "while \<CR>endwhile\<ESC>:call search('while ', 'be')\<CR>a",
  \ 'o': "for \<CR>endfor\<ESC>:call search(' ', 'b')\<CR>a",
  \ 't': "try\<CR>catch\<CR>endtry\<ESC>kO",
  \ 'd': "{\<CR>\\ \<CR>\\}\<ESC>:call search('\\\\ ', 'be')\<CR>a",
  \ 'l': "[\<CR>\\ \<CR>\\]\<ESC>:call search('\\\\ ', 'be')\<CR>a",
  \ 'm': "'': function('')\<ESC>:call search(':', 'b')\<CR>hi",
  \ 'e': "/^Vim\\((\\a\\+)\\)\\=:E:/\<C-O>:call search(':', 'b')\<CR>",
  \}
endfun
