if has('patch-8.1.1116')
  scriptversion 3
endif

fun! toggle#(dict, key) "{{{1
  let a:dict[a:key] = !get(a:dict, a:key)
endfun

fun! toggle#SetLocal(setting, default, alt) "{{{1
  exe printf('setlocal %s=%s',
        \    a:setting,
        \    eval('&'..a:setting) == a:default ? a:alt : a:default)
endfun
command! -nargs=+ ToggleSetLocal call toggle#SetLocal(<args>)

fun! toggle#Conceal() "{{{1
  if &conceallevel
    setlocal conceallevel=0
  else
    setlocal conceallevel<
  endif
endfun

fun! toggle#Profiling(...) abort "{{{1
  if has_key(s:, 'profiling')
    profile pause
    echo "quit and read "..s:profiling
  else
    let s:profiling = a:0 && !empty(a:1) ? a:1 : '/tmp/vim_profiling'
    exe ":profile start "..s:profiling
    profile func *
    profile file *
  endif
endfun

fun! toggle#Cursorlines(n) abort "{{{1
  let w:cursorlines = (get(w:, 'cursorlines', 0) + a:n) % 4
  exe ':set '..(and(w:cursorlines, 1) ? '' : 'no')..'cursorcolumn'
  exe ':set '..(and(w:cursorlines, 2) ? '' : 'no')..'cursorline'
endfun

fun! toggle#Comments(...) "{{{1
  exe 'silent '..(a:1 ? "'<,'>" : "'[,']")..' normal gcc'
endfun

fun! toggle#LocList() " {{{1
  if !len(getloclist(0))
    return
  endif

  " find if open by positive winnr
  for l:bufnr in map(filter(split(execute('silent! ls!'),
                 \               '\n'),
                 \         'v:val =~# "Location List"'),
                 \  'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(l:bufnr) != -1
      lclose
      return
    endif
  endfor

  " open and stay in current window
  let l:winnr = winnr()
  lopen
  if winnr() != l:winnr
    wincmd p
  endif
endfun

fun! toggle#Gdiff() abort "{{{1
  let l:did_close = v:false

  if exists('s:gdiff_file')
    for l:buf in getbufinfo({ 'listed': 1 })
      if l:buf.name == s:gdiff_file
        exe 'bdelete '..l:buf.bufnr
        let l:did_close = v:true
        break
      endif
    endfor

    unlet! s:gdiff_file
    if l:did_close
      return
    endif
  endif

  Gdiff!

  for l:buf in getbufinfo({ 'listed': 1 })
    if (match(l:buf.name, '^fugitive.*'..expand('%')..'$') == 0)
      let s:gdiff_file = l:buf.name
    endif
  endfor
endfun

fun! toggle#PreviewHunk() abort "{{{1
  let l:current_hunk = []
  let l:bufnr = bufnr('')

  for l:hunk in gitgutter#hunk#hunks(l:bufnr)
    if gitgutter#hunk#cursor_in_hunk(l:hunk)
      let current_hunk = l:hunk
      break
    endif
  endfor

  if exists('s:viewed_hunk')
    if empty(l:current_hunk) || l:current_hunk == s:viewed_hunk
      unlet! s:viewed_hunk
      pclose
      return
    endif
  endif

  if empty(l:current_hunk)
    return
  endif

  let s:viewed_hunk = l:current_hunk
  GitGutterPreviewHunk
endfun


