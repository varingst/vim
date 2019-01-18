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
  call f#filter_loclist()
  lopen
  if winnr() != winnr
    wincmd p
  endif
endfun

fun! f#Wrap(prefix, next, wrap)
  try
    exe a:prefix.a:next
  catch /^Vim\%((\a\+)\)\=:E42/
    return
  catch /^Vim\%((\a\+)\)\=:E776/
    return
  catch /^Vim\%((\a\+)\)\=:E553/
    exe a:prefix.a:wrap
  endtry
endfun

nnoremap <silent> <Plug>LPrev :call f#Wrap('l', 'prev', 'last')<CR>
nnoremap <silent> <Plug>LNext :call f#Wrap('l', 'next', 'first')<CR>
nnoremap <silent> <Plug>CPrev :call f#Wrap('c', 'prev', 'last')<CR>
nnoremap <silent> <Plug>CNext :call f#Wrap('c', 'next', 'first')<CR>

fun! f#LocalVimGrep(...) " {{{2
  let pattern = substitute(a:0 ? a:1 : @/, '^/\(.*\)/$', '\1', '')
  let lnum = line('.')

  silent! exe 'vimgrep /'.pattern.'/ %'
  let qf = getqflist()
  if len(qf)
    exe "copen ".min([len(qf), 15])
    wincmd p
    for entry in qf
      if entry.lnum == lnum
        return
      endif
      try
        cnext
      catch /E553/
        cfirst
      endtry
    endfor
  endif
endfun

fun! f#QuickFixFlush() " {{{2
  for winnr in range(1, winnr('$'))
    if getwinvar(winnr, '&syntax') == 'qf'
      cclose
      break
    endif
  endfor
  call setqflist([])
endfun


" == Set/Remove Fold Markers ============================================== {{{1

fun! f#SetFoldMarker(level) " {{{2
  let line = getline('.')
  let open_fold = '{{{'
  let pat = open_fold . '\d'

  if a:level == 0
    " level = 0 => clear marker
    let cmtopen = split(printf(&commentstring, '|'), '|')[0]

    let marker_start = match(line, '\s*\(' . cmtopen . '\s*\)\?' . open_fold)
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
      let line .= printf((s:IsAlreadyComment(line)
                        \ ? '%s'
                        \ : &commentstring),
                        \ open_fold.a:level)
    endif
  endif

  call setline('.', line)
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
    exe 'setlocal conceallevel='.get(b:, 'conceal_level', get(
                                    \g:, 'default_conceal_level', 2))
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

" == Gdiff Toggle ========================================================= {{{1

fun! f#GdiffToggle() abort
  let did_close = v:false

  if exists('s:gdiff_file')
    for buf in getbufinfo({ 'listed': 1 })
      if buf.name == s:gdiff_file
        exe 'bdelete '. buf.bufnr
        let did_close = v:true
        break
      endif
    endfor

    unlet! s:gdiff_file
    if did_close
      return
    endif
  endif

  Gdiff!

  for buf in getbufinfo({ 'listed': 1 })
    if (match(buf.name, '^fugitive.*'.expand('%').'$') == 0)
      let s:gdiff_file = buf.name
    endif
  endfor
endfun

" == PreviewHunkToggle ==================================================== {{{1

fun! f#PreviewHunkToggle() abort
  let current_hunk = s:current_hunk()
  if exists('s:viewed_hunk')
    if empty(current_hunk) || current_hunk == s:viewed_hunk
      unlet! s:viewed_hunk
      pclose
      return
    endif
  endif

  if empty(current_hunk)
    return
  endif

  let s:viewed_hunk = current_hunk
  GitGutterPreviewHunk
endfun

fun! s:current_hunk() abort " {{{2
  let current_hunk = []
  let bufnr = bufnr('')

  for hunk in gitgutter#hunk#hunks(bufnr)
    if gitgutter#hunk#cursor_in_hunk(hunk)
      let current_hunk = hunk
      break
    endif
  endfor

  return current_hunk
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
  command! -nargs=1 PlugFT    call s:AddPlugs(<args>)
  command! -nargs=+ PlugLocal call s:MaybeLocal(<args>)
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
      elseif type(repo_or_options) == v:t_dict
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

fun! s:MaybeLocal(repo, ...)
  if a:0 == 0
    let opts = {}
    let local = substitute(a:repo, '[^/]*', expand('~/dev/'), '')
  elseif a:0 == 1
    if type(a:1) == v:t_string
      let opts = {}
      let local = expand('~/dev/').a:1
    elseif type(a:1) == v:t_dict
      let opts = a:1
      let local = substitute(a:repo, '[^/]*', expand('~/dev/'), '')
    endif
  elseif a:0 == 2
    let local = expand('~/dev/').a:1
    let opts = a:2
  endif

  call plug#(isdirectory(local) ? local : a:repo, opts)
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
    elseif below <= last && string(below) =~# a:n.'$'
      return s:G(below)
    elseif above >= 1 && string(above) =~# a:n.'$'
      return s:G(above)
    else
      let i += 1
    endif
  endwhile
endfun

function! s:G(lnum) " {{{2
  return "\<ESC>".(mode() == 'n' ? '' : 'gv').a:lnum."G"
endfun


" == Linewise ============================================================= {{{1

function! f#linewise(count, on_count, default)
  let mode = mode()
  if !a:count
    return a:default
  endif
  return mode == 'n' ?
        \ "\<ESC>".(a:count - 1).a:on_count :
        \ "\<ESC>".mode.(a:count - 1).a:on_count
endfun

" == Copy {motion} to register o, paste it on next line =================== {{{1

fun! f#copyO(type, ...) " {{{2
  let sel_save = &selection
  let selection = "inclusive"

  if a:0 "invoked from Visual mode, use '< and '> marks
    silent exe "normal! gv\"oyo\<C-R>o"
    startinsert!
  elseif a:type == char
    silent exe "normal! `[v`]\"oyo\<C-R>o"
    startinsert!
  endif

  let &selection = sel_save
endfun

fun! f#double(type, ...) " {{{2
  let sel_save = &selection
  let selection = "inclusive"

  if a:0 " invoked from visual mode
    silent exe "normal! gv\"oy\"oP"
  elseif a:type == 'line'
    silent exe "normal! '[V']\"oy\"oP"
  else
    silent exe "normal! `[v`]\"oy\"oP"
  endif
  let &selection = sel_save
endfun

fun! f#replace(type, ...) " {{{2
  let sel_save = &selection
  let selection = 'inclusive'
  let r_save = @r
  let @r = @"
  if a:0
    silent exe "normal! gvd\"rp"
  elseif a:type == 'line'
    silent exe "normal! '[V']d\"rp"
  else
    silent exe "normal! `[v`]d\"rp"
  endif
  let @r = r_save
  let &selection = sel_save
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

" == Projectionist expander =============================================== {{{1

let s:readme = { 'type': 'readme' }
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
    if !has_key(config, 'README.md')
      let config['README.md'] = s:readme
    endif
  endfor
  return a:conf
endfun

" == Toggle =============================================================== {{{1
fun! f#toggle(dict, key)
  let a:dict[a:key] = !get(a:dict, a:key)
endfun

" == Toggle Completion ==================================================== {{{1

fun! f#AutoCompletionToggle()
  if has_key(g:ycm_filetype_blacklist, &filetype)
    call f#toggle(g:, 'ncm2#auto_popup')
  else
    call f#toggle(g:, 'ycm_auto_trigger')
    " TODO: check if this is actually necessary
    YcmRestartServer
  endif
endfun


" == PROTOTYPES =========================================================== {{{1

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

fun! f#fold(list, f, ...) " {{{2
  try
    let acc = a:0 ? a:1 : remove(a:list, 0)
  catch /E684/
    throw "Thou canst not fold that which is empty"
  endtry

  for e in a:list
    let acc = a:f(acc, e)
  endfor

  return acc
endfun

fun! f#filter_loclist(...) " {{{2
  let winnr = a:0 ? a:1 : winnr()
  let loclist = getloclist(winnr)

  if empty(loclist)
    return
  endif

  let bufnrs = {}
  for item in loclist
   call remove(item, 'type')
   let bufnrs[item.bufnr] = 1
   call remove(item, 'col')
  endfor

  if len(bufnrs) == 1
    for item in loclist
      call remove(item, 'bufnr')
    endfor
  endif

  call setloclist(winnr, loclist)
endfun


fun! f#comment_motion(type, ...) " {{{2
  let sel_save = &selection
  let &selection = 'inclusive'
  let reg_save = @@

  if a:0
  elseif a:type == 'line'
    exe "normal '[V'] \<Plug>NERDCommenterToggleComment"
  else
    exe "normal `[v`] \<Plug>NERDCommenterToggleComment"
  endif

  let &selection = sel_save
  let @@ = reg_save
endfun

nmap <silent> <leader>C :set opfunc=f#comment_motion<CR>g@
