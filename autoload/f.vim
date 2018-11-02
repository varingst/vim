" File for keeping functions out of vimrc

" == VimRcExtra =========================================================== {{{1
" called for ~/.vimrc only
fun! f#VimRcExtra()
  command! Functions :vsplit ~/.vim/autoload/f.vim
  command! Section :call f#VimRCHeadline()
  command! Source :source ~/.vimrc<BAR>:source ~/.vim/autoload/f.vim
endfunction

" == Variations =========================================================== {{{1
" a:1: pattern, a:2 .. a:n: replacements
" copies current line and inserts a new one
" per replacement, with pattern replaced
function! f#Variations(...) " {{{2
  if a:0
    let words = a:000[:]
  else
    call inputsave()
    let words = split(input('match sub1 sub2 ... : '))
    call inputrestore()
  endif

  if len(words) <= 1
    return
  endif

  let curline = getline('.')
  for i in range(1, len(words) - 1)
    let words[i] = substitute(curline, words[0], words[i], 'g')
  endfor
  call append(line('.'), words[1: -1])
endfun

" == VimRCHeadline ======================================================== {{{1
" expands headline like ^ to 80 width
fun! f#VimRCHeadline()
  let line = getline('.')
  let words = split(line)
  let pad = 80 - (strlen(line) - strlen(words[-2]))
  let words[-2] = repeat(words[-2][0], pad)
  call setline('.', join(words))
endfun

" == Location/Error list ================================================== {{{1

" http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
fun! s:GetBufferList() " {{{2
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

fun! f#LocListToggle() " {{{2
  if !len(getloclist(0))
    return
  endif

  let buflist = s:GetBufferList()

  " find if open by positive winnr
  for bufnum in map(filter(split(buflist, '\n'),
                 \         'v:val =~# "Location List"'),
                 \  'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      lclose
      return
    endif
  endfor

  " open and stay in current window
  let winnr = winnr()
  lopen
  if winnr() != winnr
    wincmd p
  endif
endfun

fun! f#LNext() " {{{2
  try
    lnext
  catch /^Vim\%((\a\+)\)\=:E42/
    return
  catch /^Vim\%((\a\+)\)\=:E776/
    return
  catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
  endtry
endfun

fun! f#LPrev() " {{{2
  try
    lprev
  catch /^Vim\%((\a\+)\)\=:E42/
    return
  catch /^Vim\%((\a\+)\)\=:E776/
    return
  catch /^Vim\%((\a\+)\)\=:E553/
    llast
  endtry
endfun

" == Set/Remove Fold Markers ============================================== {{{1

fun! f#SetFoldMarker(level) " {{{2
  let map = s:GetCommentMarker()
  let line = getline('.')
  let open_fold = '{{{'
  let pat = open_fold . '\d'

  if a:level == 0
    " level = 0 => clear marker
    let marker_start = match(line, '\s*\(' . map['left'] . '\s*\)\?' . open_fold)
    if marker_start >= 0
      let line = line[0:marker_start - 1]
    else
      return
    endif
  else
    " level > 0 => add/update marker
    if match(line, pat) >= 0
      " update existing marker with new level
      let line = substitute(line, pat, open_fold . a:level, '')
    else
      if !s:IsAlreadyComment(line)
        let line .= ' ' . map['left']
      endif
      let line .= ' ' . open_fold . a:level
      if strlen(map['right'])
        let line .= ' ' . map['right']
      end
    endif
  endif

  call setline('.', line)
endfun

fun! s:GetCommentMarker() " {{{2
  if has_key(g:NERDDelimiterMap, &filetype)
    return g:NERDDelimiterMap[&filetype]
  elseif &filetype ==# 'vim'
    return { 'left': '"', 'right': '' }
  else
    return 0
  end
endfun

fun! s:IsAlreadyComment(line) " {{{2
  return synIDattr(synID(line('.'), strwidth(a:line), 1), 'name') =~? 'comment'
endfun

" == Conceal Toggle ======================================================= {{{1

fun! f#ConcealToggle()
  if &conceallevel
    let b:conceal_level = &conceallevel
    setlocal conceallevel=0
  else
    exe 'setlocal conceallevel='.b:conceal_level
  endif
endfun

" == ColorColumnToggle ==================================================== {{{1

fun! f#ColorColumnToggle()
  if strlen(&colorcolumn)
    setlocal colorcolumn=
  else
    setlocal colorcolumn=+1
  endif
endfun

" == Close all open non-dirty buffers ===================================== {{{1

let s:bufarg = { 'listed': 1 }
fun! f#CloseBuffers() " {{{2
  for buf in getbufinfo(s:bufarg)
    if !buf.changed && empty(buf.windows)
      exe 'bdelete '.buf.bufnr
    endif
  endfor
endfun

" == Cycle Cursorlines ==================================================== {{{1
fun! f#crosshair(n)
  let w:cross = (get(w:, 'cross', 0) + a:n) % 4
  exe ':set '.(and(w:cross, 1) ? '' : 'no').'cursorcolumn'
  exe ':set '.(and(w:cross, 2) ? '' : 'no').'cursorline'
endfun

" == vim-plugged extension ================================================ {{{1

fun! f#plug_begin() " {{{2
  call plug#begin()
  command! -nargs=1 PlugFT call s:AddPlugs(<args>)
endfun

" PlugFT {
"   'ruby': [
"     'user/plug',
"     'user/plug',
"     'user/plug', { 'extra': 'opts' },
"     'user/plug',
"   ]
"   'xml,html': [
"     ...
"   ]
" }

fun! s:AddPlugs(dict) " {{{2
  let plugins = {}
  let last_insert = ''
  for [ft, plugs] in items(a:dict)
    for repo_or_options in plugs
      if type(repo_or_options) == type('')
        let plugins[repo_or_options] = { 'for': split(ft, ',') }
        let last_insert = repo_or_options
      elseif type(repo_or_options) == type({})
        try
          for [opt, value] in items(repo_or_options)
            let plugins[last_insert][opt] = value
          endfor
        catch /^Vim\%((\a\+)\)\=:E716/
          if last_insert ==# ''
            echoerr 'Option passed before repo:'
          else
            echoerr 'Unknown error handling this entry:'
          endif
          echoerr repo_or_options
        endtry
      endif
    endfor
  endfor

  for [repo, opts] in items(plugins)
    call plug#(repo, opts)
  endfor
endfun

" == G to closest line number n$ ========================================== {{{1

function! f#G(n) " {{{2
  let i = 1
  let l = line('.')
  let last = line('$')
  while v:true
    let below = l + i
    let above = l - i
    if above < 1 && below > last
      return ":\<C-U>echoerr 'no line number match: ".a:n."$'\<CR>"
    elseif string(below) =~# a:n.'$'
      return s:G(below, mode())
    elseif string(above) =~# a:n.'$'
      return s:G(above, mode())
    else
      let i += 1
    endif
  endwhile
endfun

function! s:G(line, mode) " {{{2
  return a:mode == 'n' ? "\<ESC>".a:line."G" : "\<ESC>".a:mode.a:line."G"
endfun

" == Copy {motion} to register o, paste it on next line =================== {{{1

fun! f#copyO(type, ...) " {{{2
  let sel_save = &selection
  let selection = "inclusive"

  let reg_save = @@
  if a:0 "invoked from Visual mode, use '< and '> marks
    return
  elseif a:type == 'line'
    echoerr "linewise not supported"
  elseif a:type == 'block'
    echoerr "blockwise not supported"
  else " a:type == char
    silent exe "normal! `[v`]\"oyo\<C-R>o"
    startinsert!
  endif

  let &selection = sel_save
  let @@ = reg_save
endfun

" == Toggle Profiling ===================================================== {{{1

fun! f#Profile(file) abort " {{{2
  if has_key(s:, 'profiling')
    profile pause
    echo "quit and read ".s:profiling
  else
    let s:profiling = a:file
    exe ":profile start ".a:file
    profile func *
    profile file *
  endif
endfun

" == Write loaded scripts to file and open in split ======================= {{{1

fun! f#ScriptNames(file) abort " {{{2
  call writefile(split(execute('scriptnames'), "\n"),
               \ expand(a:file))
  exe printf("%s %s",
           \ winwidth('.') > 140 ? 'vsplit' : 'split',
           \ a:file)
endfun

" == Return Syntax Stack for what's under the cursor ====================== {{{1

fun! f#SynStack() abort " {{{2
  map(synstack(line('.'), col('.')),
    \ 'synIDattr(v:val, "name")')
endfun

" == Projectionist expander =============================================== {{{1

fun! f#projectionist(conf)
  for [root, config] in items(a:conf)
    for [filematch, _] in items(config)
      if filematch =~# '|'
        let c = remove(config, filematch)
        for fm in split(filematch, '|')
          let config[fm] = c
        endfor
      endif
    endfor
  endfor
  return a:conf
endfun

" == PROTOTYPES =========================================================== {{{1

" -- Select Window -------------------------------------------------------- {{{2
fun! f#SelectWindow()
  let s:wins = {}
  windo let s:wins[winnr()] = bufname(winbufnr(winnr()))
  " call inputlist(map(sort(keys(s:wins)), 'printf("%-8s%s", v:val, s:wins[v:val])'))
  for winnr in sort(keys(s:wins))
    echo printf('%-8s%s', winnr, s:wins[winnr])
  endfor
  let inp = 0
  echo printf('1-%d > ', len(s:wins))
  while inp < char2nr('1') || inp > char2nr(string(len(s:wins)))
    let inp = getchar()
  endwhile
  call win_gotoid(win_getid(str2nr(nr2char(inp))))
endfun


" -- Grep revision history for file --------------------------------------_{{{2
let s:max_matches = 50
fun! f#lgrep_revision_history(file, ...)
  if exists('s:gitrev_tmpdir')
    if isdirectory(s:gitrev_tmpdir)
      call delete(s:gitrev_tmpdir, 'rf')
    endif
    unlet! s:gitrev_tmpdir
  endif

  if !isdirectory('.git')
    echoerr "$PWD is not a git root"
    return
  endif

  try
    let matches = systemlist(
          \ "git rev-list --all -- ".a:file.
          \ " | xargs git grep --line-number ".join(a:000, ' '))
  catch
    return
  endtry

  let filtered = []
  for m in matches
    let sections = split(m, ':')
    if sections[1] == a:file
      call add(filtered, sections)
    endif
  endfor

  if len(filtered) > s:max_matches
    echoerr printf("got %d matches, specified max is %d",
                  \ len(filtered), s:max_matches)
    finish
  endif

  let s:gitrev_tmpdir = tempname()
  call mkdir(s:gitrev_tmpdir)

  let llist = {
        \ 'efm': '%f:%l:%m',
        \ 'title': 'Revision History Grep Results',
        \ 'lines': []
        \ }

  for m in filtered
    let [rev, file, lnum, line] = m
    let outfile = s:gitrev_tmpdir.'/'.rev.'/'.file
    call mkdir(fnamemodify(outfile, ':h'), 'p')
    call system(printf('git show %s:%s > %s', rev, file, outfile))

    call add(llist.lines, join([outfile, lnum, line], ':'))
  endfor

  call setloclist(0, [], 'r', llist)
  lopen
endfun

