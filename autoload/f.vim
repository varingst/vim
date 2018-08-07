" File for keeping functions out of vimrc

" == VimRcExtra =========================================================== {{{1
" called for ~/.vimrc only {{{1
fun! f#VimRcExtra()
  command! Functions :vsplit ~/.vim/autoload/f.vim
  command! Section :call f#VimRCHeadline()<CR>
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

" == Function key mapping and listing ===================================== {{{2

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

" == Location/Error list ================================================== {{{1

" http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
fun! s:GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

fun! f#ToggleLocList()
  if !len(getloclist(0))
    return
  endif

  let buflist = s:GetBufferList()

  " find if open by positive winnr
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~# "Location List"'),
                 \ 'str2nr(matchstr(v:val, "\\d\\+"))')
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


" == Vim Folding ========================================================== {{{1

" TODO: this is old, ugly, and buggy. Clean or Remove

fun! NextSimilarIndent(dir) " {{{2
  let p = getpos('.')
  let ind = indent(p[1])
  let i = (a:dir ? p[1] + 1 : p[1] - 1)
  while ((indent(i) + 1) ? (indent(i) != ind) : 0)
    let i = (a:dir ? i + 1 : i - 1)
  endwhile
  if indent(i) == ind | call setpos('.', [ p[0], i, p[2], p[3] ]) | endif
endfun

" Helper function for FoldText()
fun! s:GetFirstNonComment(start) " {{{2
  let line = ''
  let i = a:start
  let col = 1
  while match(synIDattr(synID(i, col, 1), 'name'), 'Comment$') != -1
    let i = nextnonblank(i+1)
  endwhile
  if !i | return 'NO NONBLANK LINE: EMPTY FOLD?' | endif
  let max = strlen(getline(i))
  while col <= max && match(synIDattr(synID(i, col, 1), 'name'), 'Comment$') == -1
    let col += 1
  endwhile
  return substitute(getline(i)[0:col-2], '^\s*\(\S*\)', '\1', '')
endfun

" {{{2
" If line contains nothing but a fold marker, use
" the next line of non-commented text as fold text
fun! f#FoldText() " {{{
  let ft = split(foldtext(), ':')
  " this line in better, but does not work ?!
  "let ft[1] = substitite(ft[1], ' \s*','','')
  let ft[1] = ft[1][1:]
  let ft[0] = ' '.substitute(ft[0], '^\D*','','').' '
  let txt = ''
  if match(ft[1], '\S') == -1
    let txt .= s:GetFirstNonComment(v:foldstart)
  else
    let txt .= join(ft[1:],':')
  endif
  let line = repeat('  ', v:foldlevel - 1).txt.' '
  let offset = &columns - ( 4 + len(line) + len(ft[0]))
  if offset > 0
    return line.repeat('-', offset).ft[0]
  else
    return line.ft[0]
  endif
endfun " }}}

fun! s:GetCommentMarker()
  if has_key(g:NERDDelimiterMap, &filetype)
    return g:NERDDelimiterMap[&filetype]
  elseif &filetype ==# 'vim'
    return { 'left': '"', 'right': '' }
  else
    return 0
  end
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

fun! s:IsAlreadyComment(line)
  return synIDattr(synID(line('.'), strwidth(a:line), 1), 'name') =~? 'comment'
endfun

" == For opening files in other things than Vim =========================== {{{1

" (xdg-)open wrapper
if executable('open')
  let s:open = 'open'
elseif executable('xdg-open')
  let s:open = 'xdg-open'
endif

fun! f#Open(...)
  let path = a:0 ? a:1 : s:FileUnderCursor()
  if !strlen(path) | echoerr 'Nothing to open, empty path' | return | endif
  silent exec '!'.(s:open . " '" . expand(path) . "'").' &'
endfun


fun! s:FileUnderCursor()
  let file = expand('<cWORD>')
  if filereadable(file)
    return file
  endif
  let file = expand(getline('.'))
  if filereadable(file)
    return file
  endif
  echoerr 'could not find file under cursor'
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

" == MISC ================================================================= {{{1


" -- Create Markdown Table of Contents ------------------------------------ {{{2
" PROTOTYPE: move somewhere else

let s:ignore = ['define', 'pragma']
fun! f#CreateMarkdownToc(...) " {{{3
  let toc = {
        \ 'header': a:0 ? a:1 : 'Table of contents',
        \ 'lines': [],
        \ 'open': 0,
        \ 'close': 0,
        \ }
  let in_embedded = 0
  let linenr = 0
  while linenr < line('$')
    let linenr += 1
    let line = getline(linenr)

    if line =~# '^```'
      let in_embedded = !in_embedded
    endif

    " skip if not a header
    if line !~# '^#' || in_embedded
      continue
    " mark start of table of contents
    elseif line =~ '^# *'.toc['header']
      let toc['open'] = linenr
      continue
    end
    " mark end of toc, by the line before the next heading
    if !toc['close'] && toc['open'] && line =~# '^#'
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
    let pad = repeat('  ', count(line, '#') - 1)
    call add(toc['lines'], pad . '- [' .title. '](#' .href. ')')
  endwhile

  return toc
endfun

fun! f#InsertMarkdownToc(toc) " {{{3
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
  call add(a:toc['lines'], '')
  " add heading
  call insert(a:toc['lines'], '# '.a:toc['header'])

  call append(a:toc['open'] - 1, a:toc['lines'])
endfun

fun! f#ListToc() " {{{3
  let s:toc = f#CreateMarkdownToc()
  for line in s:toc['lines']
    echo line
  endfor
endfun

