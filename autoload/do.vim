" File for keeping functions out of vimrc

" Change lines of code in some way {{{1

function! do#CopyLineUntil(offset, ...) " {{{2
  try
    call FindCharPos(a:offset, a:000)
  catch /NoMatch/
    return
  endtry
  call setline(s:lnum, s:other_line[0:(s:colmatch)])
  startinsert!
endfun

function! do#AlignWithChar(offset, ...) " {{{2
  try
    call FindCharPos(a:offset, a:000)
  catch /NoMatch/
    return
  endtry
  let curline = getline(s:lnum)
  call setline(s:lnum, Fill(curline, s:col, s:colmatch - s:col))
  "call setline(s:lnum, curline[0:(s:col - 1)].repeat(' ', s:colmatch - s:col).curline[s:col :])
  call setpos('.', [s:bufnum, s:lnum, s:colmatch + 1, s:off])
endfun

function! do#Variations(...) " {{{2
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

function! do#Fill(string, pos, width) " {{{2
  return a:string[0:(a:pos - 1)].repeat(' ', a:width).a:string[a:pos :]
endfun

function! do#FindCharPos(line_offset, varargs) " {{{2
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

function! do#UtlOrTag() " {{{2
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

fun! do#LocListIncr() " {{{2
  if !exists("b:loclistpos") || b:loclistpos >= len(b:syntastic_loclist)
    let b:loclistpos = 0
  endif
  let b:loclistpos += 1
  exe ":lfirst ".b:loclistpos
endfun

fun! do#LocListDecr()
  if !exists("b:loclistpos") || b:loclistpos <= 1
    let b:loclistpos = len(b:syntastic_loclist) + 1
  endif
  let b:loclistpos -= 1
  exe ":lfirst ".b:loclistpos
endfun " }}}

" VIMRC purtifiers {{{1

fun! do#VimRCHeadline(...)
  let line = getline('.')
  let words = split(line)
  let pad = 80 - (strlen(line) - strlen(words[-2]))
  let words[-2] = repeat(words[-2][0], pad)
  call setline('.', join(words))
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
fun! do#FoldText() " {{{
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

fun! do#SetFoldMarker(n) " {{{2
  if has_key(g:NERDDelimiterMap, &ft)
    let map = g:NERDDelimiterMap[&ft]
  elseif &ft == 'vim'
    let map = { 'left': "\"", 'right': "" }
  else
    return
  end
  let level = a:n
  let line = getline('.')
  let open_fold = '{{{'
  let pat = open_fold . '\d'

  if match(line, pat) >= 0
    let line = substitute(line, pat, open_fold . level, "")
  else
    let line .= " " . map['left'] . " " . open_fold . level
    if strlen(map['right'])
      let line .= " " . map['right']
    end
  endif

  call setline('.', line)
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
" do this in shell
" command! YouCompleteMeCompile call s:YouCompleteMeCompile()<CR>

" MISC {{{1
