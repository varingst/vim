command! -nargs=? ReplaceEach
      \ silent call f#ReplaceEach(<q-args>)

command! -nargs=? Profile
      \ silent call toggle#Profiling(<q-args>)

command! -nargs=* LocalGrep
      \ silent call qf#LocalGrep(<q-args>)

command! -nargs=+ -complete=expression PP
      \ call pp#(<args>)

command! Changes
      \ exe 'Split '..changes#View()

command! -bang -register Scratch
      \    exe empty(<q-reg>)
      \      ? "new "..get(g:sym, 'scratch', '[scratch]')
      \      : printf("%dnew @%s", min([len(getreg(<q-reg>, v:null, v:true)), winheight(0) / 2]), <q-reg>)
      \ | setlocal buftype=nowrite
      \ | setlocal noswapfile
      \ | let &l:bufhidden = empty(<q-bang>) ? 'delete' : 'hide'
      \ | if !empty(<q-reg>)
      \ |   exe printf("au BufLeave <buffer> call setreg('%s', getline(1, '$'), getregtype('%s'))", <q-reg>, <q-reg>)
      \ |   exe "normal! i\<C-R>\<C-O>"..<q-reg>.."\<ESC>`["
      \ | endif

command! -bang TempFile
      \   let f = tempname()
      \ | exe empty(<q-bang>) ? 'Split' : 'edit' f
      \ | setlocal bufhidden=wipe

command! -nargs=? -complete=filetype FTPlugin
      \ exe 'Split '..$MYVIMHOME..'/ftplugin/'..(empty(<q-args>) ? &filetype : <q-args>)..'.vim'

command! -nargs=? -bang Tags
      \ eval (!empty(tagfiles()) || !empty(<q-bang>)) && system($MYVIMHOME..'/bin/ctags '..<q-args>)

command! -nargs=0 SynStack
      \ echo join(syntax#Stack(), "\n")

command! -bang -nargs=1 -complete=file HexEdit
      \   exe printf('%s ++binary %s +%!xxd', empty(<q-bang>) ? 'Split' : 'edit', <q-args>)

command! -nargs=1 RTP
      \ PP split(&rtp, ',')->filter({ _, p -> p =~ <q-args> })

command! -nargs=0 -range=% StripAnsi
      \ <line1>,<line2>s/\[\(\d\{1,2}\(;\d\{1,2}\)\?\)\?[m\|K]//ge

command! -nargs=0 -range Hex2Rgb
      \ <line1>,<line2>s/#\(\x\+\)/\='rgb'..(strlen(submatch(1))==6?'(':'a(')..join(map(split(submatch(1),'\x\{2}\zs'),{_,x->str2nr(x,16)}),', ')..')'/ge

command! -nargs=0 -range Rgb2Hex
      \ <line1>,<line2>s/\(rgba\?\)(\([^)]*\))/\=call('printf',['#'..repeat('%X',strlen(submatch(1)))]+split(submatch(2),'\s*,\s*'))/ge

command! -nargs=? -complete=file Open
      \ silent eval { f -> netrw#BrowseX(f, netrw#CheckIfRemote(f)) }(expand(empty(<q-args>) ? '%' : <q-args>))

" :[range]Collect[!] [reg] pattern
" collect all matches in register [reg], default "
" bang clears the register first, no bang appends
command! -nargs=+ -range=% -bang Collect
      \   let parts = matchlist(<q-args>, '\(\([a-z]\)\s\+\)\?\(.*\)')
      \ | let oldpat = @/
      \ | let [reg, @/] = empty(parts[1]) ? ['"', parts[3]] : parts[2:3]
      \ | let collected = []
      \ | let pos = getcurpos()
      \ | silent! keepjumps <line1>,<line2>s//\=add(collected, submatch(0))/gne
      \ | call setpos('.', pos)
      \ | call setreg(reg, collected, <q-bang> == '!' ? '' : 'a')
      \ | let @/ = oldpat
      \ | unlet parts reg collected pos oldpat

" Split: split depending on window width {{{2
command! -nargs=* -bar -complete=file Split execute win#V() ? 'vsplit' : 'split' <q-args>

" DiffOrig: diff file and buffer, see :he :DiffOrig {{{2
command! -nargs=0 DiffOrig
      \ | vert new
      \ | set bt=nofile
      \ | r++edit #
      \ | 0d_
      \ | diffthis
      \ | wincmd p
      \ | diffthis

" GitDiffs: run diffs in tabs for each modified file {{{2
command! -nargs=? GitDiffs
      \ | for f in systemlist(
      \       'git diff --name-only --diff-filter=AM '.
      \       (empty(<q-args>) ? "HEAD~1" : <q-args>))
      \ |   execute '$tabnew '..f
      \ |   execute 'Gvdiff '..(empty(<q-args>) ? "HEAD~1" : <q-args>)
      \ | endfor

" ScriptNames: open scriptnames in split {{{2
command! -nargs=0 ScriptNames
      \   if win#V()
      \ |   vnew
      \ | else
      \ |   new
      \ | endif
      \ | call append(0, split(execute('scriptnames'), "\n"))

command! -nargs=? -bang -complete=file MkSession
      \   let fname = v:this_session
      \ | if empty(fname) || !empty(<q-bang>)
      \ |   let fname = <q-args>
      \ | endif
      \ | if empty(fname)
      \ |   let fname = isdirectory('.git') ? '.git/Session.vim' : 'Session.vim'
      \ | endif
      \ | exe 'mksession!' fname

command! -nargs=0 ClearTags call settagstack(0, {'items': [] })

" Highlight: echo highlight group for item under cursor, yank to register if provided {{{2
command! -nargs=? -register Highlight
      \   if empty(<q-reg>)
      \ |   exe 'highlight '..syntax#Stack()[-1]
      \ | else
      \ |   silent call setreg(<q-reg>, syntax#Stack()[-1])
      \ |   exe 'highlight '..getreg(<q-reg>)
      \ | endif

" Read: append output of given or line range of shell commands {{{2
command! -nargs=* -range Read
      \   silent! call
      \   map(
      \     reverse(
      \       map(
      \         filter(
      \           !empty(<q-args>)
      \           ? map(split(<q-args>, ';'),
      \                 { _, cmd -> [<line1>, cmd] })
      \           : map(getline(<line1>, <line2>),
      \                 { i, cmd -> [
      \                   i + <line1>,
      \                   substitute(cmd, '^\s*$\s*', '', '')
      \                 ]}),
      \           { _, cmd -> cmd[1] !~ '^\s*#' }),
      \         { _, cmd -> add(cmd, systemlist(cmd[1]))})),
      \     { _, cmd -> append(cmd[0], cmd[2]) })

" Move: rename % and create directory structure {{{2
command! -nargs=1 -complete=file Move
      \   let buf = @%
      \ | let alt = @#
      \ | saveas <args>
      \ | let @# = alt
      \ | call delete(buf)
      \ | exe 'bdelete' buf
      \ | unlet buf alt

command! -nargs=+ Verbose
      \   let out = execute('verbose '..<q-args>)
      \ | let matches = matchlist(out, 'Last set from \(\S\+\) line \(\d\+\)')
      \ | if empty(matches)
      \ |   echo out
      \ | else
      \ |   exe printf('Split +%s %s', matches[2], matches[1])
      \ | endif
      \ | unlet out matches

command! -nargs=? -complete=function Function
      \ exe 'Verbose function '..(empty(<q-args>)
      \   ? execute('messages')
      \     ->split('\n')
      \     ->map({ _, s -> matchstr(s, 'processing function \zs[^:]*\ze') })
      \     ->get(-1, '')
      \   : <q-args>
      \ )->substitute('(.*$', '', '')

command! -nargs=1 -complete=command Command Verbose command <args>
command! -nargs=1 -complete=option Set Verbose set <args>

" TableModeInsert: insert NxM table
command! -nargs=+ TableModeInsert
      \   let args = map(split(expand(<q-args>)), 'str2nr(v:val)')
      \ | let cols = get(args, 0, 2)
      \ | let lines = [ repeat('|-', cols)..'|' ]
      \ | for i in range(get(args, 1, 2))
      \ |   call add(lines, repeat('| ', cols)..'|')
      \ |   call add(lines, repeat('|-', cols)..'|')
      \ | endfor
      \ | exe 'TableModeEnable'
      \ | call append(line('.'), lines)
      \ | unlet args cols lines

" Section: Expand deco heading
command! Section
      \   let line = getline('.')
      \ | let words = split(line)
      \ | let idx = words[-1] =~ '\V{{{\d\?' ? -2 : -1
      \ | let pad = 80 - (strlen(line) - strlen(words[idx]))
      \ | let words[idx] = repeat(words[idx][0], pad)
      \ | call setline('.', join(words))
      \ | unlet line words pad idx

command! QFGitDiff cexpr system($MYVIMHOME..'/bin/qfgitdiff')

command! -range=0 -nargs=+ MRU
      \   if <count>
      \ |   let bufnr = stl#mru_bufnr(<count>)
      \ |   if bufnr
      \ |     exe bufnr..expand(<q-args>)
      \ |   endif
      \ |   unlet bufnr
      \ | endif

command! -nargs=+ -bar KeepView
      \   let v = winsaveview()
      \ | <args>
      \ | call winrestview(v)
      \ | unlet! v

command! -nargs=+ Mark
      \   let [reg, pat] = split(expand(<q-args>))
      \ | let v = winsaveview()
      \ | if reg =~? '[a-z]'
      \ |   call cursor(1, 1)
      \ |   let pos = searchpos(pat, 'nWc')
      \ |   if pos != [0, 0]
      \ |     call setpos("'"..reg, [0] + pos + [0])
      \ |   endif
      \ | endif
      \ | call winrestview(v)
      \ | unlet! reg pat pos v

command! -range=% SingleLines KeepView keepjumps keeppatterns <line1>,<line2>s/\(^\n\)\{2,}/\r/e
