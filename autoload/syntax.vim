if has('patch-8.1.1116')
  scriptversion 3
endif

" == PropString =========================================================== {{{1
let s:prop_start_col_offset = 1
let s:prop_end_col_offset = 2

fun! syntax#PropString(lnum, ...) "{{{2
  let l:start = get(a:000, 0, 0)
  let l:end = get(a:000, 1, -1)
  let l:text = getline(a:lnum)

  let l:end = l:end < 0 ? len(l:text) + l:end : min([l:end, len(l:text)-1])

  if type(l:start) is v:t_string
    let [l:text, l:start, l:end] = matchstrpos(l:text, l:start)
    let l:end -= 1
  else
    let l:text = l:text[l:start:l:end]
  endif

  let l:rtn = {
        \ 'text': l:text,
        \ 'props': [],
        \ 'append': function('s:append'),
        \ 'prepend': function('s:prepend'),
        \ 'trans': function('s:trans'),
        \ 'untrans': function('s:untrans'),
        \ 'ensure_highlight': function('s:ensure_highlight'),
        \}
  let l:len = len(l:rtn.text)

  let l:col = l:start + s:prop_start_col_offset
  let l:item = { 'id': synID(a:lnum, l:col, v:false), 'col': l:col - l:start}

  while l:col <= l:end + s:prop_end_col_offset
    let l:id = synID(a:lnum, l:col, v:false)
    if l:id != l:item.id || l:col == (l:end + s:prop_end_col_offset)
      let l:item.end_col = l:col - l:start
      if l:item.id
        call add(l:rtn.props, extend(l:item, {
              \ 'highlight': synIDattr(l:item.id, 'name'),
              \ 'string': l:rtn.text[
              \   (l:item.col - s:prop_start_col_offset):
              \   (l:item.end_col - s:prop_end_col_offset)
              \ ],
              \}))
      endif
      let l:item = { 'col': l:col - l:start, 'id': l:id }
    endif
    let l:col += 1
  endwhile

  return l:rtn
endfun

fun! s:append(propstr) dict "{{{2
  let l:len = len(self.text)
  let l:start = len(self.props)
  let self.text ..= a:propstr.text
  let self.props += a:propstr.props

  for l:i in range(l:start, len(self.props)-1)
    let self.props[l:i].col += l:len
    let self.props[l:i].end_col += l:len
  endfor

  return self
endfun

fun! s:prepend(propstr) dict "{{{2
  let self.text = a:propstr.text .. self.text
  let self.props = a:propstr.props + self.props

  for l:i in range(len(a:propstr.props), len(self.props) - 1)
    let self.props[l:i].col += len(a:propstr.text)
    let self.props[l:i].end_col += len(a:propstr.text)
  endfor

  return self
endfun

fun! s:trans() dict "{{{2
  for prop in self.props
    let prop.untrans = prop.id
    let prop.id = synIDtrans(prop.untrans)
    let prop.highlight = synIDattr(prop.id, 'name')
  endfor

  return self
endfun

fun! s:untrans() dict "{{{2
  for prop in self.props
    let prop.id = get(prop, 'untrans', prop.id)
    let prop.highlight = synIDattr(prop.id, 'name')
  endfor

  return self
endfun

fun! s:ensure_highlight() dict "{{{2
  for l:prop in self.props
    let l:name = 'syntax#'..l:prop.highlight
    if empty(prop_type_get(l:name))
      call prop_type_add(l:name, { 'highlight': l:prop.highlight })
    endif
    let l:prop.type = l:name
  endfor

  return self
endfun

fun! syntax#Stack(...) "{{{1
  let l:line = get(a:000, 0, line('.'))
  let l:col = get(a:000, 1, col('.'))
  return map(synstack(l:line, l:col), { _, v -> synIDattr(v, 'name')})
endfun
