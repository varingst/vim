if has('patch-8.1.1116')
  scriptversion 3
endif

fun! f#Fold(list, F, ...) abort "{{{1
  if empty(a:list)
    throw "thou can'st not fold that which is empty"
  endif

  if a:0
    let acc = a:1
    let i = 0
  else
    let acc = a:list[0]
    let i = 1
  endif

  while i < len(a:list)
    let acc = a:F(acc, a:list[i])
    let i += 1
  endwhile

  return acc
endfun

fun! f#Accumulate(list, acc, F) abort "{{{1
  for e in a:list
    call a:F(a:acc, e)
  endfor

  return a:acc
endfun

fun! f#ReplaceEach(pattern) abort "{{{1
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

fun! f#SwapWindow(target) "{{{1
  let current = winnr()
  if current == a:target || index(range(1, winnr('$')), a:target) == -1
    return
  endif
  let bufnr = winbufnr(current)
  exe 'buffer '..winbufnr(a:target)
  exe a:target..'wincmd w'
  exe 'buffer '..bufnr
endfun

" f#HumanDay() {{{1

let s:days = [ 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' ]
fun! f#HumanDay(date)
  if empty(a:date)
    return
  endif

  let [l:this_year, l:this_week, l:this_day, l:date_year, l:date_week, l:date_day] =
        \ map(split(system('date "+%Y %V %w"; date --date="'..a:date..'" "+%Y +%V %w"')),
        \     {_, n -> str2nr(n)})
  if l:this_year == l:date_year
    let l:week_delta = l:this_week - l:date_week
    let l:day_delta = l:this_day - l:date_day
    if l:week_delta == 0
      if l:day_delta == 0
        let l:msg = 'Today'
      else
        let l:msg = (l:day_delta > 0 ? 'Last' : 'Next')..' '..s:days[l:date_day]
      endif
    elseif abs(l:week_delta) == 1
      let l:msg = s:days[l:date_day]..' '..(l:week_delta > 0 ? 'last' : 'next')..' week'
    else
      let l:msg = s:days[l:date_day]..' '..(
            \ l:week_delta > 0
            \ ? l:week_delta..' weeks ago'
            \ : 'in '..abs(l:week_delta)..' weeks')
    endif
  else
    return "there's still work to be done"
  endif
  return l:msg
endfun

fun! f#AutoloadPrefix() "{{{1
  let l:path = split(expand((a:0 ? a:1 : '%:p')..':r'), '/')
  let l:root = max(map(['autoload', 'plugin'], { _,v -> index(l:path, v) }))
  if l:root == -1
    return ''
  endif
  return join(l:path[l:root+1:], '#')..'#'
endfun

fun! f#LastChange(cmd) "{{{1
  let l:pos = getpos('.')
  let l:line_length = len(getline(l:pos[1]))
  exe 'normal! '.a:cmd
  let l:change_pos = getpos('.')
  if l:pos[1] == l:change_pos[1]
    let l:pos[2] += l:line_length - len(getline(l:pos[1]))
  endif
  call setpos('.', l:pos)
  return ''
endfun

fun! f#TagBarSearch() " {{{1
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
