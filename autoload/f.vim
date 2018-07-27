" File for keeping functions out of vimrc

" Change lines of code in some way {{{1

fun! f#VimRcExtra()
  command! Functions :vsplit ~/.vim/autoload/f.vim
endfunction

function! f#CopyLineUntil(offset, ...) " {{{2
  try
    call f#FindCharPos(a:offset, a:000)
  catch /NoMatch/
    return
  endtry
  call setline(s:lnum, s:other_line[0:(s:colmatch)])
  startinsert!
endfun

function! f#AlignWithChar(offset, ...) " {{{2
  try
    call f#FindCharPos(a:offset, a:000)
  catch /NoMatch/
    return
  endtry
  let curline = getline(s:lnum)
  call setline(s:lnum, s:Fill(curline, s:col, s:colmatch - s:col))
  "call setline(s:lnum, curline[0:(s:col - 1)].repeat(' ', s:colmatch - s:col).curline[s:col :])
  call setpos('.', [s:bufnum, s:lnum, s:colmatch + 1, s:off])
endfun

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

function! s:Fill(string, pos, width) " {{{2
  return a:string[0:(a:pos - 1)].repeat(' ', a:width).a:string[a:pos :]
endfun

function! f#FindCharPos(line_offset, varargs) " {{{2
  let params = {}
  let ignorecase = &ignorecase
  let char = len(a:varargs) ? a:varargs[0] : nr2char(getchar())
  let [s:bufnum, s:lnum, s:col, s:off, s:curswant] = getcurpos()
  let s:other_line = getline(s:lnum + a:line_offset)
  set noignorecase
  let s:colmatch = match(s:other_line, char, s:col)
  if ignorecase | set ignorecase | endif
  if s:colmatch < 0 | throw "NoMatch" | endif
endfun

function! f#UtlOrTag() " {{{2
  let line = getline('.')
  let utl_start = match(line, '<url:#r')

  if (utl_start >= 0)
    " strings are 0-indexed, while the columns are 1-indexed
    let pos = getpos('.')
    let pos[2] = utl_start + 1
    call setpos('.', pos)
    exe ":Utl"
    return
  elseif (match(line, '|\S\+|') >= 0)
    let tag = substitute(line, '.*|\(\S\+\)|.*', '\1', '')
    if len(tag)
      exe ":ta ".tag
      return
    endif
  endif

  normal! <C-]>
endfun

fun! f#LocListIncr() " {{{2
  if !exists("b:loclistpos") || b:loclistpos >= len(b:syntastic_loclist)
    let b:loclistpos = 0
  endif
  let b:loclistpos += 1
  exe ":lfirst ".b:loclistpos
endfun

fun! f#LocListDecr()
  if !exists("b:loclistpos") || b:loclistpos <= 1
    let b:loclistpos = len(b:syntastic_loclist) + 1
  endif
  let b:loclistpos -= 1
  exe ":lfirst ".b:loclistpos
endfun " }}}

" VIMRC purtifiers {{{1

fun! f#VimRCHeadline(...)
  let line = getline('.')
  let words = split(line)
  let pad = 80 - (strlen(line) - strlen(words[-2]))
  let words[-2] = repeat(words[-2][0], pad)
  call setline('.', join(words))
endfun

" Function key mapping and listing

let s:fkeys = {}
fun! f#MapFkeys(keys)
  for [key, cmd] in items(a:keys)
    let s:fkeys[key] = cmd
    exe 'nnoremap ' . key . ' ' . cmd . '<CR>'
    exe 'inoremap ' . key . ' <ESC>' . cmd . '<CR>'
  endfor
endfun

fun! f#ListFkeys()
  for i in range(2, 12)
    let key = '<F'.i.'>'
    if has_key(s:fkeys, key)
      echo key . ' ' . s:fkeys[key]
    endif
  endfor
endfun

" Syntastic/ALE Location List
" DEPRECATED
fun! f#ErrorsVisible()
  if exists('g:loaded_ale')
    if !(exists('b:ale_highlight_items') && len(b:ale_highlight_items))
      return 0
    endif
  else
    if !(exists('b:syntastic_loclist')
          \ && len(b:syntastic_loclist._rawLoclist))
      return 0
    end
  end
  for winnr in range(1, winnr('$'))
    let bufnr = winbufnr(winnr)
    if getbufvar(bufnr, '&buftype') == 'quickfix'
      return 1
    endif
  endfor
  return 0
endfun

fun! f#LNext()
  try
    lnext
  catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
  endtry
endfun

fun! f#LPrev()
  try
    lprev
  catch /^Vim\%((\a\+)\)\=:E553/
    llast
  endtry
endfun

fun! f#ShowErrors()
  if exists('g:loaded_ale')
    lopen
    " if f#ErrorsVisisble()
      " lclose
    " else
      " lopen
    " endif
  elseif exists(':Errors')
    exe ':Errors'
  endif
endfun

" Vim Folding {{{1

" Move to next/prev line of same indent level as current one
" PARAMS: dir <bool> : next line of true, prev line if false
fun! NextSimilarIndent(dir) " {{{2
  let p = getpos(".")
  let ind = indent(p[1])
  let i = (a:dir ? p[1] + 1 : p[1] - 1)
  while ((indent(i) + 1) ? (indent(i) != ind) : 0)
    let i = (a:dir ? i + 1 : i - 1)
  endwhile
  if indent(i) == ind | call setpos('.', [ p[0], i, p[2], p[3] ]) | endif
endfun
"fun! WrapSettings()
  "verbose :set textwidth?
  "verbose :set wrap?
  "verbose :set wrapmargin?
  "verbose :set formatoptions?
"endfun

"function! Rotator(list)
  "let i = 0
  "let c = a:list
  "let i_last = (len(c) - 1)
  "function! Inner() closure
    "let i = i == i_last ? 0 : i + 1
    "return c[i]
  "endfunction
  "return funcref('Inner')
"endfun


"let R = Rotator([ "81", "131", "+1,+2" ])
"let R2 = Rotator([ "31", "41" ])

"nmap <F5> :exe "set colorcolumn=".R()<CR>
"nmap <F6> :exe "set colorcolumn=".R2()<CR>
"
" Helper function for FoldText()
fun! s:GetFirstNonComment(start) " {{{2
  let line = ""
  let i = a:start
  let col = 1
  while match(synIDattr(synID(i, col, 1), "name"), 'Comment$') != -1
    let i = nextnonblank(i+1)
  endwhile
  if !i | return "NO NONBLANK LINE: EMPTY FOLD?" | endif
  let max = strlen(getline(i))
  while col <= max && match(synIDattr(synID(i, col, 1), "name"), 'Comment$') == -1
    let col += 1
  endwhile
  return substitute(getline(i)[0:col-2], '^\s*\(\S*\)', '\1', '')
endfun

" {{{2
" If line contains nothing but a fold marker, use
" the next line of non-commented text as fold text
" TODO: Not working properly
" Fails with NON-ALNUM CHARS
fun! f#FoldText() " {{{
  let ft = split(foldtext(), ':')
  " this line in better, but does not work ?!
  "let ft[1] = substitite(ft[1], ' \s*','','')
  let ft[1] = ft[1][1:]
  let ft[0] = " ".substitute(ft[0], '^\D*','','')." "
  let txt = ""
  if match(ft[1], '\S') == -1
    let txt .= s:GetFirstNonComment(v:foldstart)
  else
    let txt .= join(ft[1:],':')
  endif
  let line = repeat('  ', v:foldlevel - 1).txt." "
  let offset = &columns - ( 4 + len(line) + len(ft[0]))
  if offset > 0
    return line.repeat('-', offset).ft[0]
  else
    return line.ft[0]
  endif
endfun " }}}

fun! s:GetCommentMarker()
  if has_key(g:NERDDelimiterMap, &ft)
    return g:NERDDelimiterMap[&ft]
  elseif &ft == 'vim'
    return { 'left': "\"", 'right': "" }
  else
    return 0
  end
endfun

fun! f#SetFoldMarker(level) " {{{2
  let map = s:GetCommentMarker()
  let line = getline('.')
  let open_fold = '{{{'
  let pat = open_fold . '\d'

  if a:level == 0
    " level = 0 => clear marker
    let marker_start = match(line, '\s\+\(' . map['left'] . '\s\*\)\?' . open_fold)
    if marker_start >= 0
      let line = line[0:marker_start - 1]
    else
      return
    endif
  else
    " level > 0 => add/update marker
    if match(line, pat) >= 0
      let line = substitute(line, pat, open_fold . a:level, "")
    else
      let line .= " " . map['left'] . " " . open_fold . a:level
      if strlen(map['right'])
        let line .= " " . map['right']
      end
    endif
  endif

  call setline('.', line)
endfun

" (xdg-)open wrapper
if executable('open')
  let s:open = 'open'
elseif executable('xdg-open')
  let s:open = 'xdg-open'
endif

fun! s:FileUnderCursor()
  let file = expand("<cWORD>")
  if filereadable(file)
    return file
  endif
  let file = expand(getline('.'))
  if filereadable(file)
    return file
  endif
  echoerr "could not find file under cursor"
endfun


fun! f#Open(...)
  let path = a:0 ? a:1 : s:FileUnderCursor()
  if !strlen(path) | echoerr "Nothing to open, empty path" | return | endif
  silent exec "!".(s:open . " '" . expand(path) . "'")." &"
endfun

let s:conceal_level = &conceallevel
fun! f#ConcealToggle()
  if &conceallevel
    setlocal conceallevel=0
  else
    exe "setlocal conceallevel=".s:conceal_level
  endif
endfun

" Compile YCM {{{1

fun! s:YouCompleteMeCompileOptions(pairs) " {{{2
  let opt_string = ' --clang-completer'
  for [exe, opt] in items(a:pairs)
    if executable(exe)
      let opt_string .= ' '.opt
    endif
  endfor
  return opt_string
endfun

fun! s:YouCompleteMeCompile() " {{{2
  let cwd = getcwd()
  let vim_runtime = split(&runtimepath, ',')[0]
  let ycm_dir = vim_runtime.'/plugged/YouCompleteMe'
  call system('cd '.ycm_dir)
  if v:shell_error
    throw "YCM dir not located"
    return
  endif
  let install_cmd = './install.py'.s:YouCompleteMeCompileOptions({
        \ 'msbuild': '--omnisharp-completer',
        \ 'go': '--gocode-completer',
        \ 'node': '--tern-completer',
        \ 'rustc': '--racer-completer' })
  exe '!'.install_cmd
  "echo install_cmd
  call system('cd '.cwd)
endfun

let s:bufarg = { 'listed': 1 }
fun! f#ClearBuffers() " {{{2
  for buf in getbufinfo(s:bufarg)
    if !buf.changed && empty(buf.windows)
      exe 'bdelete '.buf.bufnr
    endif
  endfor
endfun

" let s:keys = {}
" let s:width = {}
" let g:no_more_keys = 0

" fun! f#AddKey(...)
  " if g:no_more_keys | return | endif

  " let entry = { 'keys': a:1 }
  " if a:0 == 2
    " let entry['mode'] = 'n'
    " let entry['text'] = a:2
  " else
    " let entry['mode'] = a:2
    " let entry['text'] = a:3
  " endif

  " call add(s:keys, entry)

  " for k in ['keys', 'mode', 'text']
    " let s:width[k] = max([get(s:width, k, 0), strdisplaywidth(entry[k])])
  " endfor
" endfun

" fun! f#ListKeys()
  " if !len(s:keys)
    " echo "no keys to list .."
    " return
  " endif

  " let format = '%-'.(s:width['keys'] + 2).'s%-'.(s:width['mode'] + 2).'s%s'
  " let available_width = &columns - strdisplaywidth(printf(format, '', '', '  '))

  " for entry in s:keys
    " echo printf(format, entry['keys'], entry['mode'],
          " \ strdisplaywidth(entry['text']) > available_width
          " \ ? entry['text'][:available_width - 2].'..'
          " \ : entry['text'])
  " endfor
" endfun

" fun! f#ClearKeys()
  " let s:keys = []
  " let s:width = {}
  " let g:no_more_keys = 0
" endfun

" MISC {{{1
"
fun! f#Profile(fname)
  exe "profile start ".a:fname
  profile func *
  profile file *
endfun

fun! f#ProfilePause()
  profile pause
endfun

let s:ignore = ['define', 'pragma']
fun! f#CreateMarkdownToc(...)
  let toc = {
        \ 'header': a:0 ? a:1 : 'Table of contents',
        \ 'lines': [],
        \ 'open': 0,
        \ 'close': 0,
        \ }
  let in_embedded = 0
  let linenr = 0
  while linenr < line("$")
    let linenr += 1
    let line = getline(linenr)

    if line =~ '^```'
      let in_embedded = !in_embedded
    endif

    " skip if not a header
    if line !~ '^#' || in_embedded
      continue
    " mark start of table of contents
    elseif line =~ '^# *'.toc['header']
      let toc['open'] = linenr
      continue
    end
    " mark end of toc, by the line before the next heading
    if !toc['close'] && toc['open'] && line =~ '^#'
      let toc['close'] = linenr - 1
    endif

    " skip our ignored words
    let skip = 0
    for word in s:ignore
      if line =~ '^# *'.word
        let skip = 1
        break
      endif
    endfor
    if skip
      continue
    endif

    " now lets get to the parsing
    let title = substitute(line, '^#* *', '', '')
    let href = tolower(substitute(title, ' ', '-', ''))
    let pad = repeat("  ", count(line, '#') - 1)
    call add(toc['lines'], pad . "- [" .title. "](#" .href. ")")
  endwhile

  return toc
endfun

fun! f#InsertMarkdownToc(toc)
  " remove existing TOC
  if a:toc['open'] && a:toc['close']
    silent! exe ':'.a:toc['open'].','.a:toc['close'].'d'
  " clear line to mark where TOC is to be inserted
  elseif a:toc['open']
    silent! exe ':'.a:toc['open'].'d'
  " use line 3 as default if nothing set
  else
    let a:toc['open'] = 3
  endif

  " add empty line as spacing before first section
  call add(a:toc['lines'], "")
  " add heading
  call insert(a:toc['lines'], "# ".a:toc['header'])

  call append(a:toc['open'] - 1, a:toc['lines'])
endfun

fun! f#ListToc()
  let toc = f#CreateMarkdownToc()
  for line in s:toc['lines']
    echo line
  endfor
endfun

fun! f#Profile()
  if exists('s:profile')
    call s:ProfileEnd()
  else
    call s:ProfileStart()
  endif
endfun

fun! s:ProfileStart()
  let s:profile = tempname()
  exe ":profile start " . s:profile
  exe ":profile func *"
  exe ":profile file *"
endfun

fun! s:ProfileEnd()
  exe ":vsplit " . s:profile
  unlet s:profile
endfun

