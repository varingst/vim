let $PATH = $HOME."/.vim/bin:".$PATH

" == PLUG ================================================================= {{{1
call plug_extend#begin({
      \ 'local_paths': '~/dev/',
      \ 'local_users': 'varingst',
      \ 'formats': {
      \   'b': 'git@bitbucket.org:%s.git',
      \ }
      \})

" -- Bling ---------------------------------------------------------------- {{{2

Plug 'vim-airline/vim-airline'
Plug 'markonm/traces.vim'

" -- Programmer QoL ------------------------------------------------------- {{{2

Plug 'mileszs/ack.vim'
Plug 'varingst/ack-extend'
Plug 'varingst/no_history_search.vim'
Plug 'majutsushi/tagbar', { 'on' : 'TagbarToggle' }
Plug 'junegunn/fzf.vim'
Plug 'KabbAmine/zeavim.vim'

Plug 'junegunn/vim-easy-align'
Plug 'varingst/vim-skeleton', { 'local': 'vim-skeleton-fork' }
Plug 'tpope/vim-projectionist'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" lsp
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

" ale
Plug 'w0rp/ale'
Plug 'varingst/ale-silence'

" asynccomplete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'yami-beta/asyncomplete-omni.vim'
Plug 'Shougo/neco-syntax'
Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
Plug 'prabirshrestha/asyncomplete-necovim.vim'

" -- Language Extras ------------------------------------------------------ {{{2

Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'sheerun/vim-polyglot'

Plug 'jdonaldson/vaxe'

Plug 'kana/vim-vspec'
Plug 'junegunn/vader.vim'

" -- Tim Pope obviously --------------------------------------------------- {{{2

Plug 'tpope/vim-surround'         " XML tags, brackets, quotes, etc
Plug 'tpope/vim-speeddating'      " increment/decrement dates +++
Plug 'tpope/vim-endwise'          " autoadd closing symbols (end/endif/endfun)
Plug 'tpope/vim-dispatch'         " Run builds and test suites
Plug 'tpope/vim-repeat'           " make '.' handle plugins nicer
Plug 'tpope/vim-abolish'          " Smarter substitution ++
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-commentary'

" Ruby snaxx
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rbenv'            " Tell vim to use the right ruby
Plug 'tpope/gem-ctags'            " RubyGems Automatic Ctags Invoker

" -- Vim motions and objects ---------------------------------------------- {{{2

Plug 'vim-scripts/camelcasemotion'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'michaeljsmith/vim-indent-object'
Plug 'varingst/vim-indent-object', { 'local': 'vim-indent-objects' }
Plug 'varingst/vim-text-objects'
Plug 'varingst/vim-superg'

" -- Markup, Template, Formatting, et al ---------------------------------- {{{2


" Todo/Project
Plug 'vim-scripts/SyntaxRange'
Plug 'mattn/calendar-vim'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'tbabej/taskwiki'

Plug 'dhruvasagar/vim-table-mode'

Plug 'rhysd/vim-grammarous'

Plug 'ledger/vim-ledger'

" -- Homerolled ----------------------------------------------------------- {{{2

for proto in glob('~/.vim/proto/*', v:false, v:true)
  call plug#(proto)
endfor

" }}}

call plug#end()

runtime macros/matchit.vim


" == SYMBOLS ============================================================== {{{1

let g:sym = {
      \ 'line':                      '行',
      \ 'error':                     '誤',
      \ 'warning':                   '戒',
      \ 'info':                      '注',
      \ 'nothing':                   '無',
      \ 'correct':                   '正',
      \ 'incorrect':                 '歪',
      \ 'normal':                    '常',
      \ 'insert':                    '挿',
      \ 'replace':                   '代',
      \ 'command':                   '令',
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
      \ 'bug':                       '虫',
      \ 'table':                     '表',
      \ 'open':                      '+',
      \ 'close':                     '-',
      \ 'whitespace_trailing':       '§',
      \ 'whitespace_tab':            '›',
      \ 'whitespace_tab_pad':        ' ',
      \ 'whitespace_nobreak':        '¬',
      \ 'nowrap_precedes':           '‹',
      \ 'nowrap_extends':            '›',
      \ 'fill_vert':                 ' ',
      \ 'fill_fold':                 ' ',
      \ 'fill_end_of_buffer':        ' ',
      \ 'fill_diff_removed':         ' ',
      \ 'gutter_error':              '»',
      \ 'gutter_warning':            '›',
      \ 'gutter_info':               '°',
      \ 'gutter_added':              '·',
      \ 'gutter_modified':           '–',
      \ 'gutter_removed':            '…',
      \ 'gutter_removed_first_line': '¨',
      \ 'gutter_removed_above_below':'‹',
      \ 'gutter_modified_removed':   '¬',
      \ 'no_coverage':               '`',
      \ 'num': split('零壱弐三四五六七八九', '\zs'),
      \ 'day': split('日月火水木金土', '\zs')
      \ }

" == OPTIONS ============================================================== {{{1

augroup highlight-overrides
  au!
  autocmd ColorScheme * highlight ALEWarningSign    ctermfg=166
        \             | highlight SpellBad          ctermfg=166               cterm=underline
        \             | highlight DiffAdd           ctermfg=NONE ctermbg=NONE cterm=NONE
        \             | highlight DiffChange        ctermfg=NONE ctermbg=0    cterm=NONE
        \             | highlight DiffDelete        ctermfg=NONE ctermbg=NONE cterm=NONE
        \             | highlight DiffText          ctermfg=NONE ctermbg=NONE cterm=underline
augroup END

set background=dark
let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
let g:solarized_menu = 0
colorscheme solarized

set number
set scrolloff=5
set wildmenu
set wildmode=longest:list
set nomore
set shortmess+=c
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

set history=1000
set undolevels=1000

set hlsearch
nohlsearch
set incsearch
set ignorecase
set smartcase
set magic
set hidden

set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set foldmethod=marker
set foldtext=printf('%s%3d\ %s',get(g:sym.num,v:foldlevel,v:foldlevel),(v:foldend-v:foldstart),getline(v:foldstart))
set diffopt+=foldcolumn:0
set backspace=2
set list
let &g:listchars = join([
      \ 'tab:'        .g:sym.whitespace_tab.g:sym.whitespace_tab_pad,
      \ 'trail:'      .g:sym.whitespace_trailing,
      \ 'nbsp:'       .g:sym.whitespace_nobreak,
      \ 'precedes:'   .g:sym.nowrap_precedes,
      \ 'extends:'    .g:sym.nowrap_extends
      \  ], ',')
let &g:fillchars = join([
      \ 'vert:'       .g:sym.fill_vert,
      \ 'fold:'       .g:sym.fill_fold,
      \ 'diff:'       .g:sym.fill_diff_removed,
      \ 'eob:'        .g:sym.fill_end_of_buffer,
      \ ], ',')

set conceallevel=2
set concealcursor=nc

set nowrap
set textwidth=80
set formatoptions=cqj
set synmaxcol=128
set signcolumn=yes
set iskeyword=@,48-57,_,192-255,-
set viewoptions=cursor,folds
set spelllang=en_us

set ttyfast
set lazyredraw

let g:netrw_browsex_viewer = 'xdg-open'
let g:vimsyn_embed = 0 " no embedded perl, lua, ruby, etc syntax in .vim files

" == AUTOCOMMANDS ========================================================= {{{1

augroup vimrc_autocmd
  autocmd!
  " auto save and load folds, options, and cursor
  au BufWinLeave *.* mkview
  au BufWinEnter *.* silent! loadview

  au FileType gitcommit,qf wincmd J | setlocal relativenumber | setlocal signcolumn=no

  " Dont show tabs in vim help, vsplit if space available
  au FileType help setlocal nolist | if winwidth('.') > 140 | wincmd L | endif

  exe 'au BufWinEnter '.join([
        \ '~/.vimrc',
        \ '~/.config/nvim/init.vim',
        \ '~/.vim/init.vim',
        \ '~/.vim/autoload/f.vim',
        \ ], ','). ' call f#VimRcExtra()'

  au BufWinEnter ~/.vimrc cd ~/.vim | call FugitiveDetect(expand('~/.vim'))

  au BufWritePre * if '<afile>' !~? '^scp:' && !isdirectory(expand('<afile>:h'))
        \        |   call mkdir(expand('<afile>:h'), 'p')
        \        | endif

  au BufWritePost * if empty(&filetype) && expand('<afile>:t') !~# '\.' && getline(1) =~# '^#!'
        \         |   filetype detect
        \         |   call setfperm(expand('<afile>'),
        \                           substitute(getfperm(expand('<afile>')),
        \                                      '\(r[w-]\)-', '\1x', 'g'))
        \         | endif

  au BufReadPost,FileReadPost,BufNewFile,WinEnter * call f#SetTmuxWindowTitle()
  au VimLeave * call f#SetTmuxWindowTitle(v:true)

  au VimEnter * nnoremap <silent><ESC> :nohlsearch<CR><ESC>

  au User lsp_setup          call f#lsp_setup(g:lsp_servers)
  au User ALEWantResults     call f#handle_diagnostics(g:ale_want_results_buffer)
  au User asyncomplete_setup call f#acomp_setup(g:completion_sources)

augroup END

" == KEY MAPPING ========================================================== {{{1

" ~/.vim/autoload/keys.vim
call keys#init()
nnoremap <C-B> :call keys#list()<CR>

map ; <nop>
let g:mapleader = ';'

map , <nop>
let g:maplocalleader = ','

" -- KeyCodes ------------------------------------------------------------- {{{2

KeyCodes {
      \ '<C-;>':      ';',
      \ '<CR>':       ['13;2u', '13;5u', '13;6u'],
      \ '<Up>':       ['1;2A',  '1;5A',  '1;6A'],
      \ '<Down>':     ['1;2B',  '1;5B',  '1;6B'],
      \ '<Right>':    ['1;2C',  '1;5C',  '1;6C'],
      \ '<Left>':     ['1;2D',  '1;5D',  '1;6D'],
      \ '<Home>':     ['1;2H',  '1;5H',  '1;6H'],
      \ '<End>':      ['1;2F',  '1;5F',  '1;6F'],
      \ '<PageUp>':   ['5;2~',  '5;5~',  '5;6~'],
      \ '<PageDown>': ['6;2~',  '6;5~',  '6;6~'],
      \}

" -- Various Normal ------------------------------------------------------- {{{2

nnoremap <C-;> :
" prevent editing from fumbling with tmux key
nnoremap <C-A> <nop>
" line/column guides
nnoremap ^ :<C-U>call f#crosshair(v:count1)<CR>
" insert on N additional lines
nnoremap <expr> I v:count ? '<ESC><C-V>'.(v:count).'jI' : 'I'
" replace with char in current column for N additional lines
nnoremap <expr> r v:count ? '<ESC><C-V>'.(v:count).'jr' : 'r'
" blockwise visual select paragraph from current column to end of line
nnoremap <leader><C-V> <C-V>}k$
" lookup keyword under cursor with 'keywordprg'
nnoremap <leader>k K

" jump to sinful whitespace
nnoremap <expr><leader><space>
      \ get(filter(split(get(b:, 'airline_whitespace_check', ''),
      \                  '\D'),
      \            'strlen(v:val)'),
      \     0,
      \     line('.')
      \).'G'

" -- Various Insert ------------------------------------------------------- {{{2

" terminal sends ^@ on <C-Space>
inoremap <C-@> <C-Space>

" fire InsertLeave even on <C-C>
inoremap <C-C> <ESC>

" like i_<C-W> but to the right
inoremap <C-L> <C-O>dw
" like i_<C-U> but to end of line, rather than start
inoremap <C-;> <C-O>d$
" like i_<C-W> but stop at snake_case/camelCase boundaries
inoremap <C-E> <C-O>dv?^\<BAR>_\<BAR>\u\<BAR>\<\<BAR>\s<CR>
" like i_<C-W> but WORD rather than word
inoremap <C-Q> <C-O>dB
inoremap <C-B> <ESC>:let @b = @.<CR>a

inoremap <leader><C-V> <C-V>

for pair in ['()', '{}', '[]']
  execute printf('imap <leader>%s <Plug>Isurround%s', pair[0], pair[1])
  execute printf('imap <leader>%s <Plug>ISurround%s<C-T>', pair[1], pair[0])
endfor

" -- Various Visual ------------------------------------------------------- {{{2

xnoremap <expr>J ":move '>+".v:count1."\<CR>gv"
xnoremap <expr>K ":move '<-".(v:count1+1)."\<CR>gv"
xnoremap <expr>M ":move ".(superg#(line('.'), v:count1) - 1)."\<CR>"

" -- Various Command ------------------------------------------------------ {{{2

cnoremap w!! w !sudo tee % > /dev/null
cnoremap e!! silent Git checkout -- % <BAR> redraw!
cnoremap r!! Read<space>
cnoremap <C-;> %:h
cnoremap <C-K> <up>
cnoremap <C-J> <down>
cnoremap <C-V> <HOME><S-Right><Right><C-W>vsplit<space><END>
cnoremap <C-X> <HOME><S-Right><Right><C-W>split<space><END>

" -- Various Window ------------------------------------------------------- {{{2

" go to last accessed window, like tmux
nnoremap <C-W>; <C-W>p

" set window width to 90/180 columns
nnoremap <C-W>i <ESC>90<C-W><BAR>
nnoremap <C-W>I <ESC>180<C-W><BAR>

" swap window with window <count>
nnoremap <C-W>p :<C-U>call f#SwapWindow(v:count1)<CR>

" close window <count>, or current window
nnoremap <expr> <C-W>x (v:count ? v:count."\<C-W>w\<BAR>" : "").":close\<CR>"
" delete buffer in window <count>, or current window
nnoremap <expr> <C-W>X (v:count ? v:count."\<C-W>w\<BAR>" : "").":bd\<CR>"

" move cursor to window
for i in range(1, 9)
  exe printf('nnoremap <C-W>%d <ESC>%d<C-W>w', i, i)
endfor

" -- Various Operators ---------------------------------------------------- {{{2

call op#map('<leader>R', 'op#replace')
call op#map('<leader>D', 'op#double')
call op#map('S', 'op#substitute')

" -- Various Text Objects ------------------------------------------------- {{{2

" n-1 lines, linewise
xnoremap <silent><expr> <space> printf("\<ESC>V%d_", v:count1)
onoremap <silent>       <space> _

" -- Various Abbr --------------------------------------------------------- {{{2

iabbr #! #!/usr/bin/env

" -- Arrowkeys/Buffernav -------------------------------------------------- {{{2

nmap <expr><Left>  v:count ? '<C-W><' : '<Plug>AirlineSelectPrevTab'
nmap <expr><Right> v:count ? '<C-W>>' : '<Plug>AirlineSelectNextTab'

for i in range(1, 9)
  exe printf('nmap <leader>%d <Plug>AirlineSelectTab%d', i, i)
endfor

nmap <Up>      <Plug>LPrev
nmap <Down>    <Plug>LNext
nmap <S-Up>    <Plug>CPrev
nmap <S-Down>  <Plug>CNext

nmap <expr><C-Left>  get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-left)'  : '<C-W>h'
nmap <expr><C-Right> get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-right)' : '<C-W>l'
nmap <expr><C-Up>    get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-up)'    : '<C-W>k'
nmap <expr><C-Down>  get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-down)'  : '<C-W>j'

" -- Completion ----------------------------------------------------------- {{{2


inoremap <expr><Tab>   pumvisible() ? "\<C-N>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-P>" : "\<S-Tab>"
imap <expr><CR>        pumvisible() ? "\<C-Y>\<CR>" : "\<CR>\<Plug>DiscretionaryEnd"

for i in range(2, 9)
  exe printf("inoremap <expr> <leader>%d pumvisible() ? repeat('<C-N>', %d) : '%d'", i, i-1, i)
endfor


" -- Set fold markers ----------------------------------------------------- {{{2

Key 'Set foldlevel with marker', 'z<0-4>'
nnoremap z0 :call f#SetFoldMarker(0)<CR>
nnoremap z1 :call f#SetFoldMarker(1)<CR>
nnoremap z2 :call f#SetFoldMarker(2)<CR>
nnoremap z3 :call f#SetFoldMarker(3)<CR>
nnoremap z4 :call f#SetFoldMarker(4)<CR>


" -- Awkward symbol shorthands -------------------------------------------- {{{2
inoremap ,. ->
inoremap ., <-
inoremap ,, =>
inoremap _+ >=
inoremap +_ <=

inoremap ƒ function

" -- Swap quotes ---------------------------------------------------------- {{{2

map <leader>' cs"'
map <leader>" cs'"

" -- Code Search ---------------------------------------------------------- {{{2

let g:no_history_search_prepend = '\<'
map / <Plug>(no-history-/)
map ? <Plug>(no-history-?)

noremap <space>/ /
noremap <space>? ?

nnoremap <space>f :Files<CR>
nnoremap <space>F :GFiles<CR>
nnoremap <space>s :Snippets<CR>
nnoremap <space>t :BTags<CR>
nnoremap <space>T :Tags<CR>
nnoremap <space>h :History<CR>

nnoremap <space>v :AV<CR>

nnoremap <space>? :nmap <lt>space><CR>

nnoremap <leader>*  :call f#LocalGrep('\<'.expand("<cword>").'\>')<CR>
nnoremap <leader>#  :call f#LocalGrep('\<'.expand("<cword>").'\>')<CR>
nnoremap <leader>g* :call f#LocalGrep(expand("<cword>"))<CR>
nnoremap <leader>g# :call f#LocalGrep(expand("<cword>"))<CR>
nnoremap <leader>/ :LocalGrep<space>

nnoremap <leader>a :Ack<space>

" -- Open file under cursor in split window ------------------------------- {{{2

nnoremap <expr><silent>gf (winwidth('.') > 140 ? ':vsplit' : ':split')."\<CR>gf"

" -- Fun with o ----------------------------------------------------------- {{{2

Key 'yank {motion} from start of current line into @o',  '<leader>o'
Key 'yank current line until . to @o, put on next line', '<leader>o', 'i'

" open line above
inoremap <C-O><C-O> <C-O>O
inoremap <silent><leader>o <ESC>^:set opfunc=op#copyO<CR>g@
call op#map('<leader>o', 'op#copyO')

vnoremap <expr>O line('.') == line("'<")
      \ ? "o\<ESC>o\<ESC>gvo"
      \ : "o\<ESC>O\<ESC>gvo"

" -- Normal jkJKHL -------------------------------------------------------- {{{2

" j/k on visual lines, not actual lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" navigate folds with J/K
nnoremap <expr> J foldlevel('.') && foldclosed('.') != -1 ? 'zo' : 'zj'
nnoremap <expr> K foldlevel('.') && foldclosed('.') == -1 ? 'zc' : 'gk'

noremap <expr> H getcharsearch().forward ? ',' : ';'
noremap <expr> L getcharsearch().forward ? ';' : ','

" -- System Clipboard ----------------------------------------------------- {{{2

inoremap <C-V> <C-O>"+p
vnoremap <C-C> "+y
vnoremap <C-X> "+d

" -- Sticky Shift Camel Case Relief --------------------------------------- {{{2

Key 'Downcase last uppercase letter', '<leader>u', 'ni'
nnoremap <silent><leader>u m`:keeppatterns s/.*\zs\(\u\)/\L\1/e<CR>``
inoremap <silent><leader>u <ESC>:keeppatterns s/.*\zs\(\u\)/\L\1/e<CR>`^i

" -- Line join/break ------------------------------------------------------ {{{2

Key 'join <count> lines/paragraph', '<leader>j/J'
nnoremap <leader>j J
nnoremap <leader>J v}J

Key 'Break/Join function arguments', '<leader>f/F'
nnoremap <silent><leader>f 0f(:let c=col('.')-1<CR>:keeppatterns s/,/\=",\r".repeat(' ', c)/ge<CR>
nnoremap <silent><leader>F 0f(v%J

Key 'Break/Join XML attributes',   '<leader>x/X'
nnoremap <silent><leader>x :keeppatterns s/\(<\w\+\\|\w\+=\({[^}]*}\\|"[^"]*"\\|'[^']*'\)\)\s*/\1\r/ge<CR>:redraw<CR>='[
nnoremap <silent><leader>X v/\/\?><CR>J:keeppatterns s/\s\(\/\?>\)/\1/<CR>

" -- EasyAlign ------------------------------------------------------------ {{{2

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

xmap <bar> <Plug>(EasyAlign)ip
nmap <bar> <Plug>(EasyAlign)ip

Key '(EasyAlign) Align operator',  'ga', 'nv'
Key '(EasyAlign) inner paragraph', 'ip',  'nv'

" -- ZeaVim --------------------------------------------------------------- {{{2
"
Key '(Zeavim) Search word under cursor', '<leader>z', 'nv'
Key '(Zeavim) Search motion operator',   'gz'
Key '(Zeavim) Docset',                   '<leader><leader>z'

" don't know why these don't work in config

nmap <leader>z <Plug>Zeavim
vmap <leader>z <Plug>ZVVisSelection
nmap <leader><leader>z <Plug>ZVKeyDocset
nmap gz <Plug>ZVOperator


" -- Fkeys ---------------------------------------------------------------- {{{2

FKeys {
  \ '<F1>':           ':call keys#flist()',
  \ '<F2>':           ':call f#LocListToggle()',
  \ '<F4>':           ':TagbarToggle',
  \ '<F5>':           ':CheatSheet',
  \ '<F6>':           ':call f#AutoCompletionToggle()',
  \ '<F8>':           ':call f#PreviewHunkToggle()',
  \ '<F9>':           ':Gstatus',
  \ '<F10>':          ':Dispatch',
  \ '<F11>':          ':Make',
  \ '<leader><F1>':   ':set wrap!',
  \ '<leader><F2>':   ':call f#QuickFixFlush()',
  \ '<leader><F3>':   ':TableModeToggle',
  \ '<leader><F5>':   ':call f#ConcealToggle()',
  \ '<leader><F6>':   ':call f#ColorColumnToggle()',
  \ '<leader><F8>':   ':call f#GdiffToggle()',
  \ '<leader><F9>':   ':Gcommit --all',
  \ '<leader><F10>':  ':Dispatch!',
  \ '<leader><F11>':  ':Make!'
  \ }


" == COMMANDS ============================================================= {{{1

command! -nargs=? ReplaceEach  silent call f#ReplaceEach(<q-args>)
command! -nargs=1 Profile      silent call f#Profile(<q-args>)
command! -nargs=* LocalGrep    silent call f#LocalGrep(<q-args>)
command! -nargs=* Date         read !date --date=<q-args> "+\%Y-\%m-\%d"

command! -nargs=0 -range Hex2Rgb <line1>,<line2>s/#\(\x\+\)/\='rgb'.(strlen(submatch(1))==6?'(':'a(').join(map(split(submatch(1),'\x\{2}\zs'),{_,x->str2nr(x,16)}),', ').')'/ge
command! -nargs=0 -range Rgb2Hex <line1>,<line2>s/\(rgba\?\)(\([^)]*\))/\=call('printf',['#'.repeat('%X',strlen(submatch(1)))]+split(submatch(2),'\s*,\s*'))/ge

" diff file and buffer, see :he :DiffOrig
command! -nargs=0 DiffOrig vert new
                       \ | set bt=nofile
                       \ | r++edit #
                       \ | 0d_
                       \ | diffthis
                       \ | wincmd p
                       \ | diffthis

" run diffs in tabs for each modified file
command! -nargs=? GitDiffs for f in systemlist(
                       \       'git diff --name-only --diff-filter=AM '.
                       \       (empty(<q-args>) ? "HEAD~1" : <q-args>))
                       \ |   execute '$tabnew '.f
                       \ |   execute 'Gvdiff '.(empty(<q-args>) ? "HEAD~1" : <q-args>)
                       \ | endfor

" close all open non-dirty buffers
command! -nargs=0 CloseBuffers for buf in getbufinfo({ 'listed': 1 })
                           \ |   if !buf.changed && empty(buf.windows)
                           \ |     exe 'bdelete '.buf.bufnr
                           \ |   endif
                           \ | endfor

" write loaded scripts to file and open
command! -nargs=1 ScriptNames call writefile(split(execute('scriptnames'), "\n"),
                          \                  expand(<q-args>))
                          \ | exe printf("%s %s",
                          \          winwidth('.') > 140 ? 'vsplit' : 'split',
                          \          <q-args>)

" echo syntax stack for what's under the cursor
command! -nargs=0 SynStack echo join(map(synstack(line('.'), col('.')),
      \                                  'synIDattr(v:val, "name")'),
      \                              "\n")

" append output of given shell command or current line
command! -nargs=? Read silent call
      \ append(line('.'),
      \        systemlist(strlen(<q-args>)
      \                   ? <q-args>
      \                   : substitute(getline('.'), '^\$ *', '', '')))

" open file with xdg-open
command! -nargs=? -complete=file Open silent call
      \ netrw#BrowseX(expand(strwidth(<q-args>) ? <q-args> : '%'),
      \               netrw#CheckIfRemote())

command! -nargs=1 -complete=file Move call mkdir(fnamemodify(<q-args>, ":p:h"), "p")
                                  \ | let bufname = expand('%')
                                  \ | call rename(bufname, <q-args>)
                                  \ | exe 'e '.<q-args>
                                  \ | exe 'bdelete '.fnameescape(bufname)

" open vim function definition, default previous with error
command! -nargs=? -complete=function Function silent execute
      \ (winwidth('.') < 140 ? 'split' : 'vsplit').' +'.
      \   join(
      \     reverse(
      \       matchlist(
      \         execute('verbose function '
      \           .substitute(
      \             strlen(<q-args>)
      \             ? <q-args>
      \             : get(filter(map(split(execute('messages'), '\n'),
      \                              {_, m -> matchstr(m, 'processing function \zs[^:]*\ze')}),
      \                          {_, f -> strlen(f) }),
      \                   -1, ''),
      \             '(.*$', '', '')),
      \         'Last set from \(\S\+\) line \(\d\+\)')[1:2]))

" insert NxM table
command! -nargs=+ TableModeInsert
      \   let args = map(split(expand(<q-args>)), 'str2nr(v:val)')
      \ | let cols = get(args, 0, 2)
      \ | let lines = [ repeat('|-', cols).'|' ]
      \ | for i in range(get(args, 1, 2))
      \ |   call add(lines, repeat('| ', cols).'|')
      \ |   call add(lines, repeat('|-', cols).'|')
      \ | endfor
      \ | exe 'TableModeEnable'
      \ | call append(line('.'), lines)

command! -nargs=0 -range=% StripAnsi <line1>,<line2>s/\[\(\d\{1,2}\(;\d\{1,2}\)\?\)\?[m\|K]//ge

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

" -- LSP ------------------------------------------------------------------ {{{2

let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 0
let g:lsp_servers = {
      \ 'ruby': {
      \   'cmd': 'solargraph stdio',
      \   'refresh_pattern': '\(\k\+$\|\.$\|>$\|:\zs:$\)',
      \   'keyword_pattern': ':\?\w\+$',
      \ },
      \ 'lua': 'emmylua',
      \ 'clojure': {
      \   'name': 'clj-lsp',
      \   'cmd': 'clojure-lsp',
      \ },
      \ 'css,less,sass': {
      \   'name': 'css-lsp',
      \   'cmd': 'css-languageserver --stdio',
      \   'root_uri': '.git/..',
      \ },
      \ 'c,cpp,objc,objcpp,cc': {
      \   'cmd': 'cquery',
      \   'root_uri': 'compile_commands.json',
      \ },
      \}
      " \ 'javascript,javascript.jsx': {
      " \   'name': 'js@tss',
      " \   'cmd': 'typescript-language-server --stdio',
      " \ },

" -- COMPLETION ------------------------------------------------------- {{{2

let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_smart_completion = 1
let g:asyncomplete_log_file = '/tmp/asyncomplete.log'
let g:completion_sources = {
      \ 'buffer': {
      \   'blacklist': [
      \     'go',
      \     'ruby',
      \   ],
      \ },
      \ 'file': {
      \   'priority': 10,
      \   'blacklist': [
      \     'ruby',
      \   ],
      \ },
      \ 'omni': {
      \   'blacklist': f#flatten(map(
      \      keys(g:lsp_servers) + [
      \        'ledger',
      \      ], {_, e -> split(e, ',')}))
      \ },
      \ 'necosyntax': {
      \ 'whitelist': ['vim'],
      \ },
      \ 'necovim': {
      \   'whitelist': ['vim'],
      \ },
      \}

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

let g:projectionist_heuristics = f#projectionist({
    \ 'README.md': {
    \ },
    \ 'CMakeLists.txt|Makefile': {
      \ 'CMakeLists.txt': {
      \   'type': 'cmake'
      \ },
      \ '*.c': {
      \   'alternate': '{}.h'
      \ },
      \ '*.cpp|*.cc|*.cxx': {
      \  'alternate': ['{}.h', '{}.hpp', '{}.hxx']
      \ },
      \ '*.h' : {
      \   'alternate': ['{}.c', '{}.cc', '{}.cpp', '{}.cxx']
      \ }
    \ },
    \ 'package.json': {
      \ 'package.json'   : { 'type': 'package' },
      \ 'jsconfig.json'  : { 'type': 'jsconfig' },
      \ '.eslintrc'      : { 'type': 'eslint' },
      \ 'spec/*_spec.js' : { 'alternate': 'src/{}.js' },
      \ 'src/*.js'       : { 'alternate': 'spec/{}_spec.js' },
    \ },
    \ 'doc/&plugin/': {
      \ 'plugin/*.vim'   : { 'alternate': 'test/plugin/{}.vader' },
      \ 'autoload/*.vim' : { 'alternate': 'test/autoload/{}.vader' },
      \ 'doc/*.txt'      : { 'type': 'doc' },
    \ },
  \ })

" -- ALE ------------------------------------------------------------------ {{{2

let g:ale_sign_error           = g:sym.gutter_error
let g:ale_sign_warning         = g:sym.gutter_warning
let g:ale_sign_info            = g:sym.gutter_info
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
      \ 'vim':        [],
      \ 'ruby':       [],
      \ }

let g:ale_c_gcc_options   = join(g:gcc_flags['common'] + g:gcc_flags['c'])
let g:ale_cpp_gcc_options = join(g:gcc_flags['common'] + g:gcc_flags['cpp'])

" temp fix for https://github.com/w0rp/ale/issues/1656#issuecomment-423017658
let g:ale_python_auto_pipenv = 0

" -- AIRLINE -------------------------------------------------------------- {{{2

" remove (fileencoding, fileformat)
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" -- THEME ---------------------------------------------------------------- {{{3

" autoload/airline/themes/motoko.vim
let g:airline_theme = 'motoko'

let g:airline_mode_map = {
  \ '__'  : g:sym.nothing,
  \ 'n'   : g:sym.normal,
  \ 'no'  : g:sym.normal,
  \ 'niI' : g:sym.insert,
  \ 'niR' : g:sym.replace,
  \ 'niV' : g:sym.replace,
  \ 'v'   : g:sym.visual,
  \ 'V'   : g:sym.visual,
  \ ''  : g:sym.visual,
  \ 's'   : g:sym.select,
  \ 'S'   : g:sym.select,
  \ ''  : g:sym.select,
  \ 'i'   : g:sym.insert,
  \ 'ic'  : g:sym.insert,
  \ 'ix'  : g:sym.insert,
  \ 'R'   : g:sym.replace,
  \ 'Rc'  : g:sym.replace,
  \ 'Rv'  : g:sym.replace,
  \ 'Rx'  : g:sym.replace,
  \ 'c'   : g:sym.command,
  \ 'cv'  : g:sym.command,
  \ 'ce'  : g:sym.command,
  \ 'r'   : g:sym.query,
  \ 'rm'  : g:sym.query,
  \ 'r?'  : g:sym.query,
  \ '!'   : g:sym.terminal,
  \ 't'   : g:sym.terminal,
  \}

let g:airline_symbols = extend(get(g:, 'airline_symbols', {}), {
      \ 'branch':    g:sym.branch,
      \ 'paste':     g:sym.paste,
      \ 'linenr':    '',
      \ 'space':     ' ',
      \ 'modified':  g:sym.modified,
      \ 'maxlinenr': g:sym.line,
      \ 'notexists': g:sym.nothing,
      \ 'readonly':  g:sym.readonly
      \})

" extend default mode sections with table mode status
let g:airline_section_a = airline#section#create_left([
      \ 'mode',
      \ ]).
      \ '%{(get(b:, "table_mode_active") ? g:sym.table : "")}'


" extend the default file/path section with some 'auto echo' for debugging
let g:airline_section_c =
      \ '%{get(g:sym.num, winnr(), winnr())}'.
      \ airline#section#create([
      \ '%<',
      \ exists('+autochdir') && &autochdir ? 'path' : 'file',
      \ g:airline_symbols.space,
      \ 'readonly']).
      \ '%{(has_key(g:, "airline_debug") ? (g:sym.bug . g:airline_debug) : "")}'

" percentage, line number, column number
let g:airline_section_z = ''

" vaxe uses this but just expects it to exist
let g:airline_statusline_funcrefs = get(g:, 'airline_statusline_funcrefs', [])

" -- TABLINE -------------------------------------------------------------- {{{3

let g:airline#extensions#tabline#enabled           = 1
let g:airline#extensions#tabline#tab_nr_type       = 1
let g:airline#extensions#tabline#show_tab_type     = 0
let g:airline#extensions#tabline#show_tab_nr       = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_nr_show    = 0
let g:airline#extensions#tabline#buffer_nr_format  = '%s '
let g:airline#extensions#tabline#buffer_idx_mode   = 1
let g:airline#extensions#tabline#buffer_idx_format = {
      \ '0': g:sym.num[0],
      \ '1': g:sym.num[1],
      \ '2': g:sym.num[2],
      \ '3': g:sym.num[3],
      \ '4': g:sym.num[4],
      \ '5': g:sym.num[5],
      \ '6': g:sym.num[6],
      \ '7': g:sym.num[7],
      \ '8': g:sym.num[8],
      \ '9': g:sym.num[9]
      \}


" -- QUICKFIX ------------------------------------------------------------- {{{3

let g:airline#extensions#quickfix#quickfix_text = g:sym.quickfix
let g:airline#extensions#quickfix#location_text = g:sym.location

" -- YCM ------------------------------------------------------------------ {{{3

let g:airline#extensions#ycm#error_symbol   = g:sym.error
let g:airline#extensions#ycm#warning_symbol = g:sym.warning

" -- ALE ------------------------------------------------------------------ {{{3

let g:airline#extensions#ale#enabled           = 1
let g:airline#extensions#ale#error_symbol      = ''
let g:airline#extensions#ale#warning_symbol    = ''
let g:airline#extensions#ale#open_lnum_symbol  = ' '
let g:airline#extensions#ale#close_lnum_symbol = g:sym.line

" -- TAGBAR --------------------------------------------------------------- {{{3

" slow
let g:airline#extensions#tagbar#enabled = 0

" -- GIT GUTTER ----------------------------------------------------------- {{{3

let g:airline#extensions#hunks#enabled = 0

" -- WHITESPACE ----------------------------------------------------------- {{{3

let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#symbol = ''
let g:airline#extensions#whitespace#checks =
      \ [ 'indent', 'trailing', 'mixed-indent-file' ]
let g:airline#extensions#whitespace#trailing_format =
      \ g:sym.whitespace_trailing.'%s'.g:sym.line
let g:airline#extensions#whitespace#mixed_indent_format =
      \ g:sym.whitespace_tab.'%s'.g:sym.line
let g:airline#extensions#whitespace#mixed_indent_file_format =
      \ g:sym.whitespace_tab.g:sym.whitespace_trailing.'%s'.g:sym.line

" -- TAGBAR --------------------------------------------------------------- {{{2

let g:tagbar_iconchars = [ g:sym.open, g:sym.close ]

" -- JSX ------------------------------------------------------------------ {{{2

" jsx highlight
let g:vim_jsx_pretty_enable_jsx_highlight = 1

" -- LATEX ---------------------------------------------------------------- {{{2
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf, aux'
let g:Imap_UsePlaceHolders = 0
let g:Imap_FreezeImap = 1 " Turn off ANNOYING AUTO INPUT CRAP

" -- VIM-RUBY ------------------------------------------------------------- {{{2
" let g:ruby_indent_access_modifyer_style = 'normal' | 'indent' | 'outdent'
"
" let g:ruby_indent_block_style = 'expression' | 'do'
"
" let g:ruby_indent_assignment_style = 'hanging' | 'variable'
"
" loads/evaluates code to provide completion
let g:rubycomplete_buffer_loading = 1
" parses entire buffer to add a list of classes to the completion results
let g:rubycomplete_classes_in_global = 1
" detect and load the Rails env
let g:rubycomplete_rails = 1
" parse a Gemfile, in case gems are being implicitly required
let g:rubycomplete_load_gemfile = 1
" To specify an alternative path:
" let g:rubycomplete_gemfile_path = 'Gemfile.aux'
" To use Bundler.require instead of parsing the Gemfile, seg:
" let g:rubycomplete_use_bundler = 1

" :he ft-ruby-syntax
" highlighting operators
" let ruby_operators = 1
"
" highlight whitespace errors
" let ruby_space_errors = 1
" ruby.vim only tests _existence_ of ruby_fold, not value ..
" let g:ruby_fold = 0
" let ruby_foldable_ground = ' '
" NOTE: cannot set no expensive and use ]m
" let g:ruby_no_expensive = 1

" let ruby_spellcheck_strings = 1

" -- HAXE ----------------------------------------------------------------- {{{2

let g:vaxe_airline_project         = g:sym.correct
let g:vaxe_airline_project_missing = g:sym.incorrect

" -- VIM TABLE MODE ------------------------------------------------------- {{{2

let g:table_mode_verbose = 0

let g:table_mode_disable_mappings = 1

" Markdown-compatible tables
let g:table_mode_corner = '|'

" -- ACK ------------------------------------------------------------------ {{{2
"
let g:ack_exe = 'ag'
let g:ack_default_options =
      \ ' --silent --filename --numbers'.
      \ ' --nocolor --nogroup --column'
let g:ack_options = '--vimgrep'
let g:ack_whitelisted_options = g:ack_options.
      \ ' --literal --depth --max-count --one-device'.
      \ ' --case-sensitive --smart-case --unrestricted'
let g:ack_use_dispatch = 1


" -- CALENDAR ------------------------------------------------------------- {{{2

let g:calendar_monday = 1
let g:calendar_wruler = join(g:sym.day, ' ')

" -- POLYGLOT ------------------------------------------------------------- {{{2
" lua: bad syntax
"
let g:polyglot_disabled = [
      \ 'markdown',
      \ 'jsx',
      \ ]

      " \ 'lua',

" -- MARKDOWN ------------------------------------------------------------- {{{2

let g:markdown_fenced_languages = [
      \ 'c',
      \ 'cmake',
      \ 'ruby',
      \ 'eruby',
      \ 'sh'
      \ ]

" -- NERDCommenter -------------------------------------------------------- {{{2
let g:NERDSpaceDelims = 1
let g:NERDRemoveExtraSpaces = 1

" -- VimWiki/TaskWIki ----------------------------------------------------- {{{2

" :he vimwiki-local-options
let g:vimwiki_list = [
      \{ 'path': '~/.vimwiki/' }
      \]
" fold on sections and code blocks
let g:vimwiki_folding = 'expr'

let g:vimwiki_map_prefix = '<leader>W'

" -- GIT GUTTER ----------------------------------------------------------- {{{2

let g:gitgutter_sign_added                   = g:sym.gutter_added
let g:gitgutter_sign_modified                = g:sym.gutter_modified
let g:gitgutter_sign_removed                 = g:sym.gutter_removed
let g:gitgutter_sign_removed_first_line      = g:sym.gutter_removed_first_line
let g:gitgutter_sign_removed_above_and_below = g:sym.gutter_removed_above_below
let g:gitgutter_sign_modified_removed        = g:sym.gutter_modified_removed

let g:gitgutter_override_sign_column_highlight = 0

Key '(gitgutter) Next/Prev Hunk', '[/]c'

" -- ABOLISH -------------------------------------------------------------- {{{2

Key '(abolish) Change to snake/camel/mixed/upper case', 'cr(s/c/m/u)'
" vim: foldmethod=marker

" -- CAMEL CASE MOTION ---------------------------------------------------- {{{2

map <leader>w <Plug>CamelCaseMotion_w
map <leader>b <Plug>CamelCaseMotion_b
map <leader>e <Plug>CamelCaseMotion_e

xmap i<leader>w <Plug>CamelCaseMotion_iw
omap i<leader>w <Plug>CamelCaseMotion_iw
xmap i<leader>b <Plug>CamelCaseMotion_ib
omap i<leader>b <Plug>CamelCaseMotion_ib
xmap i<leader>e <Plug>CamelCaseMotion_ie
omap i<leader>e <Plug>CamelCaseMotion_ie

" -- SPEEDDATING ---------------------------------------------------------- {{{2

let g:speeddating_no_mappings = 1

nmap + <Plug>SpeedDatingUp
nmap - <Plug>SpeedDatingDown
xmap + <Plug>SpeedDatingUp
xmap - <Plug>SpeedDatingDown

nmap d+ <Plug>SpeedDatingNowUTC
nmap d- <Plug>SpeedDatingNowLocal

" -- SUPERG --------------------------------------------------------------- {{{2

let g:superg_fallback = "\<CR>"
map <CR> <Plug>SuperG
map _ <Plug>SuperSOL
map $ <Plug>SuperEOL

noremap <expr> <Plug>SuperG v:count1 ? "G" : "\<CR>"
noremap        <Plug>SuperSOL _
noremap        <Plug>SuperEOL $

" -- TABLE MODE ----------------------------------------------------------- {{{2

Key '(TableMode) cell object',       'a/i|', 'xo'
Key '(TableMode) delete row/column', '<leader>tdr/c'
Key '(TableMode) insert table',      '<leader>tc'
Key '(TableMode) sort',              '<leader>ts'

omap a<Bar> <Plug>(table-mode-cell-text-object-a)
xmap a<Bar> <Plug>(table-mode-cell-text-object-a)
omap i<Bar> <Plug>(table-mode-cell-text-object-i)
xmap i<Bar> <Plug>(table-mode-cell-text-object-i)

nmap <leader>tdr <Plug>(table-mode-delete-row)
nmap <leader>tdc <Plug>(table-mode-delete-column)
nmap <leader>ts  <Plug>(table-mode-sort)

nnoremap <leader>tc :TableModeInsert<space>

" -- SURROUND ------------------------------------------------------------- {{{2

xmap s <Plug>VSurround
imap <C-S> <Plug>Isurround
imap <leader>s <Plug>Isurround
imap <leader>S <Plug>ISurround

" -- COMMENTARY EXTENSION ------------------------------------------------- {{{2

nnoremap <silent> gC :set opfunc=f#CommentToggle<CR>g@
xnoremap <silent> gC :<C-U>call f#CommentToggle(v:true)<CR>
