if has('patch-8.1.1116')
  scriptversion 3
endif

" -- COPY LINE ------------------------------------------------------------ {{{1

fun! op#CopyLine(register, ...) "{{{2
  normal! m`
  let s:copyline_register = a:register

  if a:0 && a:1
    let l:lnum = a:1
  else
    call inputsave()
    let l:lnum = superg#(line('.'), str2nr(input('superg# > ')))
    call inputrestore()
  endif

  let l:startofline = &startofline
  let &startofline = 0
  exe l:lnum
  let &startofline = l:startofline
 
  let &opfunc = s:sid('CopyLine')
endfun

fun! s:CopyLine(type) "{{{2
  if a:type == 'char'
    silent exe 'normal! `[v`]"'..s:copyline_register..'y'
  endif
  normal! g``
  if a:type == 'char'
    silent exe 'normal! "'..s:copyline_register..'p'
  endif
  normal! g`]

  let l:ve = &virtualedit
  let &virtualedit = 'onemore'
  normal! l
  startinsert
  let &virtualedit = l:ve
endfun

" -- FILL LINE ------------------------------------------------------------ {{{1

fun! op#FillLine(char, ...) "{{{2
  normal! m`

  let s:fillchar = a:char

  if a:0 && a:1
    let l:lnum = a:1
  else
    call inputsave()
    let l:lnum = superg#(line('.'), str2nr(input('superg# > ')))
    call inputrestore()
  endif

  let l:startofline = &startofline
  let &startofline = 0
  exe l:lnum
  let &startofline = l:startofline

  let &opfunc = s:sid('FillLine')
endfun

fun! s:FillLine(type) "{{{2
  if a:type == 'char'
    let l:pad = col("']") - col("'[")
  else
    return
  end

  normal! g``
  let g:exe = printf("normal! \"=repeat('%s', %d)\<CR>p", s:fillchar, l:pad)
  let g:airline_debug = g:exe

  exe g:exe
  normal! g`]

  let l:ve = &virtualedit
  let &virtualedit = 'onemore'
  normal! l
  startinsert
  let &virtualedit = l:ve
endfun

" -- REPLACE -------------------------------------------------------------- {{{1

fun! op#Replace(type, ...) abort "{{{2
  let l:reg = v:register

  if l:reg =~! '\C[a-z"*+]'
    throw 'can only use registers [a-z"*+]'
  endif

  let sel_save = &selection
  let &selection = 'inclusive'

  let l:unnamed = @"
  let l:reg_save = getreg(l:reg)
  let l:reg_type = getregtype(l:reg)

  if a:0
    let l:cmd = 'normal! gv"'
  elseif a:type == 'line'
    let l:cmd = "normal! '[V']\""
  else
    let l:cmd = "normal! `[v`]\""
  endif

  silent exe l:cmd..l:reg.."d"

  " store the new line
  let l:new = getreg(l:reg)

  " put old line in register and paste
  call setreg(l:reg, l:reg_save, l:reg_type)
  silent exe "normal! \""..l:reg.."p"
  " put new line in register
  call setreg(l:reg, l:new, l:reg_type)

  if l:reg != '"'
    " reset unnamed register to last user command
    " if user specified a register
    let @" = l:unnamed
  endif

  let &selection = sel_save
endfun

" -- SUBSTITUTE ----------------------------------------------------------- {{{1

fun! op#Substitute(type, ...)
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


" -- SHIFT ---------------------------------------------------------------- {{{1

fun! op#Shift(direction, count) "{{{2
  let s:shift_direction = a:direction
  let s:shift_count = a:count
  let &opfunc = s:sid('Shift')
endfun

fun! s:Shift(type) "{{{2
  if a:type == 'line'
    exe "normal! '[v']"..s:count1(s:shift_count)..s:shift_direction
  else
    exe "normal! `[v`]"..s:count1(s:shift_count)..s:shift_direction
  endif
endfun

" -- UTIL ----------------------------------------------------------------- {{{1

fun! op#Expr(func) "{{{2
  " must do it this way to provide register
  let &opfunc = a:func =~ '#' ? a:func : s:sid(a:func)
  return 'g@'
endfun

fun! s:sid(func) "{{{2
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')..a:func
endfun

fun! s:count1(count) "{{{2
  return a:count == 0 ? 1 : a:count
endfun

fun! s:savereg(...) "{{{2
  let s:registers = {}
  for l:reg in range(9) + a:000
    let s:registers[l:reg] = [getreg(l:reg), getregtype(l:reg)]
  endfor
endfun

fun! s:restorereg() "{{{2
  for [reg, pair] in items(get(s:, 'registers', {}))
    call setreg(reg, pair[0], pair[1])
  endfor
endfun

