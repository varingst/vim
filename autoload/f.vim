if has('patch-8.1.1116')
  scriptversion 3
endif

fun! f#ReplaceEach(pattern) abort
  let pattern = strlen(a:pattern) ? a:pattern : '{\w*}'
  let template = getline('.')
  let to_replace = []
  let stl_save = &statusline
  call substitute(template, pattern, '\=add(to_replace, submatch(0))', 'g')
  if empty(to_replace)
    return
  endif
  let to_replace = filter(copy(to_replace), { idx, pat -> index(to_replace, pat) == idx })
  while v:true
    if !has('nvim')
      " vim redraw bug workaround
      set statusline=
    endif

    for pattern in to_replace
      let replacement = s:input('s/'..pattern..'/', '')
      if !strlen(replacement)
        normal! "_dd
        if !has('nvim')
          let &statusline = stl_save
        endif
        return
      endif
      call setline('.', substitute(getline('.'), pattern, replacement, 'g'))
      redraw
    endfor
    call append('.', template)
    normal! j
    redraw
  endwhile
endfun

fun! f#AutoloadPrefix()
  let l:path = split(expand((a:0 ? a:1 : '%:p')..':r'), '/')
  let l:root = max(map(['autoload', 'plugin'], { _,v -> index(l:path, v) }))
  if l:root == -1
    return ''
  endif
  return join(l:path[l:root+1:], '#')..'#'
endfun

fun! f#TagBarSearch()
  if bufwinnr('__Tagbar__') == -1
    TagbarOpen
  endif
  exe bufwinnr('__Tagbar__')..'wincmd w'
  1
  call feedkeys('/', 't')
endfun

fun! s:input(...)
  call inputsave()
  let input = call('input', a:000)
  call inputrestore()
  return input
endfun

if get(g:, 'f_TESTING')
  fun! s:input(...)
    return remove(g:f_TESTING_input, 0)
  endfun
endif
