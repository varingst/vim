let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! win#Swap(target)
  let current = winnr()
  if current == a:target || index(range(1, winnr('$')), a:target) == -1
    return
  endif
  let bufnr = winbufnr(current)
  exe 'buffer '..winbufnr(a:target)
  exe a:target..'wincmd w'
  exe 'buffer '..bufnr
endfun

fun! win#Zoom(target)
  try
    exe a:target..'wincmd w'
  catch /^Vim\((\a\+)\)\=:E16:/
    return
  endtry

  if !exists('w:zoomed')
    let w:zoomed = filter(getwininfo(), 'v:val.tabnr == '..tabpagenr()..' && v:val.height && v:val.width')
    resize 999
    vertical resize 999
  else
    try
      for w in w:zoomed
        call win_execute(w.winid, printf('resize %d | vertical resize %d', w.height, w.width))
      endfor
      unlet w:zoomed
    catch /^Vim\((\a\+)\)\=:E116:/
      throw w.winid..v:exception
    endtry
  endif
endfun

fun! win#V()
  return winwidth('.') > get(g:, 'winsplit_threshold', 140)
endfun

let &cpo = s:save_cpo

command! -range=% TodoSort call setline(<line1>, TodoSort(<line1>,<line2>))

fun! TodoSort(line1, line2)
  let line1 = a:line1

  let stack = [{'children': [], 'trailing': []}]
  let out = []
  let previndent = 0

  let order = get(g:, 'vimwiki_listsyms', ' .oOX')
  let Match = { line -> matchlist(line, '^\s*- \[\(.\)\] ') }

  fun! Compare(a, b) closure
    let a = Match(a:a.line)
    let b = Match(a:b.line)
    return a[1] == b[1]
          \? a:a.lnum - a:b.lnum
          \: stridx(order, a[1]) - stridx(order, b[1])
  endfun

  fun! Pop(n) closure
    return map(remove(stack, -a:n, -1), { _, e -> sort(e.children, 'Compare') })[0]
  endfun

  while empty(Match(getline(line1)))
    call add(out, getline(line1))
    let line1 += 1
  endwhile

  for lnum in range(line1, a:line2)
    let line = getline(lnum)
    if empty(Match(line))
      call add(stack[-1].children[-1].trailing, line)
      continue
    endif

    let indent = indent(lnum)
    if indent > previndent
      call add(stack, stack[-1].children[-1])
    elseif indent < previndent
      call Pop((previndent - indent) / shiftwidth())
    endif

    call add(stack[-1].children, {
          \ 'line': getline(lnum),
          \ 'lnum': lnum,
          \ 'children': [],
          \ 'trailing': [],
          \})
    let previndent = indent
  endfor

  fun! Flatten(lines, ...)
    let out = a:0 ? a:1 : []
    for line in a:lines
      call add(out, line.line)
      call extend(out, line.trailing)
      call Flatten(line.children, out)
    endfor
    return out
  endfun

  return Flatten(Pop(len(stack)), out)
endfun
