if has('patch-8.1.1116')
  scriptversion 3
endif

" -- Function ------------------------------------------------------------- {{{1

fun! popup#FuncName()
  let col_offset = mode() == 'i' ? -1 : 0
  if s:CurChar(col_offset) == ')'
    let pos_close = map(getcurpos(), { i, v -> i == 2 ? v + col_offset : v })
    let [lnum, col] = s:PairPos(pos_close, '(', '', ')', 'bWn')
    let col_open = matchstrpos(getline(lnum)[:col-1], '\<\k\{-}($')[1] + 1

    if get(screenpos(0, lnum, col_open), 'col', 1)
      " visible on screen
      return
    endif

    let propstr = syntax#PropString(lnum, col_open - 1, col - 1)

    if empty(propstr.text)
      return
    endif

    call s:popup_atcursor([propstr.trans().ensure_highlight()], s:funcname_opt)
  endif
endfun
hi PopupFuncName ctermbg=236

fun! s:PairPos(start_pos, open, mid, close, flags)
  let now = getcurpos()
  call setpos('.', a:start_pos)
  let synid = get(synstack(a:start_pos[1], a:start_pos[2]), -1, 0)
  let pairpos = searchpairpos(a:open, a:mid, a:close, a:flags,
        \                       'get(synstack(line("."), col(".")), -1, 0) != '..synid)
  call setpos('.', now)
  return pairpos
endfun

fun! s:CurChar(...)
  return getline('.')[col('.') - 1 + (a:0 ? a:1 : 0)]
endfun

let s:funcname_opt = {
      \ 'line': 'cursor',
      \ 'col': 'cursor+2',
      \ 'moved': 'any',
      \ 'highlight': 'PopupFuncname'
      \}

" -- HumanDay ------------------------------------------------------------- {{{1

fun! popup#HumanDay(date)
  let human = s:HumanDay(a:date)
  if !empty(human)
    call s:popup_atcursor(human)
  endif
endfun

let s:humandays = [ '', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday' ]

fun! s:HumanDay(date)
  if empty(a:date)
    return ''
  endif

  let now = get(g:, 'autoload_popup_TESTING_now', 'now')


  let [this_year, this_week, this_day, date_year, date_week, date_day] =
        \ map(split(system('date --date="'..now..'" "+%Y %V %u"; date --date="'..a:date..'" "+%Y %V %u"')),
        \     {_, n -> str2nr(n)})
  if this_year == date_year
    let week_delta = this_week - date_week
    let day_delta = this_day - date_day
    if week_delta == 0
      if day_delta == 0
        let msg = 'Today'
      elseif day_delta == -1
        let msg = 'Tomorrow'
      elseif day_delta == 1
        let msg = 'Yesterday'
      else
        let msg = (day_delta > 0 ? 'Last' : 'Next')..' '..s:humandays[date_day]
      endif
    elseif abs(week_delta) == 1
      let msg = s:humandays[date_day]..' '..(week_delta > 0 ? 'last' : 'next')..' week'
    else
      let msg = s:humandays[date_day]..' '..(
            \ week_delta > 0
            \ ? week_delta..' weeks ago'
            \ : 'in '..abs(week_delta)..' weeks')
    endif
  else
    return "there's still work to be done"
  endif
  return msg
endfun

" -- FunctionTags -- {{{1

fun! popup#Tags(...)
  let results = map(call('tag#TagsInFile', a:000),
          \                 { _, tag -> extend(tag, { 'display': tag.name })})
  if empty(results)
    return
  elseif len(results) == 1
    return s:handle_tag(results[0])
  else
    call popup#selector(results,
          \             funcref('s:handle_tag'))
  endif
endfun

fun! s:handle_tag(tag)
  if !empty(a:tag)
    exe 'tag '..a:tag.name
  endif
endfun

" -- Handle open popups --------------------------------------------------- {{{1

fun! popup#GetShowing() abort
  let winids = []
  for buf in getbufinfo()
    if !empty(buf.popups)
      call extend(winids, buf.popups)
    endif
  endfor
  return uniq(sort(winids))
endfun

fun! popup#Flip() abort
  let line = winline()

  for popid in popup#GetShowing()
    let pos = popup_getpos(popid)
    if !pos.visible
      return
    endif

    call popup_move(popid, pos.line <= line
          \                ? { 'line': 'cursor+1', 'pos': 'botleft' }
          \                : { 'line': 'cursor-1', 'pos': 'topleft' })
  endfor
endfun

" -- Test --

fun! s:echo(id, result)
  echo a:result
endfun

fun! popup#Jumps()
  let [jumps, pos] = getjumplist()
  let lines = map(reverse(jumps),
        \                 { _, pos -> get(getbufline(pos.bufnr, pos.lnum), 0, '') })
  call insert(lines, '>', len(lines) - pos)
  return s:popup_selector(lines,
        \                 { 'callback': s:JumpHandler(len(lines) - pos) })
endfun

fun! s:JumpHandler(pos)
  fun! s:jh(id, result) closure
    echo a:result
  endfun
  return funcref('s:jh')
endfun

" -- Util ----------------------------------------------------------------- {{{1

fun! s:popup_atcursor(what, options)
  return popup_atcursor(a:what, a:options)
endfun

fun! s:popup_create(what, options)
  return popup_create(a:what, a:options)
endfun

fun! s:popup_dialog(what, options)
  return popup_dialog(a:what, a:options)
endfun

fun! s:popup_menu(what, options)
  return popup_menu(a:what, a:options)
endfun

fun! popup#selector(what, ...) abort
  if empty(a:what)
    return
  endif

  let t_opt = type(a:0 ? a:1 : {})
  if t_opt is v:t_func
    let options = { 'callback': a:1 }
  elseif t_opt is v:t_string
    let options = { 'callback': funcref(a:1) }
  elseif t_opt isnot v:t_dict
    throw "invalid option, can only handle dict, string and funcref"
  else
    let options = a:0 ? a:1 : {}
  endif

  let t_what = type(a:what)

  if t_what is v:t_dict
    let [what, options.keys] = s:dict_to_selectorlist(a:what)
  elseif t_what is v:t_number
    throw 'cannot handle bufnr'
  elseif t_what is v:t_list
    if type(a:what[0]) is v:t_dict
      let what = map(deepcopy(a:what),
            \        { _, e -> type(e) is v:t_dict && has_key(e, 'display')
            \                  ? e.display
            \                  : string(e)})
    else
      let what = map(deepcopy(a:what),
            \        { _, e -> type(e) is v:t_string
            \        ? e
            \        : string(e)})
    endif
  endif

  let Callback = get(options, 'callback', { result -> result })
  let options.callback = { _, result
        \ ->Callback(result.idx == -1
        \            ? ''
        \            : a:what[t_what is v:t_dict ? result.key : result.idx])}

  let options.keys = get(options, 'keys', 'fjdksla;ghrueiwoqptyvmc,x.z/bn')

  return s:popup_selector(what, options)
endfun

fun! s:dict_to_selectorlist(what) abort
   let order = has_key(a:what, 'order')
         \   ? remove(a:what, 'order')
         \   : sort(keys(a:what))
    let what = []
    let keys = ''
    for key in type(order) is v:t_string ? split(order, '\zs') : order
      if has_key(a:what, key[0])
        call add(what, a:what[key[0]])
        let keys ..= key[0]
      endif
    endfor

    return [what, keys]
endfun

fun! s:popup_selector(what, options) abort
  return s:popup_menu(map(copy(a:what), { i, line -> printf('%s %s', a:options.keys[i], line)}),
        \             extend(extend({
        \             }, a:options), {
        \               'mapping': v:false,
        \               'filter': s:selector_filter(a:what, a:options.keys)
        \             }))
endfun

fun! s:selector_filter(what, keys) abort
  fun! s:filter(winid, key) closure abort
    let sel = match(a:keys, a:key)
    if sel > -1 && sel < len(a:what)
      call popup_close(a:winid, { 'idx': sel, 'key': a:keys[sel], 'sel': a:what[sel] })
      return 1
    elseif a:key == "\<ESC>"
      call popup_close(a:winid, { 'idx': -1 })
    endif
    " eat all keys
    return 1
  endfun

  return funcref('s:filter')
endfun

let s:box = g:sym.box
let s:selector = {
      \}

fun! s:selector.viewlines()
  let i = 0
  let lines = []
  let candidates = self.filtered()
  while i < self.viewheight && i < len(candidates)
    " TODO: fix support for several fields
    call add(lines, printf('%s %s', self.keys[i], candidates[self.viewpos + i][0]))
    let i += 1
  endwhile
  call add(lines, self.statusline())
  return lines
endfun

fun! s:selector.scroll(delta)
  let self.viewpos += a:delta
  if self.viewpos < 0
    let self.viewpos = 0
  elseif self.viewpos > self.lastpagepos
    let self.viewpos = self.lastpagepos
  endif
endfun

fun! s:selector.statusline()
  if self.len > self.viewheight
    if self.len == self.maxlen
      let page = printf('%d-%d/%d', self.viewpos + 1, self.viewpos + self.viewheight, self.len)
    else
      let page = printf('%d-%d/%d (%d)', self.viewpos + 1, self.viewpos + self.viewheight, self.len, self.maxlen)
    endif
  else
    let page = ''
  endif

  let stl = printf(' %s%s %%s %s ',
        \ self.state == 'filter' ? '> ' : '',
        \ self.filter,
        \ page)
  return printf(stl, repeat(' ', 3 + self.minwidth - strdisplaywidth(stl)))
endfun

let s:pingchar = [128, 253, 96]

fun! s:selector.handlekey(winid, key)
  if a:key == "\<ESC>"
    call popup_close(a:winid, -1)
  endif

  if self.state == 'select'
    if a:key == "\<CR>"
    elseif a:key == "\<Up>"
      call self.scroll(-self.viewheight)
    elseif a:key == "\<Down>"
      call self.scroll(self.viewheight)
    elseif a:key == '/'
      let self.state = 'filter'
      let self.viewpos = 0
    endif
  elseif self.state == 'filter'
    if a:key == "\<CursorHold>"
      :
    elseif a:key == "\<CR>"
      let self.state = 'select'
    elseif a:key == "\<BS>"
      let self.filter = self.filter[:-2]
    elseif a:key == "\<C-W>"
      let self.filter = substitute(self.filter, '\V\s*\w\+\$', '', '')
    elseif a:key == "\<C-U>"
      let self.filter = ''
    else
      let self.filter ..= a:key
    endif
  endif

  call popup_settext(a:winid, self.viewlines())
  return 1
endfun

fun! s:selector.show()
  let self.winid = popup_create(self.viewlines(), {
        \ 'maxheight': self.viewheight + 1,
        \ 'minwidth': self.minwidth,
        \ 'moved': 'WORD',
        \ 'border': [1,1,1,1],
        \ 'borderchars': s:box,
        \ 'filter': function(self.handlekey),
        \ 'mapping': v:false,
        \})
endfun

fun! s:selector.filtered()
  if empty(self.filter)
    return self.candidates
  endif

  if !has_key(self.filtercache, self.filter)
    let idx = self.filterfield
    let filter = self.filter
    let candidates = copy(empty(self.lastfilter)
                 \ ? self.candidates
                 \ : self.filtercache[self.lastfilter])
    if filter[-1:-1] == '\'
      let self.filtercache[self.filter] = candidates
    else
      try
        let self.filtercache[self.filter] = filter(candidates,
                  \                                { _, cand -> cand[idx] =~ filter })
      catch
        " regex errors, like partial atoms and multis
        let self.filtercache[self.filter] = candidates
      endtry
    endif
  endif
  let self.len = len(self.filtercache[self.filter])
  return self.filtercache[self.filter]
endfun

fun! s:Selector(what, opt)
  " TODO: calculate width for all fields
  call extend(s:selector, {
      \ 'candidates': a:what,
      \ 'state': 'select',
      \ 'filtercache': {},
      \ 'filterfield': 0,
      \ 'len': len(a:what),
      \ 'maxlen': len(a:what),
      \ 'keys': a:opt.keys,
      \ 'filter': '',
      \ 'lastfilter': '',
      \ 'minwidth': 15,
      \ 'viewheight': min([len(a:opt.keys), len(a:what)]),
      \ 'viewpos': 0,
      \ 'width': max(map(copy(a:what), 'strdisplaywidth(v:val[0])')),
      \})

  let s:selector.lastpagepos = s:selector.len - s:selector.viewheight

  return s:selector
endfun

fun! Test()
  let lines = ['foo']
  let pingchar = join(map([128,253,96], 'nr2char(v:val)'), '')

  fun! Filter(winid, key) closure
    if a:key == "\<ESC>"
      call popup_close(a:winid, -1)
    endif
    if a:key == pingchar
      return 1
    endif
    if a:key == "\<BS>"
      let lines = lines[:-2]
    else
      call add(lines, printf('%d %s', strlen(a:key), join(map(split(a:key, '\zs'), 'char2nr(v:val)'), '|')))
    endif
    call popup_settext(a:winid, lines)
    return 1
  endfun

  call popup_create(lines, {
        \ 'filter': function('Filter'),
        \ 'mapping': v:false,
        \})
endfun


" -- Test ----------------------------------------------------------------- {{{1

if get(g:, 'autoload_popup_TESTING')
  fun! s:popup_atcursor(...)
    let g:popup_args = a:000
  endfun

  fun! s:popup_menu(...)
    let g:popup_args = a:000
  endfun

  fun! Sel()
    return s:Selector([
          \['one'],
          \['two'],
          \['three'],
          \['four'],
          \['five'],
          \['six'],
          \['seven'],
          \['eight'],
          \['nine'],
          \['ten'],
          \['eleven'],
          \['twelve'],
          \['thirteen'],
          \['fourteen'],
          \['fifteen'],
          \['sixteen'],
          \['seventeen'],
          \['eighteen'],
          \['nineteen'],
          \['twenty'],
          \['twentyone'],
          \['twentytwo'],
          \], { 'keys': split("1234567890", '\zs') })
  endfun

  fun! SelHeavy()
    return s:Selector(map(readfile('/usr/share/dict/words'), { _, w -> [w] }),
          \ { 'keys': split("1234567890", '\zs') })
  endfun
endif
