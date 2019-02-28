
" copy {motion} to @o, put on next line
fun! op#copyO(type, ...) " {{{1
  let sel_save = &selection
  let &selection = "inclusive"

  if a:0
    silent exe "normal! gv\"oyo\<C-R>o"
    startinsert!
  elseif a:type == char
    silent exe "normal! `[v`]\"oyo\<C-R>o"
    startinsert!
  endif

  let &selection = sel_save
endfun

" double {motion}
fun! op#double(type, ...) " {{{1
  let sel_save = &selection
  let &selection = "inclusive"

  let reg_save = @@

  if a:0 " invoked from visual mode
    silent exe "normal! gvyP"
  elseif a:type == 'line'
    silent exe "normal! '[V']yP"
  else
    silent exe "normal! `[v`]yP"
  endif

  let @@ = reg_save
  let &selection = sel_save
endfun

" swap {motion} with @"
fun! op#replace(type, ...) " {{{1
  let sel_save = &selection
  let &selection = 'inclusive'

  let r_save = @r
  let @r = @"

  if a:0
    silent exe "normal! gvd\"rp"
  elseif a:type == 'line'
    silent exe "normal! '[V']d\"rp"
  else
    silent exe "normal! `[v`]d\"rp"
  endif

  let @r = r_save
  let &selection = sel_save
endfun

fun! op#substitute(type, ...) " {{{1
  let s = @s
  if a:0
    normal! gv"sy
  elseif a:type == 'line'
    normal! '[v']"sy
  else
    normal! `[v`]"sy
  endif
  let sel = substitute(escape(@s, '\/.*$^~[]'), "\<NL>", '\\n', 'g')
  let @s = s
  call feedkeys(printf("\<ESC>:%%s/%s//g\<Left>\<Left>", sel))
endfun

fun! op#map(key, func, ...) " {{{1
  for mode in split(a:0 ? a:1 : 'nx', '\zs')
    if 'n' == mode
      exe printf('nnoremap <silent>%s :set opfunc=%s<CR>g@',
            \    a:key, a:func)
    elseif 'xv' =~# mode
      exe printf('%snoremap <silent>%s :<C-U>call %s(visualmode(), v:true)<CR>',
            \    mode, a:key, a:func)
    elseif 'i' == mode
      exe printf('inoremap <silent>%s <ESC>:set opfunc=%s<CR>g@',
            \    a:key, a:func)
    endif
  endfor
endfun
