let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

" == INIT ================================================================= {{{1

let s:sym = get(g:, 'sym', {})

augroup statusline
  au!
  if has('nvim')
    au TermOpen * let &l:statusline = stl#terminal()
  else
    au TerminalWinOpen * let &l:statusline = stl#terminal()
  endif
  au User Fugitive call s:git.update()
  au User ALELintPost call s:ale.update()
  au FileType,EncodingChanged * call s:filetype.update(str2nr(expand('<abuf>')))
  au FileType qf let b:undo_ftplugin = "set stl<"
        \      | let &l:statusline = stl#quickfix()
  au QuickFixCmdPost * call s:status.set_qf()
augroup END

" == PUBLIC =============================================================== {{{1

fun! stl#update(state, ...)
  let state = get(s:, a:state)
  return call(get(state, 'update'), a:000, get(s:, a:state))
endfun

fun! stl#ctrlg()
  echohl STLCtrlG

  let pos = getcurpos()
  if v:hlsearch
    echo trim(execute('keepjumps %s///n'))
    call setpos('.', pos)
  else
    let funcstart = &filetype == 'vim'
          \ ? searchpair('\v^\s*fu%[nction]!?>', '', '\v^\s*endf%[unction]>', 'bWn')
          \ : 0
    echo printf('%d/%d%s%s %d/%d%s : %s',
          \ pos[1], line('$'), get(s:sym, 'line', 'L'),
          \ funcstart ? printf(' (%d 関数)', pos[1] - funcstart) : '',
          \ pos[2], col('$'), get(s:sym, 'column', 'C'),
          \ join(split(execute('ascii'), "\n")))
  endif
  echohl None
endfun

fun! stl#mru_bufnr(idx)
  return s:mru.bufnr(a:idx)
endfun

fun! stl#mru_exe_bufnr(cmd, idx)
  let bufnr = s:mru.bufnr(a:idx)
  if !bufnr
    return
  endif
  exe printf(a:cmd, bufnr)
endfun

fun! stl#mru_exe_bufname(cmd, idx)
  let bufnr = s:mru.bufnr(a:idx)
  if !bufnr
    return
  endif
  exe printf(a:cmd, bufname(bufnr))
endfun

" == STATUSLINES ========================================================== {{{1

fun! stl#statusline()
  return join(s:flatten([
        \ '%{stl#update("bufstate")}',
        \ s:win.stl(),
        \ s:mode.stl(),
        \ '%#StatusLine#',
        \ ' ',
        \ s:bufstate.stl(),
        \ '%<',
        \ '%=',
        \ '%#StatusLine#',
        \ s:filetype.stl(),
        \ s:ale.stl(),
        \]), '')
endfun

" evaluated with %!
fun! stl#tabline()
  return join(s:flatten([
        \ '%#STLServerName#%( %{v:servername} %)',
        \ s:tabindex.stl(),
        \ s:status.stl(),
        \ s:git.stl(),
        \ '%#TabLineFill#',
        \ '%-(',
        \ s:mru.stl(),
        \ '%)',
        \ '%<',
        \]), '')
endfun

fun! stl#quickfix()
  let winid = win_getid()
  let wininfo = getwininfo(winid)[0]
  return join(s:flatten([
            \ s:win.stl(),
            \ '%<',
            \ '%#STLQFTitle#',
            \ ' ',
            \ "%{exists('w:quickfix_title') ? w:quickfix_title : ''}",
            \ '%=',
            \ wininfo.loclist ? '%#STLLocList#' : '%#STLQuickfix#',
            \ wininfo.loclist ? get(s:sym, 'location', 'LL') : get(s:sym, 'quickfix', 'QF'),
            \ '[%l/%L]',
        \]), '')
endfun

fun! stl#terminal()
  return join(s:flatten([
        \ '%{stl#update("term")}',
        \ s:win.stl(),
        \ s:term.stl(),
        \ '%#STLStatusLine#',
        \ ' ',
        \ '%#STLTermTitle#',
        \ '%{getbufinfo("")[0].name}',
        \]), '')
endfun

" == MODULES ============================================================== {{{1
" -- BUFSTATE ------------------------------------------------------------- {{{2

let s:bufstate = {
      \ 'states': ['readonly', 'modified', 'normal'],
      \ 'unnamed': get(s:sym, 'unnamed', '[No Name]'),
      \ 'readonly': get(s:sym, 'readonly', '[RO]'),
      \ 'modified': get(s:sym, 'modified', '[+]'),
      \ 'shorten': { f -> fnamemodify(f, ':~:.:gs%\(\.\?[^/]\)[^/]*/%\1/%') },
      \ 'resolved': {},
      \}

fun! s:bufstate.update()
  if !has_key(b:, 'statusline')
    let b:statusline = self.get(bufnr(''))
  endif

  let b:statusline.mode[b:statusline.mode.last] = ''
  if win_getid() == g:actual_curwin
    let shortmode = mode(1)
    let mode = s:mode.map[shortmode]
    let b:statusline.mode[mode] = s:mode.sym[shortmode]
    if get(b:, 'table_mode_active')
      let b:statusline.mode[mode] ..= s:mode.sym['table']
    endif
    let b:statusline.mode.last = mode
  endif

  let bufstate = 'normal'
  let label = ''

  if getbufvar(b:statusline.bufnr, '&modified')
    let bufstate = 'modified'
    let label ..= s:bufstate.modified
  endif

  if getbufvar(b:statusline.bufnr, '&readonly')
    let bufstate = 'readonly'
    let label ..= s:bufstate.readonly
  endif

  let b:statusline.bufstate[b:statusline.bufstate.last] = ''
  let b:statusline.bufstate[bufstate] = label..b:statusline.git..b:statusline.buflabel
  let b:statusline.bufstate.last = bufstate

  return ''
endfun

fun! s:bufstate.get(bufnr)
  let buf = getbufvar(a:bufnr, 'statusline')
  let bufname = bufname(a:bufnr)

  if empty(buf)
    let buf = {
          \ 'bufname': bufname,
          \ 'bufnr': a:bufnr,
          \ 'realname': '',
          \ 'git': '',
          \ 'mode': { 'last': 'last' },
          \ 'bufstate': { 'last': 'last' },
          \ 'ale': { 'sym': '' },
          \}
    for mode in s:mode.modes
      let buf.mode[mode] = ''
    endfor

    for state in self.states
      let buf.bufstate[state] = ''
    endfor

    for type in s:ale.sections
      let buf.ale[type] = ''
    endfor

    let buf.filetype = s:filetype.label(a:bufnr)
    call self.setlabel(buf)
    call setbufvar(a:bufnr, 'statusline', buf)
  endif

  if buf.bufname != bufname
    call self.setlabel(buf)
  endif

  return buf
endfun

fun! s:bufstate.setlabel(buf)
  if empty(a:buf.bufname)
    let a:buf.buflabel = s:bufstate.unnamed
    let a:buf.bufshort = s:bufstate.unnamed
  else
    let a:buf.buflabel = fnamemodify(a:buf.bufname, ':~:.')
    let a:buf.bufshort = pathshorten(a:buf.bufname)
    let realname = fnamemodify(resolve(a:buf.bufname), ':.')
    if realname != a:buf.bufname
      let self.resolved[realname] = a:buf.bufname
      let a:buf.realname = pathshorten(realname)
    endif
  endif
endfun

fun! s:bufstate.stl()
  return add(map(copy(s:bufstate.states),
        \   { _, state -> [
        \     '%#STLBuffer',s:capitalize(state),'#',
        \     '%{b:statusline.bufstate.',state,'}',
        \   ]}),
        \   '%#STLBufferLink#%( -> %{b:statusline.realname} %)')
endfun

fun! s:bufstate.setgit(path, status)
  let bufnr = bufnr(a:path)
  if bufnr == -1
    if has_key(self.resolved, a:path)
      let bufnr = bufnr(self.resolved[a:path])
      if bufnr == -1
        return
      endif
    endif
    return
  endif

  let buf = self.get(bufnr)
  let buf.git = a:status
endfun

" -- WIN ------------------------------------------------------------------ {{{2

let s:win = {
      \ 'num': get(s:sym, 'num', {}),
      \}

fun! s:win.update()
  let winnr = winnr()
  return get(self.num, winnr, winnr)
endfun

fun! s:win.stl()
  return '%#STLWinnr#%( %{stl#update("win")} %)'
endfun

" -- MODE ----------------------------------------------------------------- {{{2

let s:mode = {
      \ 'modes': ['normal', 'insert', 'visual', 'select', 'replace', 'operator'],
      \ 'sym': {
      \   'table': get(s:sym, 'table', 'T'),
      \   'Rv': get(s:sym, 'replace', 'R')..get(s:sym, 'virtual', 'v'),
      \   'v': get(s:sym, 'visual', 'V')..get(s:sym, 'char', 'c'),
      \   'V': get(s:sym, 'visual', 'V')..get(s:sym, 'line', 'l'),
      \   '': get(s:sym, 'visual', 'V')..get(s:sym, 'block', 'b'),
      \   'no': 'O',
      \ },
      \ 'map': {
      \   '__'  : 'nothing',
      \   'n'   : 'normal',
      \   'no'  : 'operator',
      \   'ni'  : 'normal',
      \   'niI' : 'insert',
      \   'niR' : 'replace',
      \   'niV' : 'replace',
      \   'v'   : 'visual',
      \   'V'   : 'visual',
      \   ''  : 'visual',
      \   's'   : 'select',
      \   'S'   : 'select',
      \   ''  : 'select',
      \   'i'   : 'insert',
      \   'ic'  : 'insert',
      \   'ix'  : 'insert',
      \   'R'   : 'replace',
      \   'Rc'  : 'replace',
      \   'Rv'  : 'replace',
      \   'Rx'  : 'replace',
      \   'c'   : 'command',
      \   'cv'  : 'command',
      \   'ce'  : 'command',
      \   'r'   : 'query',
      \   'rm'  : 'query',
      \   'r?'  : 'query',
      \   '!'   : 'terminal',
      \   't'   : 'terminal',
      \ },
      \}

for [short, long] in items(s:mode.map)
  if !has_key(s:mode.sym, short)
    let s:mode.sym[short] = get(s:sym, long, get(s:sym, 'normal', '[N]'))
  endif
endfor

fun! s:mode.stl()
  return map(copy(self.modes),
        \   { _, mode -> [
        \     '%#STL',s:capitalize(mode),'Mode#',
        \     '%( %{b:statusline.mode.',mode,'} %)',
        \   ]})
endfun

" -- FILETYPE ------------------------------------------------------------- {{{2

let s:filetype = {}

fun! s:filetype.stl()
  return '%#STLFileType#%{b:statusline.filetype}'
endfun

fun! s:filetype.update(bufnr)
  let buf = s:bufstate.get(a:bufnr)
  let buf.filetype = self.label(a:bufnr)
endfun

fun! s:filetype.label(bufnr)
  let ft = getbufvar(a:bufnr, '&filetype')
  let enc = getbufvar(a:bufnr, '&encoding')
  return ft..(enc == 'utf-8' ? '' : '['..enc..']')
endfun

" -- ALE ------------------------------------------------------------------ {{{2

let s:ale = {
      \ 'sections': ['error', 'warning', 'info', 'style'],
      \ 'ale': get(s:sym, 'ale', 'ALE'),
      \ 'error':  get(s:sym, 'error', 'E'),
      \ 'warning':  get(s:sym, 'warning', 'W'),
      \ 'info':  get(s:sym, 'info', 'I'),
      \ 'style':  get(s:sym, 'style', 'S'),
      \}

fun! s:ale.stl()
  return [
        \  map(copy(self.sections),
        \    { _, section -> [
        \      '%#STLAle',s:capitalize(section),'#',
        \      '%(%{b:statusline.ale.',section,'}%)',
        \    ]})
        \]
endfun

fun! s:ale.update()
  let buf = s:bufstate.get(bufnr(''))
  let e = ale#statusline#Count(buf.bufnr)
  " let buf.ale.sym = e.total ? s:ale.ale : ''
  let buf.ale.error = e.error ? printf('%d%s', e.error, s:ale.error) : ''
  let buf.ale.warning = e.warning ? printf('%d%s', e.warning, s:ale.warning) : ''
  let buf.ale.info = e.info ? printf('%d%s', e.info, s:ale.info) : ''
  let buf.ale.style = e.style_error || e.style_warning
        \           ? printf('%d%s', e.style_error + e.style_warning, s:ale.style)
        \           : ''
endfun

" -- TERM ----------------------------------------------------------------- {{{2

let s:term = {
      \ 'insert': s:mode.sym.t,
      \ 'normal': s:mode.sym.n,
      \}

fun! s:term.stl()
  return [
        \ '%#STLTerminalMode#%( %{b:statusline.insert} %)',
        \ '%#STLNormalMode#%( %{b:statusline.normal} %)',
        \]
endfun

fun! s:term.update()
  let mode = mode()
  let b:statusline = {
        \ 'insert': mode == 't' ? s:term.insert : '',
        \ 'normal': mode == 't' ? '' : s:term.normal,
        \}
  return ''
endfun

" -- TABINDEX ------------------------------------------------------------- {{{2

let s:tabindex = {}

fun! s:tabindex.stl()
  let last = tabpagenr('$')
  if last == 1
    return ''
  endif
  return printf("%%#STLTabIndex#[%d/%d]", tabpagenr(), last)
endfun

" -- MRU ------------------------------------------------------------------ {{{2

let s:mru = {
      \ 'ignorepat': get(g:, 'stl_mru_ignorepat', ''),
      \ 'max': get(g:, 'stl_mru_max', 10),
      \ 'buftype_whitelist': [ '', 'nofile', 'nowrite', 'acwrite' ],
      \ 'lastused': {},
      \ 'normal': '',
      \ 'modified': s:bufstate.modified,
      \ 'readonly': s:bufstate.readonly,
      \ 'sort': { a, b -> b.lastused - a.lastused },
      \}

fun! s:mru.stl()
  let self.buffers = []
  let out = []

  let bufindex = 1
  for buf in sort(getbufinfo({ 'buflisted': v:true }), self.sort)
    if !empty(buf.windows)
          \ || ( !empty(self.ignorepat) && buf.name =~# self.ignorepat )
          \ || index(self.buftype_whitelist, getbufvar(buf.bufnr, '&buftype')) == -1
      continue
    endif

    let bufstate = s:bufstate.get(buf.bufnr)
    call add(self.buffers, buf.bufnr)
    call add(out, [
          \ '%#STLBufferNormal#',
          \ ' ',bufindex,' ',
          \ bufstate.git,
          \ bufstate.bufshort,
          \ ' ',
          \])

    if bufindex == self.max
      break
    else
      let bufindex += 1
    endif
  endfor

  return out
endfun

fun! s:mru.bufnr(idx)
  return get(self.buffers, a:idx - 1)
endfun

" -- GIT ------------------------------------------------------------------ {{{2

let s:git = {
      \ 'branch': get(s:sym, 'branch', 'B'),
      \ 'dirty': get(s:sym, 'dirty', '~'),
      \ 'status': {},
      \ 'repolabels': {},
      \}

fun! s:git.update()
  if !has_key(b:, 'git_dir')
    return
  endif

  let lines = systemlist("git status --porcelain=v2 --branch")
  if v:shell_error
    return
  endif

  let prevstatus = self.status

  let self.status = {}
  let repo = {}

  for line in lines
    if line[0] == '#'
      let words = split(line, '[ .]')
      if words[2] == 'head'
        let repo.branch = words[3]
      elseif words[2] == 'ab'
        let repo.ahead = str2nr(words[3][1:])
        let repo.behind = str2nr(words[4][1:])
      endif
    elseif line[0] == '1'
      let words = split(line)
      let status = words[1]
      let path = join(words[8:])
      let self.status[path] = self.label(status)
    elseif line[0] == '2'
      " TODO: renamed or copied entries
      let words = split(line, ' ')
      let status = words[1]
      let paths = join(words[9:])
      let [path, orig] = split(paths, "\t")
      let selfstatus[path] = self.label(status)
    elseif line[0] == '?'
      let words = split(line)
      let path = join(words[1:])
      let self.status[path] = self.label('??')
    endif
  endfor

  for [path, _] in items(prevstatus)
    if !has_key(self.status, path)
      call s:bufstate.setgit(path, '')
    endif
  endfor

  for [path, status] in items(self.status)
    call s:bufstate.setgit(path, status)
  endfor

  let self.repolabels[fnamemodify(b:git_dir, ':h')] = [
        \ '%#STLTabLineGit#',
        \ ' ',
        \ self.branch,
        \ get(repo, 'branch', ''),
        \ empty(self.status) ? '' : '%#STLTabLineGitDirty#'..self.dirty,
        \ '%#STLTabLineGit#',
        \ get(repo, 'ahead') ? printf(' +%d', repo.ahead) : '',
        \ get(repo, 'behind') ? printf(' -%d', repo.behind) : '',
        \ ' ',
        \]
  redrawtabline
endfun

fun! s:git.label(status)
  return printf('[%s]', a:status)
endfun

fun! s:git.stl()
  return get(self.repolabels, getcwd(-1, 0), '')
endfun

" -- STATUS --------------------------------------------------------------- {{{2

let s:status = {
      \ 'coc': get(s:sym, 'complete', 'CoC'),
      \ 'session': get(s:sym, 'session', 'S'),
      \ 'tag': get(s:sym, 'tag', 'T'),
      \ 'quickfix': '',
      \}

fun! s:status.stl()
  return [
        \ '%#STLStatus#',
        \ '%( %{"',
        \ get(g:, 'coc_process_pid') ? s:status.coc : '',
        \ empty(v:this_session) ? '' : s:status.session,
        \ empty(tagfiles()) ? '' : s:status.tag,
        \ s:status.quickfix,
        \ '"} %)',
        \]
endfun

fun! s:status.set_qf()
  let qflen = getqflist({'size': 1}).size
  let self.quickfix = qflen ? printf('%s%d', get(s:sym, 'quickfix', 'Q'), qflen) : ''
endfun

" == UTIL ================================================================= {{{1
"
fun! s:flatten(list, ...) abort
  let out = a:0 ? a:1 : []

  call map(copy(a:list), 'type(v:val) is v:t_list
        \ ? s:flatten(v:val, out)
        \ : add(out, v:val)')

  return out
endfun

fun! s:capitalize(word)
  return substitute(a:word, '^\w', '\u&', '')
endfun

if get(g:, 'stl_TESTING')
  fun! S(state)
    return get(s:, a:state)
  endfun

  fun! SCall(F, ...)
    return call('s:'..a:F, a:000)
  endfun
endif
