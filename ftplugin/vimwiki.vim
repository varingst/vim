nnoremap <silent><buffer><CR> :VimwikiFollowLink<CR>
nnoremap <silent><buffer><expr><S-CR> ":Vimwiki".(winwidth('.') > 140 ? 'V' : '')."SplitLink reuse move_cursor\<CR>"
nnoremap <silent><buffer><expr><C-CR> ":Vimwiki".(winwidth('.') > 140 ? 'V' : '')."SplitLink\<CR>"
nnoremap <silent><buffer><Backspace> :VimwikiGoBackLink<CR>

nnoremap <silent><buffer><Tab> :VimwikiNextLink<CR>
nnoremap <silent><buffer><S-Tab> :VimwikiPrevLink<CR>

nmap <silent><buffer>[[ <Plug>VimwikiGoToPrevHeader
nmap <silent><buffer>]] <Plug>VimwikiGoToNextHeader
nmap <silent><buffer>[= <Plug>VimwikiGoToPrevSiblingHeader
nmap <silent><buffer>]= <Plug>VimwikiGoToNextSiblingHeader

nnoremap <silent><buffer><C-@> :VimwikiToggleListItem<CR>

imap <silent><buffer><C-T> <Plug>VimwikiIncreaseLvlSingleItem
imap <silent><buffer><C-D> <Plug>VimwikiDecreaseLvlSingleItem

inoremap <silent><buffer><CR> <C-]><Esc>:VimwikiReturn 3 5<CR>
inoremap <silent><buffer><S-CR> <C-]><Esc>:VimwikiReturn 2 2<CR>

inoremap <silent><buffer><C-R>! <C-R>="- [ ] "<CR>

command! -range=% TodoSort call setline(<line1>, s:TodoSort(<line1>,<line2>))

fun! s:TodoSort(line1, line2)
  let line1 = a:line1

  let stack = [{ 'children': [], 'trailing': [] }]
  let out = []
  let previndent = 0

  let order = get(g:, 'vimwiki_listsyms', ' .oOX')
  let Match = { line -> matchlist(line, '^\s*- \[\(.\)\] ') }

  fun! s:Compare(a, b) closure
    let a = Match(a:a.line)
    let b = Match(a:b.line)
    return a[1] == b[1]
          \? a:a.lnum - a:b.lnum
          \: stridx(order, a[1]) - stridx(order, b[1])
  endfun

  fun! s:Pop(n) closure
    return map(remove(stack, -a:n, -1), { _, e -> sort(e.children, 's:Compare') })[0]
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
      call s:Pop((previndent - indent) / shiftwidth())
    endif

    call add(stack[-1].children, {
          \ 'line': getline(lnum),
          \ 'lnum': lnum,
          \ 'children': [],
          \ 'trailing': [],
          \})
    let previndent = indent
  endfor

  return s:Flatten(s:Pop(len(stack)), out)
endfun

fun! s:Flatten(lines, ...)
  let out = a:0 ? a:1 : []
  for line in a:lines
    call add(out, line.line)
    call extend(out, line.trailing)
    call s:Flatten(line.children, out)
  endfor
  return out
endfun
