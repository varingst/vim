if has('patch-8.1.1116')
  scriptversion 3
endif

let $MYVIMHOME = split(&rtp, ',')[0]

try
" == PLUG ================================================================= {{{1
call plugged#begin({
      \ 'local_paths': '~/dev/',
      \ 'local_users': 'varingst',
      \ 'formats': {
      \   'b': 'git@bitbucket.org:%s.git',
      \ }
      \})

" -- Bling ---------------------------------------------------------------- {{{2

Plug 'markonm/traces.vim'

" -- Programmer QoL ------------------------------------------------------- {{{2

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
CoC 'tsserver',
  \ 'html',
  \ 'css',
  \ 'json',
  \ 'solargraph',
  \ 'python'

Plug 'w0rp/ale'
Plug 'varingst/ale-silence'

Plug 'varingst/vim-skeleton'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'puremourning/vimspector', {
      \ 'do': join(['./install_gadget.py',
      \   '--enable-c',
      \   '--enable-python',
      \   '--enable-bash',
      \   '--force-enable-chrome',
      \ ])
      \}

" -- Language Extras ------------------------------------------------------ {{{2

Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'junegunn/vader.vim'

" -- Tim Pope obviously --------------------------------------------------- {{{2

Plug 'tpope/vim-surround'         " XML tags, brackets, quotes, etc
Plug 'tpope/vim-speeddating'      " increment/decrement dates +++
Plug 'tpope/vim-endwise'          " autoadd closing symbols (end/endif/endfun)
Plug 'tpope/vim-repeat'           " make '.' handle plugins nicer
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-fugitive'

" -- My stuff misc -------------------------------------------------------- {{{2

Plug 'varingst/vim-cheatsheet'
Plug 'varingst/vim-charsearch'
Plug 'varingst/vim-stylin'
Plug 'varingst/vim-imotion'
Plug 'varingst/vim-qf'
Plug 'varingst/vim-tasks'
Plug 'varingst/vim-selector'
Plug 'varingst/vim-filter'

" -- Markup, Template, Formatting, et al ---------------------------------- {{{2

" Todo/Project
Plug 'mattn/calendar-vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'ledger/vim-ledger'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'sirtaj/vim-openscad'
Plug 'aklt/plantuml-syntax'

" -- Prototypes ----------------------------------------------------------- {{{2

for proto in glob($MYVIMHOME..'/proto/*', v:false, v:true)
  call plug#(proto)
endfor

call plugged#end()

runtime macros/matchit.vim

" == SYMBOLS ============================================================== {{{1

let g:sym = {
      \ 'line':                      '行',
      \ 'column':                    '桁',
      \ 'error':                     '誤',
      \ 'warning':                   '戒',
      \ 'info':                      '注',
      \ 'style':                     '式',
      \ 'nothing':                   '無',
      \ 'correct':                   '正',
      \ 'incorrect':                 '歪',
      \ 'normal':                    '常',
      \ 'insert':                    '挿',
      \ 'replace':                   '代',
      \ 'command':                   '令',
      \ 'operator':                  '操',
      \ 'visual':                    '視',
      \ 'select':                    '選',
      \ 'branch':                    '枝',
      \ 'paste':                     '貼',
      \ 'readonly':                  '定',
      \ 'quickfix':                  '直',
      \ 'location':                  '場',
      \ 'terminal':                  '端',
      \ 'query':                     '問',
      \ 'modified':                  '改',
      \ 'dirty':                     '汚',
      \ 'unnamed':                   '[無名]',
      \ 'bug':                       '虫',
      \ 'table':                     '表',
      \ 'tag':                       '札',
      \ 'session':                   '恒',
      \ 'ale':                       '醸',
      \ 'char':                      '字',
      \ 'virtual':                   '仮',
      \ 'block':                     '欄',
      \ 'complete':                  '了',
      \ 'open':                      '+',
      \ 'close':                     '-',
      \ 'space':                     ' ',
      \ 'null':                      '',
      \ 'whitespace_trailing':       '§',
      \ 'whitespace_tab':            '›',
      \ 'whitespace_tab_pad':        ' ',
      \ 'whitespace_nobreak':        '¬',
      \ 'nowrap_precedes':           '‹',
      \ 'nowrap_extends':            '›',
      \ 'fill_vert':                 '│',
      \ 'fill_fold':                 ' ',
      \ 'fill_end_of_buffer':        '˜',
      \ 'fill_diff_removed':         ' ',
      \ 'gutter_error':              '»',
      \ 'gutter_warning':            '›',
      \ 'gutter_info':               '∞',
      \ 'gutter_style':              '≈',
      \ 'gutter_added':              '·',
      \ 'gutter_modified':           '˜',
      \ 'gutter_removed':            '–',
      \ 'gutter_removed_first_line': 'ˆ',
      \ 'gutter_removed_above_below':'‹',
      \ 'gutter_modified_removed':   '¡',
      \ 'no_coverage':               '`',
      \ 'num': split('零壱弐三四五六七八九', '\zs'),
      \ 'day': split('日月火水木金土', '\zs'),
      \ 'box': split('─│─│┌┐┘└', '\zs'),
      \ }

" == AUTOCOMMANDS ========================================================= {{{1

augroup vimrc_autocmd
  autocmd!

  au BufWinLeave *.* mkview
  au BufWinEnter *.* silent! loadview

  exe 'au BufRead '..g:plug_home..'/*/doc/*.txt set filetype=help'

  au BufWinEnter ~/.vimrc cd ~/.vim
        \               | if exists('*FugitiveDetect')
        \               |   call FugitiveDetect(expand('~/.vim'))
        \               | endif

  au BufWritePre * call fs#MkMissingDir(expand('<afile>'))
  au BufWritePost * call fs#SetExeOnShebang(&filetype, expand('<afile>'))

  au BufReadPost,FileReadPost,BufNewFile,WinEnter * call tmux#SetWindowTitle()
  au VimLeavePre * call tmux#SetWindowTitle(fnamemodify(getcwd(), ':~'))
  au VimEnter * call tmux#SetPaneServerName()

  au FileType * call ftcommon#source(expand('<amatch>'))

  au BufWritePost * Tags

  au CursorHold,CursorHoldI * call popup#FuncName()

  " c_CTRL-\ e uses the expression register
  au CmdlineEnter * let g:exreg = getreg('=', 1)
  au CmdlineLeave * call setreg('=', g:exreg)
augroup END

" == OPTIONS ============================================================== {{{1

set background=dark
try
  exe printf("colorscheme motoko_%s", exists('&t_Co') ? &t_Co : '16')
catch /^Vim\((\a\+)\)\=:E185:/
  exe "colorscheme "..stylin#build('motoko', &t_Co)
endtry

set backspace=indent,eol,start
set modeline
set scrolloff=5
set wildmenu
set wildmode=longest:list
set completeopt=menu,menuone,popup
set nomore
set shortmess+=cs
set winminheight=0
set splitright
set splitbelow

if &modifiable && !has('nvim')
  set fileencoding=utf-8
  set encoding=utf-8
  set termencoding=utf-8
  scriptencoding utf-8
endif
set noswapfile
set autoread

set title
set visualbell
set noerrorbells
set noshowmode
set ttimeout
set ttimeoutlen=50
set updatetime=300

set tabpagemax=100
let g:qf_disable_statusline = 1
let &g:statusline = stl#statusline()
set tabline=%!stl#tabline()
set laststatus=2
set showtabline=2
let g:stl_mru_ignorepat = join([
      \ '\c\v^!',
      \ 'debugged program',
      \ 'gdb communication',
      \ 'vimspector.*',
      \ ], '|')

set history=1000
set undolevels=1000

set viminfo+=h
set hlsearch
nohlsearch
set incsearch
set ignorecase
set smartcase
set magic
set hidden
set tildeop

set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set foldnestmax=2
set foldmethod=expr
set foldexpr=fold#expr(v:lnum)
set foldtext=printf('%s\ [%d]',getline(v:foldstart),(1+v:foldend-v:foldstart))
set diffopt+=foldcolumn:0
set list
let &g:listchars = join([
      \ 'tab:'        ..g:sym.whitespace_tab..g:sym.whitespace_tab_pad,
      \ 'trail:'      ..g:sym.whitespace_trailing,
      \ 'nbsp:'       ..g:sym.whitespace_nobreak,
      \ 'precedes:'   ..g:sym.nowrap_precedes,
      \ 'extends:'    ..g:sym.nowrap_extends
      \  ], ',')
let &g:fillchars = join(extend([
      \ 'vert:'       ..g:sym.fill_vert,
      \ 'fold:'       ..g:sym.fill_fold,
      \ 'diff:'       ..g:sym.fill_diff_removed,
      \ ], has('nvim')
      \    ? [
      \ 'eob:'        ..g:sym.fill_end_of_buffer,
      \] : []), ',')

set conceallevel=2
set concealcursor=nc

set nowrap
set textwidth=80
set linebreak
set breakindent
set formatoptions=cqj
set synmaxcol=128
set viewoptions=cursor,folds
set path=.,,
set tags^=.git/tags,.git/libtags,libtags
set spelllang=en_us

set ttyfast
set lazyredraw

if executable('ag')
  set grepformat=%f:%l:%c:%m
  let &g:grepprg = join([
      \ 'ag',
      \ '--nocolor',
      \ '--vimgrep',
      \ '--case-sensitive',
      \])
else
  let &g:grepprg = join([
      \ 'grep',
      \ '--color=never',
      \ '--line-number',
      \ '--with-filename',
      \ '--dereference-recursive',
      \ '--binary-files=without-match',
      \ '--exclude-dir=.git',
      \])
endif

let g:vimsyn_embed = 0 " no embedded perl, lua, ruby, etc syntax in .vim files

let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'

" -- not builtin ---------------------------------------------------------- {{{2

let g:cmdline_sugar = {
      \ '\C\v^w%[rite]!!': 'write !sudo tee % > /dev/null',
      \ '\C\v^e%[dit]!!': 'silent Git checkout -- % <BAR> redraw!',
      \ '\C\v^(gr%[ep]|grepa%[dd])>!?': { cmd -> printf('silent %s', cmd) },
      \ '\C\v^sp%[lit]> ': { cmd -> substitute(cmd, '\v^sp%[lit]', 'Split', '') },
      \ '\C\v^sf%[ind]>': { cmd -> substitute(cmd, '\v^sf%[ind]', win#V() ? 'vertical sfind' : 'sfind', '') },
      \ '\C\v^sb%[uffer]>': { cmd -> substitute(cmd, '\v^sb%[uffer]', win#V() ? 'vertical sbuffer' : 'sbuffer', '') },
      \}

let g:winsplit_threshold = 140

" == KEY MAPPING ========================================================== {{{1

" ~/.vim/plugin/keys.vim
exe 'source '..$MYVIMHOME..'/keys.vim'
nnoremap <C-B> :call keys#list()<CR>

map ; <nop>
let g:mapleader = ';'

" -- Disable TMUX prefix -------------------------------------------------- {{{2

noremap <C-A> <nop>
noremap! <C-A> <nop>

" -- Various Normal ------------------------------------------------------- {{{2

nnoremap <expr> I v:count ? '<ESC><C-V>'.(v:count).'jI' : 'I'
nnoremap <expr> r v:count ? '<ESC><C-V>'.(v:count).'jr' : 'r'

nnoremap <expr>V '<ESC>V'.(v:count1 > 1 ? (v:count1 - 1).'j' : '')

nnoremap ~~ ~l
nnoremap <leader>k K
nnoremap M m`2<C-O>

nnoremap <C-G> :<C-U>call stl#ctrlg()<CR>
nnoremap <C-S> :<C-U>write<CR>
nnoremap <C-X> :<C-U>update<CR>

nnoremap <leader>@ :<C-U>let @+ = getreg(v:register)<CR>
nmap <leader>: ":<leader>@

nnoremap <silent><expr> gf v:register == '"'
      \ ? 'gf'
      \ : ':<C-U>call setreg(v:register, expand("<cfile>"))<CR>'

nnoremap <silent> z/ :<C-U>autocmd CursorMoved <buffer> ++once normal! zt<CR>/
nnoremap <silent> z? :<C-U>autocmd CursorMoved <buffer> ++once normal! zt<CR>?

" -- Various Insert ------------------------------------------------------- {{{2

inoremap <C-O><C-O> <C-O>O
inoremap <S-CR> <C-O>o
inoremap <C-CR> <C-O>O

inoremap <C-Q> <C-\><C-O>"_dT

inoremap <silent><C-S> <C-R>=snip#(nr2char(getchar()), &filetype)<CR>

inoremap <expr><C-Y> pumvisible() ? '<C-Y>' : printf("<C-R><C-R>='%s'<CR>", align#colword(line('.')-1))
inoremap <expr><C-E> pumvisible() ? '<C-E>' : printf("<C-R><C-R>='%s'<CR>", align#colword(line('.')+1))

inoremap <leader><C-V> <C-V>

inoremap <Left> <C-G>U<Left>
inoremap <Right> <C-G>U<Right>

inoremap <silent><C-L> <C-G>u<ESC>
      \:let p=add(getcurpos(), col('$'))<CR>
      \[s1z=
      \:call setpos('.', p[:-2])<CR>
      \:call setpos('.', p[:1] + [p[2] + col('$') - p[-1]] + p[3:-2])<CR>
      \:unlet p<CR>
      \a<C-G>u

for pair in ['{}', '[]', '()']
  for group in ['', ';', ',']
    exe printf('inoremap %s%s<CR> %s<CR>%s%s<C-C>O',
          \ pair[0], group, pair[0], pair[1], group)
  endfor
endfor

" -- Various Visual ------------------------------------------------------- {{{2

xnoremap <leader>. :<C-U>exe "'<,'>normal \<Plug>(RepeatDot)"<CR>

xnoremap <expr>J ":move '>+".v:count1.'<CR>gv'
xnoremap <expr>K ":move '<-".(v:count1+1).'<CR>gv'

xnoremap * /\V<C-R>=escape(Visual(), '^/')<CR><CR>
xnoremap # ?\V<C-R>=escape(Visual(), '^?')<CR><CR>

xmap <bar> <Plug>(align)
xmap g<bar> <Plug>(alignG)

for p in ['p', 'P', 'gp', 'gP']
  exe printf("xnoremap <expr><leader>%s '%sgv\"'..v:register..'y`>%s'", p, p, p =~ 'g' ? 'l' : '')
endfor
unlet p

" -- Various Command ------------------------------------------------------ {{{2

cnoremap <expr><C-G> getcmdtype() == ':' ? '<C-\>ecmdline#("cmdline#incstep")<CR>' : '<C-G>'
cnoremap <expr><C-T> getcmdtype() == ':' ? '<C-\>ecmdline#("cmdline#incstep", 0)<CR>' : '<C-T>'

cnoremap <silent><leader><C-W> <C-\>ecmdline#CtrlWChar()<CR>
cnoremap <silent><leader><C-U> <Home><S-Right><C-W>
cnoremap <expr><C-;> getcmdtype() =~ '[/?]' ? '.\{-,20}' : "%:h/\<C-D>"
cnoremap <expr><CR> getcmdtype() == ':' ? "<C-\>ecmdline#intercept()\<CR>\<CR>" : "\<CR>"
cnoremap <expr><S-CR> getcmdtype() =~ '[/?]' ? "<C-\>e'\\<'..getcmdline()..'\\k*'..getcmdtype()..'e'<CR><CR>" : "<S-CR>"
cnoremap <expr><C-B> getcmdline() =~# '\v^(gr%[ep]<BAR>grepa%[dd])>' ? '<S-Left>\b<S-Right>\b' : '<S-Left>\<<S-Right>\>'
cnoremap <expr><C-]> getcmdtype() == ':' && getcmdline() =~ '^\d\+\s*' ? '<C-\>estl#mru_bufnr(getcmdline())<CR> <End>' : '<C-]>'
cnoremap <C-R><C-Q> <C-R><C-A>

cnoremap <expr> $_ getcmdtype()->substitute('?', '/', '')->histget(-1)->split()[-1]

" -- Various Window ------------------------------------------------------- {{{2

" go to last accessed window, like tmux
nnoremap <C-W>; <C-W>p

" set window width to 90/180 columns
nnoremap <C-W>i <ESC>90<C-W><BAR>
nnoremap <C-W>I <ESC>180<C-W><BAR>

" swap window with window <count>
nnoremap <C-W>p :<C-U>call win#Swap(v:count1)<CR>

nnoremap <C-W>o :<C-U>call win#Zoom(v:count ? v:count : winnr())<CR>

" line/column guides
nnoremap <C-W>u :<C-U>
      \ let w:cursorlines = (get(w:, 'cursorlines') + v:count1) % 4<CR>
      \:let &l:cursorline = and(w:cursorlines, 1)<CR>
      \:let &l:cursorcolumn = and(w:cursorlines, 2)<CR>

" -- Various Operators ---------------------------------------------------- {{{2

nnoremap <Del> "_d
xnoremap <Del> "_d
nnoremap <Del><Del> "_d_

nnoremap <expr><silent>H ':<C-U>call op#Edge(1, 0)<CR>g@'..v:count1..'i'
nnoremap <expr><silent>L ':<C-U>call op#Edge(0, 0)<CR>g@'..v:count1..'i'
nnoremap <expr><silent><C-H> ':<C-U>call op#Edge(1, 0)<CR>g@'..v:count1..'a'
nnoremap <expr><silent><C-L> ':<C-U>call op#Edge(0, 0)<CR>g@'..v:count1..'a'

xnoremap <expr><silent>H ':<C-U>call op#Edge(1, 1)<CR>g@'..v:count1..'i'
xnoremap <expr><silent>L ':<C-U>call op#Edge(0, 1)<CR>g@'..v:count1..'i'
xnoremap <expr><silent><C-H> ':<C-U>call op#Edge(1, 1)<CR>g@'..v:count1..'a'
xnoremap <expr><silent><C-L> ':<C-U>call op#Edge(0, 1)<CR>g@'..v:count1..'a'

nmap <bar> <Plug>(op#Align)
xmap <bar> <Plug>(op#Align)
nmap g<bar> <Plug>(op#AlignG)
xmap g<bar> <Plug>(op#AlignG)

nmap > <Plug>(op#ShiftRight)
nmap < <Plug>(op#ShiftLeft)

nnoremap >> >>
nnoremap << <<

" -- Various Motions/Text Objects ----------------------------------------- {{{2

" matchit: linewise to closing marker
omap % Vg%

" function call object, if from inside args, af on func name
xnoremap if <ESC>va(obo
xnoremap af <ESC>%v%bo

onoremap if :<C-U>normal vif<CR>
onoremap af :<C-U>normal vaf<CR>

for obj in split('[]()bt<>{}B', '\zs')
  for type in ['a', 'i']
    for direction in ['n', 'N']
      exe printf("xnoremap <silent>%s%s%s :<C-U>call nextobj#('%s%s%s', v:count1, mode())<CR>",
            \    type, direction, obj, type, direction, obj)
      exe printf("onoremap <expr>%s%s%s printf(':<C-U>normal v%%d%s%s%s<CR>', v:count1)",
            \    type, direction, obj, type, direction, obj)
    endfor
  endfor
endfor
unlet obj type direction

" -- Various Abbr --------------------------------------------------------- {{{2

inoreabbrev #! #!/usr/bin/env

" -- Arrowkeys/Buffernav -------------------------------------------------- {{{2

nnoremap <Left> <C-W><
nnoremap <Right> <C-W>>

nnoremap <silent><BS>        :<C-U>call stl#mru_exe_bufnr('buffer %d', v:count1)<CR>
nnoremap <silent><Space><BS> :<C-U>call stl#mru_exe_bufname('Split %s', v:count1)<CR>

nnoremap <silent><Up>      :<C-U>call qf#().prev(v:count1)<CR>
nnoremap <silent><Down>    :<C-U>call qf#().next(v:count1)<CR>

nmap <expr><C-Left>  get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-left)'  : '<C-W>h'
nmap <expr><C-Right> get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-right)' : '<C-W>l'
nmap <expr><C-Up>    get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-up)'    : '<C-W>k'
nmap <expr><C-Down>  get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-down)'  : '<C-W>j'

" -- Jumps and friends ---------------------------------------------------- {{{2

nnoremap <leader><C-O> :<C-U>jumps<CR>:call ExeInput("normal! %s\<C-O>", '-jumps > ', { i -> i =~ '^\d\+$' })<CR>
nnoremap <leader><C-I> :<C-U>jumps<CR>:call ExeInput("normal! %s\<C-I>", '+jumps > ', { i -> i =~ '^\d\+$' })<CR>
nnoremap <leader>g; :<C-U>changes<CR>:call ExeInput("normal! %sg;", '-changes > ', { i -> i =~ '^\d\+$' })<CR>
nnoremap <leader>g, :<C-U>changes<CR>:call ExeInput("normal! %sg,", '+changes > ', { i -> i =~ '^\d\+$' })<CR>
nnoremap <leader><C-T> :<C-U>tags<CR>:call ExeInput("%spop", '-tags > ', { i -> i =~ '\d\+$' })<CR>
nnoremap <leader><C-]> :<C-U>tags<CR>:call ExeInput("%stag", '+tags > ', { i -> i =~ '\d\+$' })<CR>

" -- Insert lines --------------------------------------------------------- {{{2

nnoremap <silent> [<CR> :<C-U>call append(line('.') - 1, map(range(v:count1), '""'))<CR>
nnoremap <silent> ]<CR> :<C-U>call append(line('.'), map(range(v:count1), '""'))<CR>

xnoremap <silent> [<CR> :<C-U>call append(line("'<") - 1, map(range(v:count1), '""'))<CR>gv
xnoremap <silent> ]<CR> :<C-U>call append(line("'>"), map(range(v:count1), '""'))<CR>gv

" -- Set fold markers ----------------------------------------------------- {{{2

nnoremap <silent> z<BS>         :call fold#SetMarker(0)<CR>
nnoremap <silent> z<Space> :<C-U>call fold#SetMarker(v:count1)<CR>

" -- Insert mode completion ----------------------------------------------- {{{2

for c in split('lnkti]fdvuo', '\zs')
  exe printf('inoremap ,%s <C-X><C-%s>', c, c)
endfor

" -- Awkward symbol shorthands -------------------------------------------- {{{2
inoremap ,. ->
inoremap ., <-
inoremap ,, =>

" -- Swap quotes ---------------------------------------------------------- {{{2

nmap <leader>' cs"'
nmap <leader>" cs'"

" -- Code Search ---------------------------------------------------------- {{{2

nnoremap <space>f :GFiles<CR>
nnoremap <space>F :Files<CR>
nnoremap <space>v :AV<CR>
nnoremap <space>? :nmap <lt>space><CR>
nnoremap <space><Tab> :<C-U>call tag#FindKind()<CR>
nnoremap <space><S-Tab> :<C-U>call tag#Find()<CR>

nnoremap <silent>^ :<C-U>
      \let v = { 'topline': line('w0') }<CR>
      \*#
      \:call winrestview(v)<CR>
      \:unlet! v<CR>

nmap <leader>*  <Plug>(qf#GreqfWordExact)
nmap <leader>g* <Plug>(qf#GreqfWord)
nmap <leader>#  <Plug>(qf#GreqfWORDExact)
nmap <leader>g# <Plug>(qf#GreqfWORD)

nnoremap & :&&<CR>
xnoremap & :&&<CR>

" -- Tag arg completion -- {{{2

imap <C-X>a <Plug>(complete#tag-arg)
nmap ga <Plug>(complete#select-next-arg)

" -- Normal jkJK ---------------------------------------------------------- {{{2

" j/k on visual lines, not actual lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" navigate folds with J/K
nnoremap <expr> J foldlevel('.') && foldclosed('.') != -1
      \         ? '99zo'
      \         : 'zj:if foldclosed(".")==-1<BAR>exe "normal J"<BAR>endif<CR>'
nnoremap <expr> K foldlevel('.')
      \         ? foldclosed('.') == -1
      \           ? 'zc'
      \           : 'gk'
      \         : 'zk'

" -- Search --------------------------------------------------------------- {{{2

for c in split('fFtTsSnN', '\zs')
  exe printf('nmap %s <Plug>(charsearch#%s)', c, c)
  exe printf('xmap %s <Plug>(charsearch#%s)', c, c)
  exe printf('omap %s <Plug>(charsearch#%s)', c, c)
  exe printf('imap <leader>%s <Plug>(charsearch#%s)', c, c)
endfor

nnoremap <leader>n /\V<C-R>=escape(getreg(v:register), '^/')<CR><CR>
nnoremap <leader>N ?\V<C-R>=escape(getreg(v:register), '^?')<CR><CR>

" -- System Clipboard ----------------------------------------------------- {{{2

inoremap <C-V> <C-O>"+p
vnoremap <C-C> "+y
vnoremap <C-X> "+d

" -- Virtual <C-Registers> ------------------------------------------------ {{{2

inoremap <C-R>' <C-R>"
inoremap <C-R><C-D> <C-R>=system('date "+%Y-%m-%d"')->trim()<CR>
inoremap <C-R><leader><C-D> <C-R>=
      \[inputsave(), input('date > '), inputrestore()][1]
      \->printf('date --date="%s" "+%%Y-%%m-%%d"')
      \->system()
      \->trim()
      \<CR>

inoremap <C-R><C-V> <C-R>=printf(get(b:, 'assignment_format', '%s = %s'), @., @")<CR>
inoremap <C-R><Space> <Space><C-G>U<Left>

" TODO: make these operators
inoremap <C-R><C-W> <Plug>(stringlist-double)
inoremap <C-R><C-Q> <Plug>(stringlist-single)

inoremap <silent><C-R><Tab> <C-\><C-O>:let pos=add(getcurpos(), virtcol('.'))<CR>
      \<Up>
      \<C-\><C-O>:call search('\V\C'..nr2char(inputsave()+getchar()+inputrestore()), 'z', line('.'))<CR>
      \<C-\><C-O>:let pad = repeat(' ', virtcol('.') - pos[-1])<CR>
      \<C-\><C-O>:call setpos('.', pos[:3])<CR>
      \<C-R>=pad<CR>
      \<C-\><C-O>:unlet pos pad<CR>

" -- Sticky Shift Camel Case Relief --------------------------------------- {{{2

nnoremap <silent><leader>u m`:keeppatterns s/.*\zs\(\u\)/\L\1/e<CR>``
inoremap <silent><leader>u <C-G>u<ESC>:keeppatterns s/.*\zs\(\u\)/\L\1/e<CR>`^i<C-G>u

" -- Line join ------------------------------------------------------------ {{{2

xnoremap <expr><leader>j &filetype == 'vim' ? ':<C-U>+1,''>s/^\s\+\(\\\)//<CR>gvJ' : 'J'
nmap <expr><leader>j v:count1 < 2 ? '<ESC>Vj<leader>j' : '<ESC>V'..(v:count1 - 1)..'j<leader>j'

" -- Fkeys ---------------------------------------------------------------- {{{2

call keys#function({
  \ '<F1>':           ':call keys#flist()',
  \ '<F2>':           ':call qf#().toggle()',
  \ '<F3>':           ':CocStart',
  \ '<F4>':           ':TagbarToggle',
  \ '<F5>':           ':CheatSheet',
  \ '<F6>':           ':FKeyMode debug <BAR> call vimspector#Continue()',
  \ '<F7>':           ':call vimspector#ToggleBreakpoint()',
  \ '<F8>':           ':call toggle#PreviewHunk()',
  \ '<F9>':           ':Gstatus',
  \ '<F11>':          ':Make',
  \ '<S-F1>':         ':set wrap!',
  \ '<S-F2>':         ':call qf#().flush()',
  \ '<S-F3>':         ':TableModeToggle',
  \ '<S-F5>':         ':call toggle#Conceal()',
  \ '<S-F6>':         ':call toggle#SetLocal("colorcolumn", "", "+1")',
  \ '<S-F7>':         ':call vimspector#AddFunctionBreakpoint("<cexpr>")',
  \ '<S-F8>':         ':call toggle#Gdiff()',
  \ '<S-F9>':         ':Gcommit --all',
  \ '<S-F11>':        ':Make!',
  \ 'debug:<F4>':     ':FKeyMode <BAR> call vimspector#Stop()',
  \ 'debug:<F5>':     ':call vimspector#Pause()',
  \ 'debug:<F6>':     ':call vimspector#Continue()',
  \ 'debug:<F8>':     ':call vimspector#StepOver()',
  \ 'debug:<F9>':     ':call vimspector#StepInto()',
  \ 'debug:<F10>':    ':call vimspector#StepOut()',
  \ 'debug:<S-F6>':   ':call vimspector#Restart()',
  \ })


" == PLUGINS ============================================================== {{{1

" == COMMON =============================================================== {{{2
"
let g:gcc_flags = {
    \  'common': [
      \ '-Wall',
      \ '-Wextra',
      \ '-isystem', '/usr/include',
      \ '-I', '.',
      \ ],
    \ 'c': [
      \ '-Wstrict-prototypes',
      \ '-xc',
      \ '-std=c11',
      \ ],
    \ 'cpp': [
      \ '-xc++',
      \ '-std=c++11',
      \ ],
  \ }

let g:root_patterns = {
      \ 'c': ['.ccls', 'compile_commands.json']
      \}

" -- COC ------------------------------------------------------------------ {{{2

let g:coc_start_at_startup = 0
let g:coc_enable_locationlist = 0

let g:coc_user_config = {
      \ 'coc.preferences': {
      \    'extensionUpdateCheck': 'never',
      \    'hoverTarget': 'float',
      \ },
      \ 'diagnostic': {
      \   'displayByAle': v:true,
      \ },
      \ 'suggest': { 'autoTrigger': 'trigger' },
      \ 'solargraph.diagnostics': v:true,
      \ 'solargraph.useBundler': v:true,
      \ 'solargraph.checkGemVersion': v:false,
      \ 'languageserver': {
      \   'ccls': {
      \     'command': 'ccls',
      \     'filetypes': [ 'c', 'cpp' ],
      \     'rootPatterns': g:root_patterns.c,
      \     'initializationOptions': {
      \       'cache': {
      \         'directory': '/tmp/ccls',
      \       },
      \     },
      \   },
      \   'openscad': {
      \     'command': "$HOME/.cargo/bin/openscad-language-server",
      \     'filetypes': [ 'openscad' ],
      \   }
      \ },
      \}

for [key, action] in items({
      \ ']}': 'jumpDefinition',
      \ 'dD': 'jumpDeclaration',
      \ 'iI': 'jumpImplementation',
      \ 'tT': 'jumpTypeDefinition',
      \ 'rR': 'jumpReferences',
      \})
  exe printf('nnoremap <silent><space>%s :<C-U>call tag#push(expand("<cword>"), { -> CocAction("%s") })<CR>', key[0], action)
  exe printf('nnoremap <silent><space>%s :<C-U>call tag#push(expand("<cword>"), { -> CocAction("%s", "Split") })<CR>', key[1], action)
endfor

nmap <space>q <Plug>(coc-format-selected)
xmap <space>q <Plug>(coc-format-selected)
nnoremap <space>k :<C-U>call CocAction('doHover')<CR>
nnoremap <space>pe :<C-U>PP CocAction('extensionStats'),'id','state','version','isLocal','exotic'<CR>
nnoremap <space>ps :<C-U>PP CocAction('sourceStat'),'name','shortcut','priority','type','disabled'<CR>

let g:endwise_no_mappings = 1
inoremap <silent><expr><Tab>   pumvisible() ? '<C-N>' : get(g:, 'coc_process_pid') ? coc#refresh() : '<C-X><C-O>'
inoremap <silent><expr><S-Tab> pumvisible() ? '<C-P>' : '<S-Tab>'
inoremap <silent><expr><CR>    pumvisible() ? '<C-Y>' : '<C-G>u<CR><C-R>=EndwiseDiscretionary()<CR>'
inoremap <silent><expr><Del>   pumvisible() ? '<C-E>' : '<Del>'

" -- CHEATSHEET ----------------------------------------------------------- {{{2

let g:cheatsheet_filetype_redirect = {
      \ 'sh': 'bash',
      \ }
let g:cheatsheet_subtype_redirect = {
      \ 'conf' : {
        \ 'kwmrc': 'kwm',
        \ 'Xorg.conf': 'xorgconf',
        \ '.tmux.conf': 'tmux',
        \ '.gitignore': 'git'
        \ },
      \ 'gitconfig' : {
        \ '.gitconfig' : 'git'
        \ },
      \ 'json' : {
        \ '.tern-project' : 'tern',
        \ '.tern-config' : 'tern'
        \ },
      \ 'lua': {
        \ 'rc.lua' : 'awesome'
        \ },
      \ 'ruby' : {
        \ 'Gemfile': 'ruby-bundler',
        \ 'Guardfile': 'ruby-guard'
        \ }
      \ }

" -- PROJECTIONIST -------------------------------------------------------- {{{2

let g:projectionist_heuristics = projectionist_extra#expand({
    \ 'README.md': {
    \ },
    \ 'CMakeLists.txt|Makefile': {
    \   'CMakeLists.txt': {
    \     'type': 'cmake'
    \   },
    \   '*.c': {
    \     'alternate': '{}.h'
    \   },
    \   '*.cpp|*.cc|*.cxx': {
    \     'alternate': ['{}.h', '{}.hpp', '{}.hxx']
    \   },
    \   '*.h' : {
    \     'alternate': ['{}.c', '{}.cc', '{}.cpp', '{}.cxx']
    \   }
    \ },
    \ 'package.json': {
    \   'package.json'   : { 'type': 'package' },
    \   'jsconfig.json'  : { 'type': 'jsconfig' },
    \   '.eslintrc'      : { 'type': 'eslint' },
    \   'spec/*_spec.js' : { 'type': 'test', 'alternate': 'src/{}.js' },
    \   'src/*.js'       : { 'type': 'src', 'alternate': 'spec/{}_spec.js' },
    \ },
    \ 'doc/&autoload/': {
    \   'plugin/*.vim'   : { 'type': 'plugin', 'alternate': 'test/plugin/{}.vader' },
    \   'autoload/*.vim' : { 'type': 'autoload', 'alternate': 'test/autoload/{}.vader' },
    \   'test/*.vader'   : { 'type': 'test', 'alternate': '{}.vim' },
    \   'doc/*.txt'      : { 'type': 'doc' },
    \ },
    \ 'autoload/&plugged/&plugin/' : {
    \   'plugin/*.vim' : { 'type': 'plugin', 'alternate': 'test/plugin/{}.vader' },
    \   'autoload/*.vim' : { 'type': 'autoload', 'alternate': 'test/autoload/{}.vader' },
    \   'debugrc/*.vim' : { 'type': 'debugrc' },
    \   'test/*.vader' : { 'type': 'test' },
    \   'vimrc' : { 'type': 'rc' }
    \},
  \ })

" -- ALE ------------------------------------------------------------------ {{{2

let g:ale_lint_on_text_changed = 0
let g:ale_sign_error           = g:sym.gutter_error
let g:ale_sign_warning         = g:sym.gutter_warning
let g:ale_sign_info            = g:sym.gutter_info
let g:ale_sign_style_error     = g:sym.gutter_style
let g:ale_sign_style_warning   = g:sym.gutter_style
let g:ale_sign_column_always   = 1
let g:ale_echo_msg_error_str   = g:sym.error
let g:ale_echo_msg_warning_str = g:sym.warning
let g:ale_echo_msg_info_str    = g:sym.info
let g:ale_echo_msg_format      = '%severity% [%linter%] %s'

let g:ale_completion_enabled = 0
let g:ale_linters_explicit = 1

let g:ale_linters = {
      \ 'python':     ['flake8'],
      \ 'sh':         ['shellcheck'],
      \ 'javascript': ['eslint'],
      \ 'ruby':       [],
      \ }

let g:ale_fixers = {
      \ 'python': ['black'],
      \}

let g:ale_c_gcc_options   = join(g:gcc_flags['common'] + g:gcc_flags['c'])
let g:ale_cpp_gcc_options = join(g:gcc_flags['common'] + g:gcc_flags['cpp'])

" temp fix for https://github.com/w0rp/ale/issues/1656#issuecomment-423017658
let g:ale_python_auto_pipenv = 0

" -- TAGBAR --------------------------------------------------------------- {{{2

let g:tagbar_iconchars = [ g:sym.open, g:sym.close ]

" -- JSX ------------------------------------------------------------------ {{{2

" jsx highlight
let g:vim_jsx_pretty_enable_jsx_highlight = 1

" -- VIM-RUBY ------------------------------------------------------------- {{{2
"
" loads/evaluates code to provide completion
let g:rubycomplete_buffer_loading = 1
" parses entire buffer to add a list of classes to the completion results
let g:rubycomplete_classes_in_global = 1
" detect and load the Rails env
let g:rubycomplete_rails = 1
" parse a Gemfile, in case gems are being implicitly required
let g:rubycomplete_load_gemfile = 1

let g:ruby_no_expensive = 1

" -- VIM TABLE MODE ------------------------------------------------------- {{{2

let g:table_mode_verbose = 0

let g:table_mode_disable_mappings = 1

" Markdown-compatible tables
let g:table_mode_corner = '+'

" -- CALENDAR ------------------------------------------------------------- {{{2

let g:calendar_monday = 1
let g:calendar_wruler = join(g:sym.day, ' ')

" -- MARKDOWN ------------------------------------------------------------- {{{2

let g:markdown_fenced_languages = [
      \ 'c',
      \ 'cmake',
      \ 'ruby',
      \ 'eruby',
      \ 'sh'
      \ ]

" -- VIMWIKI -------------------------------------------------------------- {{{2

" :he vimwiki-local-options
let g:vimwiki_list = [
      \{ 'path': '~/.vimwiki/' }
      \]
" fold on sections and code blocks
let g:vimwiki_folding = 'expr'

let g:taskwiki_suppress_mappings = 'yes'
let g:vimwiki_key_mappings = { 'all_maps': 0 }

let g:vimwiki_global_ext = 0

FtKey 'vimwiki', 'Follow link/split/split-keep/back', '<CR>/<S-CR>/<C-CR>/<BS>'
FtKey 'vimwiki', 'Next/Prev link', '<Tab>/<S-Tab>'

FtKey 'vimwiki', 'Toggle list item', '<C-Space>'
FtKey 'vimwiki', 'Add/Remove header level', '=/-'
FtKey 'vimwiki', 'Goto Prev/Next Header, Prev/Next Sibling Header', '[[ ]] [= ]='

" -- GIT GUTTER ----------------------------------------------------------- {{{2

let g:gitgutter_sign_added                   = g:sym.gutter_added
let g:gitgutter_sign_modified                = g:sym.gutter_modified
let g:gitgutter_sign_removed                 = g:sym.gutter_removed
let g:gitgutter_sign_removed_first_line      = g:sym.gutter_removed_first_line
let g:gitgutter_sign_removed_above_and_below = g:sym.gutter_removed_above_below
let g:gitgutter_sign_modified_removed        = g:sym.gutter_modified_removed

let g:gitgutter_override_sign_column_highlight = 0

" -- SPEEDDATING ---------------------------------------------------------- {{{2

let g:speeddating_no_mappings = 1

nmap + <Plug>SpeedDatingUp
nmap - <Plug>SpeedDatingDown
xmap + <Plug>SpeedDatingUp
xmap - <Plug>SpeedDatingDown

nmap d+ <Plug>SpeedDatingNowUTC
nmap d- <Plug>SpeedDatingNowLocal

nnoremap <Plug>SpeedDatingFallbackDown <C-X>
nnoremap <Plug>SpeedDatingFallbackUp <C-A>

xnoremap g+ g<C-A>
xnoremap g- g<C-X>

" -- REPEAT --------------------------------------------------------------- {{{2

if has_key(g:plugs, 'vim-repeat')
  exe 'source' g:plugs['vim-repeat'].dir..'/autoload/repeat.vim'
  nmap . <Plug>(RepeatDot)
  nmap u <Plug>(RepeatUndo)
  nmap U <Plug>(RepeatUndoLine)
  nmap <C-R> <Plug>(RepeatRedo)
endif

" -- TABLE MODE ----------------------------------------------------------- {{{2

omap a<Bar> <Plug>(table-mode-cell-text-object-a)
xmap a<Bar> <Plug>(table-mode-cell-text-object-a)
omap i<Bar> <Plug>(table-mode-cell-text-object-i)
xmap i<Bar> <Plug>(table-mode-cell-text-object-i)

nmap <leader>tdr <Plug>(table-mode-delete-row)
nmap <leader>tdc <Plug>(table-mode-delete-column)
nmap <leader>ts  <Plug>(table-mode-sort)

nnoremap <leader>tc :TableModeInsert<space>

" -- SURROUND ------------------------------------------------------------- {{{2

xmap <leader>s <Plug>VSurround
imap <leader>s <Plug>Isurround
imap <leader>S <Plug>ISurround

" -- COMMENTARY EXTENSION ------------------------------------------------- {{{2

nnoremap <silent> gC :set opfunc=toggle#Comments<CR>g@
xnoremap <silent> gC :<C-U>call toggle#Comments(v:true)<CR>

" -- FILTER --------------------------------------------------------------- {{{2

let g:filter_options = {
      \ 'use_commentstring': v:true,
      \}
let g:filter_commands = {
      \ 'dot': [ '/bin/sh', '-c', get(glob('~/.plenv/versions/*/bin/graph-easy', v:false, v:true), -1, 'false')..' --output={o} --as=ascii {i}' ],
      \}

" -- IMOTION -------------------------------------------------------------- {{{2

let g:imotion_mappings = {
  \ 'nxo': {
  \   ']<Tab>': 'NextSection',
  \   '[<Tab>': 'PrevSection',
  \   ']<S-Tab>': 'NextSectionWithBlank',
  \   '[<S-Tab>': 'PrevSectionWithBlank',
  \   ']=': 'NextSame',
  \   '[=': 'PrevSame',
  \   'H': 'RevPrevLess',
  \   'L': 'NextMore',
  \   'M': 'OpenSection',
  \   ']b': 'NextBlock',
  \   '[b': 'PrevBlock',
  \   ']B': 'NextBlockWithBlank',
  \   '[B': 'PrevBlockWithBlank',
  \ },
  \ 'xo': {
  \   'ii': 'SurroundingOpenSection',
  \   'ai': 'SurroundingOpenSectionWithBlank',
  \   'iI': 'SurroundingSection',
  \   'aI': 'SurroundingSectionWithBlank',
  \ },
  \}

" -- PANDOC --------------------------------------------------------------- {{{2

" remove foldcolumn
let g:pandoc#folding#fdc = 0
let g:pandoc#spell#default_langs = ['en_us', 'nb']
let g:pandoc#syntax#conceal#use = 0

" }}}1

catch
  set runtimepath&
  let g:throwpoint = v:throwpoint
  let g:exception = v:exception
  exe "source "..$MYVIMHOME.."/plugin/should_be_builtin.vim"
  let g:error = Error()

  au VimEnter * cexpr g:error
endtry
