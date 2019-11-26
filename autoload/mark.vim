let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

let g:vim_func_pattern = 'fun\(ction\)\?!\?\s\+\zs\(\w\+#\)*\w\+'
" let g:vim_func_extract = '\([^#]\+$\|[^#]\+\ze\#\)'
let g:vim_func_extract = '[^#]\+$'

fun! mark#ParseFunc(pattern, lnum, string)
  let [func, idx, _] = matchstrpos(a:string, a:pattern)
  return {
        \ 'func': func,
        \ 'pos': [a:lnum, idx + 1, 0]
        \}
endfun

fun! mark#GetFuncInLine(pattern)
  return mark#ParseFunc(a:pattern, line('.'), getline('.'))
endfun

fun! mark#CollectFunctions(pattern)
  let pos = getcurpos()
  let acc = []
  let Acc = { -> add(acc, mark#GetFuncInLine(a:pattern)) }
  exe 'global/'..a:pattern..'/call Acc()'
  call setpos('.', pos)

  return acc
endfun

fun! mark#ExtractCandidates(func, pattern)
  let rtn = ''
  for char in split(tolower(matchstr(a:func, a:pattern)), '\zs')
    if stridx(rtn, char) == -1
      let rtn ..= char
    endif
  endfor
  return rtn
endfun

fun! mark#AssignFunctionMarks(patterns, ...)
  let funcs = map(mark#CollectFunctions(a:patterns.find),
        \         { _, func -> extend(func, {
        \                      'candidates': mark#ExtractCandidates(func.func, a:patterns.extract) })})
  let assigned = a:0 ? a:1 : ''
  for func in sort(funcs, { a, b -> strlen(a.candidates) - strlen(b.candidates) })
    let i = 0
    for char in split(func.candidates, '\zs')
      if stridx(assigned, char) == -1
        let assigned ..= char
        let func.mark = char
        break
      endif
    endfor
  endfor
  return funcs
endfun

fun! mark#SetFunctionMarks(...)
  let funcs = call('mark#AssignFunctionMarks', a:000)
  for func in funcs
    if has_key(func, 'mark')
      call setpos("'"..func.mark, func.pos)
    endif
  endfor
  return funcs
endfun

fun! mark#Test()
  let b:marks = mark#SetFunctionMarks({
        \ 'find': g:vim_func_pattern,
        \ 'extract': g:vim_func_extract,
        \})
endfun

fun! mark#TestPopup()
  let g:result = {}
  let dict = {}
  call map(copy(b:marks), { _, d -> extend(dict, { d.mark: d.func })})
  let dict.order = map(copy(b:marks), { _, d -> d.mark})
  call popup#selector(dict, { _, result -> cursor(b:marks[result.idx].pos) })
endfun

let &cpo = s:save_cpo
