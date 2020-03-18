if has('patch-8.1.1116')
  scriptversion 3
endif

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

Plug 'vim-airline/vim-airline'
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

Plug 'mileszs/ack.vim'
Plug 'varingst/ack-extend'
Plug 'varingst/vim-skeleton'
Plug 'majutsushi/tagbar', { 'on' : 'TagbarToggle' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'ludovicchabant/vim-gutentags'
Plug 'puremourning/vimspector', { 'do': './install_gadget.py'
      \ ..' --enable-c'
      \ ..' --enable-python'
      \ ..' --enable-bash'
      \ ..' --force-enable-chrome'
      \}

" -- Language Extras ------------------------------------------------------ {{{2

Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/vader.vim'

" -- Tim Pope obviously --------------------------------------------------- {{{2

Plug 'tpope/vim-surround'         " XML tags, brackets, quotes, etc
Plug 'tpope/vim-speeddating'      " increment/decrement dates +++
Plug 'tpope/vim-endwise'          " autoadd closing symbols (end/endif/endfun)
Plug 'tpope/vim-dispatch'         " Run builds and test suites
Plug 'tpope/vim-repeat'           " make '.' handle plugins nicer
Plug 'tpope/vim-abolish'          " Smarter substitution ++
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-fugitive'

" -- Vim motions and objects ---------------------------------------------- {{{2

Plug 'vim-scripts/camelcasemotion'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'michaeljsmith/vim-indent-object'
" Plug 'varingst/vim-indent-object', { 'local': 'vim-indent-objects' }
Plug 'varingst/vim-imotion'
Plug 'varingst/vim-text-objects'
Plug 'varingst/vim-superg'

" -- Markup, Template, Formatting, et al ---------------------------------- {{{2

" Todo/Project
Plug 'vim-scripts/SyntaxRange'
Plug 'mattn/calendar-vim'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'dhruvasagar/vim-table-mode'
Plug 'rhysd/vim-grammarous'
Plug 'ledger/vim-ledger'
Plug 'varingst/vim-filter'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" -- Prototypes ----------------------------------------------------------- {{{2

for proto in glob('~/.vim/proto/*', v:false, v:true)
  call plug#(proto)
endfor

" }}}

call plugged#end()

runtime macros/matchit.vim

" == SYMBOLS ============================================================== {{{1

let g:sym = {
      \ 'line':                      '行',
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
      \ 'bug':                       '虫',
      \ 'table':                     '表',
      \ 'tag':                       '札',
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
      \ 'fill_end_of_buffer':        ' ',
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
      \ 'day': split('日月火水木金土', '\zs')
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
  au VimLeave * call tmux#SetWindowTitle(fnamemodify($PWD, ':~'))
  au VimEnter * call tmux#SetPaneServerName()

  au FileType * for src in filter(glob(get(split(&rtp, ','), 0, '')..'/ftcommon/*.vim', v:false, v:true),
        \                         {_, fname -> fnamemodify(fname, ':t') =~# expand('<amatch>')..'\.' })
        \     |   exe 'source '..src
        \     | endfor

  au User GutentagsUpdating,GutentagsUpdated,CocNvimInit call airline#update_statusline()

  autocmd ColorScheme * highlight ALEWarningSign    ctermfg=166
        \             | highlight SpellBad          ctermfg=166               cterm=underline
        \             | highlight DiffAdd           ctermfg=NONE ctermbg=NONE cterm=NONE
        \             | highlight DiffChange        ctermfg=NONE ctermbg=0    cterm=NONE
        \             | highlight DiffDelete        ctermfg=NONE ctermbg=NONE cterm=NONE
        \             | highlight DiffText          ctermfg=NONE ctermbg=NONE cterm=underline
        \             | highlight Visual            ctermfg=NONE ctermbg=236  cterm=NONE

  autocmd CursorHold,CursorHoldI * call popup#FuncName()
augroup END

" == OPTIONS ============================================================== {{{1

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
set updatetime=300

set history=1000
set undolevels=1000

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
set foldmethod=marker
set foldtext=printf('%s%3d\ %s',get(g:sym.num,v:foldlevel,v:foldlevel),(v:foldend-v:foldstart),getline(v:foldstart))
set diffopt+=foldcolumn:0
set backspace=2
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
set signcolumn=yes
set iskeyword=@,48-57,_,192-255,-
set viewoptions=cursor,folds
set tags^=./.git/tags
set notagrelative
set spelllang=en_us

set ttyfast
set lazyredraw

let g:vimsyn_embed = 0 " no embedded perl, lua, ruby, etc syntax in .vim files

let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'

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
      \ '<CTRL-i>':   'c-i',
      \ '<CR>':       ['13;2u', '13;5u', '13;6u'],
      \ '<Up>':       ['1;2A',  '1;5A',  '1;6A'],
      \ '<Down>':     ['1;2B',  '1;5B',  '1;6B'],
      \ '<Right>':    ['1;2C',  '1;5C',  '1;6C'],
      \ '<Left>':     ['1;2D',  '1;5D',  '1;6D'],
      \ '<Home>':     ['1;2H',  '1;5H',  '1;6H'],
      \ '<End>':      ['1;2F',  '1;5F',  '1;6F'],
      \ '<PageUp>':   ['5;2~',  '5;5~',  '5;6~'],
      \ '<PageDown>': ['6;2~',  '6;5~',  '6;6~'],
      \ '<S-F1>':     ['23;1~'],
      \ '<S-F2>':     ['24;1~'],
      \ '<S-F3>':     ['1;2P'],
      \ '<S-F4>':     ['1;2Q'],
      \ '<S-F5>':     ['1;2R'],
      \ '<S-F6>':     ['1;2S'],
      \ '<S-F7>':     ['15;2~'],
      \ '<S-F8>':     ['17;2~'],
      \ '<S-F9>':     ['18;2~'],
      \ '<S-F10>':    ['19;2~'],
      \ '<S-F11>':    ['23;2~'],
      \ '<S-F12>':    ['24;2~'],
      \}

" -- Swap Marks ----------------------------------------------------------- {{{2

noremap ' `
noremap ` '
noremap g' g`
noremap g` g'
noremap '<space> `^

" -- Various Normal ------------------------------------------------------- {{{2

" command-line mode alias
nnoremap <C-;> :
" prevent editing from fumbling with tmux key
nnoremap <C-A> <nop>
" separate <TAB> and <C-I>
nnoremap <CTRL-i> <C-I>
" line/column guides
nnoremap <silent>^ :<C-U>call toggle#Cursorlines(v:count1)<CR>
" insert on N additional lines
nnoremap <expr> I v:count ? '<ESC><C-V>'.(v:count).'jI' : 'I'
" replace with char in current column for N additional lines
nnoremap <expr> r v:count ? '<ESC><C-V>'.(v:count).'jr' : 'r'
" blockwise visual select paragraph from current column to end of line
nnoremap <leader><C-V> <C-V>}k$
" lookup keyword under cursor with 'keywordprg'
nnoremap <leader>k K

nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

nnoremap ~~ ~l

nnoremap <expr>V '<ESC>V'.(v:count1 > 1 ? (v:count1 - 1).'j' : '')
nnoremap <expr><leader>V 'V'.superg#(line('.'), v:count1).'G'

nnoremap <silent> <leader><C-D> :<C-U>call popup#HumanDay(expand('<cWORD>'))<CR>
nnoremap <silent> <space><Tab> :<C-U>call popup#Tags({ tag -> 'fcm' =~ tag.kind })<CR>

" jump to sinful whitespace
nnoremap <expr><leader><space>
      \ get(filter(split(get(b:, 'airline_whitespace_check', ''),
      \                  '\D'),
      \            'strlen(v:val)'),
      \     0,
      \     line('.')
      \).'G'

" -- Various Insert ------------------------------------------------------- {{{2

" fire InsertLeave even on <C-C>
inoremap <C-C> <ESC>

inoremap <S-CR> <C-O>o
inoremap <C-CR> <C-O>O
inoremap <C-O><C-O> <C-O>O

inoremap <leader><C-W> <C-\><C-O>"_dT
inoremap <C-Q> <C-O>"_dv?^\<BAR>_\<BAR>\u\<BAR>\<\<BAR>\s<CR>

inoremap <C-R><C-D> <C-R>=trim(system('date "+%Y-%m-%d"'))<CR>
inoremap <C-R>' <C-R>"

inoremap <silent><C-F> <C-O>:call search(nr2char(getchar()))<CR>
inoremap <silent><C-S> <C-R>=snip#(nr2char(getchar()), &filetype)<CR>

inoremap <leader><C-V> <C-V>

" -- Various Visual ------------------------------------------------------- {{{2

xnoremap <leader>. :<C-U>exe "'<,'>normal \<Plug>(RepeatDot)"<CR>

xnoremap <expr>J ":move '>+".v:count1.'<CR>gv'
xnoremap <expr>K ":move '<-".(v:count1+1).'<CR>gv'
xnoremap <expr>M ":move ".(superg#(line('.'), v:count1) - 1).'<CR>'

" insert blank line on 'other end' of visual selection
xnoremap <expr>O line('.') == line("'<") ? 'o<ESC>o<ESC>gvo' : 'o<ESC>O<ESC>gvo'

xmap <bar> <Plug>(align)
xmap g<bar> <Plug>(alignG)

" -- Various Command ------------------------------------------------------ {{{2

cnoremap w!! w !sudo tee % > /dev/null
cnoremap e!! silent Git checkout -- % <BAR> redraw!

cnoremap <C-J> <C-G>
cnoremap <C-K> <C-T>
cnoremap <C-;> %:h/<C-D>
cnoremap <C-V> <HOME><S-Right><Right><C-W>vsplit<space><END>
cnoremap <leader><C-V> <C-V>
cnoremap <C-X> <HOME><S-Right><Right><C-W>split<space><END>
cnoremap <C-B> <C-\>ecmdline#ToggleWordBoundary()<CR>

" -- Various Window ------------------------------------------------------- {{{2

" go to last accessed window, like tmux
nnoremap <C-W>; <C-W>p

" set window width to 90/180 columns
nnoremap <C-W>i <ESC>90<C-W><BAR>
nnoremap <C-W>I <ESC>180<C-W><BAR>

" swap window with window <count>
nnoremap <C-W>p :<C-U>call f#SwapWindow(v:count1)<CR>

nnoremap <C-W>x :<C-U>call buffer#Unlist(v:count, 0)<CR>
nnoremap <C-W>X :<C-U>call buffer#Unlist(0, 0, 1)<CR>

" move cursor to window
for i in range(1, 9)
  exe printf('nnoremap <C-W>%d <ESC>%d<C-W>w', i, i)
endfor

" -- Various Operators ---------------------------------------------------- {{{2

nmap <leader>R <Plug>(op#Replace)
xmap <leader>R <Plug>(op#Replace)

nmap s <Plug>(op#Substitute)
xmap s <Plug>(op#Substitute)
nmap S <Plug>(op#Substitute)iw

imap <C-Y> <Plug>(op#CopyLineAbove)
imap <C-E> <Plug>(op#CopyLineBelow)
imap <C-G><C-G> <Plug>(op#CopyLine)

nmap <bar> <Plug>(op#Align)
xmap <bar> <Plug>(op#Align)
nmap g<bar> <Plug>(op#AlignG)
xmap g<bar> <Plug>(op#AlignG)

nmap > <Plug>(op#ShiftRight)
nmap < <Plug>(op#ShiftLeft)
" ^ breaks these
nnoremap >> >>
nnoremap << <<

" -- Recording and Formatting --------------------------------------------- {{{2

nnoremap <leader>@ q
nnoremap q gq
nnoremap Q gw
xnoremap q gq
xnoremap Q gw

" -- Various Text Objects ------------------------------------------------- {{{2

" n-1 lines, linewise
xnoremap <silent><expr> <space> printf("\<ESC>gv%d_", v:count1 + 1)
onoremap <silent>       <space> _

" -- Various Abbr --------------------------------------------------------- {{{2

iabbr #! #!/usr/bin/env
cabbr <w expand("<cword>")
cabbr <W expand("<cWORD>")
cabbr <f expand("<cfile>")

" -- Arrowkeys/Buffernav -------------------------------------------------- {{{2

nmap <expr><Left>  v:count ? '<C-W><' : '<Plug>AirlineSelectPrevTab'
nmap <expr><Right> v:count ? '<C-W>>' : '<Plug>AirlineSelectNextTab'

for i in range(1, 9)
  exe printf('nmap <leader>%d <Plug>AirlineSelectTab%d', i, i)
  exe printf('nmap <leader><leader>%d :<C-U>Split<CR><Plug>AirlineSelectTab%d', i, i)
endfor

nnoremap <silent><Up>      :<C-U>call qf#().prev(v:count1)<CR>
nnoremap <silent><Down>    :<C-U>call qf#().next(v:count1)<CR>

nmap <expr><C-Left>  get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-left)'  : '<C-W>h'
nmap <expr><C-Right> get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-right)' : '<C-W>l'
nmap <expr><C-Up>    get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-up)'    : '<C-W>k'
nmap <expr><C-Down>  get(b:, 'table_mode_active') ? '<Plug>(table-mode-motion-down)'  : '<C-W>j'

" -- Set fold markers ----------------------------------------------------- {{{2

Key 'Set foldlevel with marker, v:count1/clear', 'z<Space>/z<BS>'
nnoremap <silent> z<BS>         :call fold#SetMarker(0)<CR>
nnoremap <silent> z<Space> :<C-U>call fold#SetMarker(v:count1)<CR>

" -- Awkward symbol shorthands -------------------------------------------- {{{2
inoremap ,. ->
inoremap ., <-
inoremap ,, =>
inoremap _+ >=
inoremap +_ <=

" -- Swap quotes ---------------------------------------------------------- {{{2

nmap <leader>' cs"'
nmap <leader>" cs'"

" -- Code Search ---------------------------------------------------------- {{{2

nnoremap <space>f :Files<CR>
nnoremap <space>F :GFiles<CR>
nnoremap <space>v :AV<CR>
nnoremap <leader>a :Ack<space>
nnoremap <space>? :nmap <lt>space><CR>

nmap <leader>*  <Plug>(qf#GreqfWordExact)
nmap <leader>g* <Plug>(qf#GreqfWord)
nmap <leader>#  <Plug>(qf#GreqfWORDExact)
nmap <leader>g# <Plug>(qf#GreqfWORD)

" -- Open file under cursor in split window ------------------------------- {{{2

nnoremap <silent><leader>gf :<C-U>Split<CR>gf
nnoremap <silent><leader>gF :<C-U>Split<CR>gF

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
inoremap <silent><leader>u <C-G>u<ESC>:keeppatterns s/.*\zs\(\u\)/\L\1/e<CR>`^i<C-G>u

" -- Quick fix previous spelling error
" TODO: fix cursor movement
nnoremap <silent><leader>l m`[s1z=``
inoremap <silent><leader>l <C-G>u<ESC>[s1z=`]a<C-G>u

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

" -- Fkeys ---------------------------------------------------------------- {{{2

FKeys {
  \ '<F1>':           ':call keys#flist()',
  \ '<F2>':           ':call qf#().toggle()',
  \ '<F3>':           ':CocStart',
  \ '<F4>':           ':TagbarToggle',
  \ '<F5>':           ':CheatSheet',
  \ '<F6>':           ':FKeyMode debug <BAR> call vimspector#Continue()',
  \ '<F7>':           ':call vimspector#ToggleBreakpoint()',
  \ '<F8>':           ':call toggle#PreviewHunk()',
  \ '<F9>':           ':Gstatus',
  \ '<F10>':          ':Dispatch',
  \ '<F11>':          ':Make',
  \ '<S-F1>':         ':set wrap!',
  \ '<S-F2>':         ':call qf#().flush()',
  \ '<S-F3>':         ':TableModeToggle',
  \ '<S-F5>':         ':call toggle#Conceal()',
  \ '<S-F6>':         ':call toggle#SetLocal("colorcolumn", "", "+1")',
  \ '<S-F7>':         ':call vimspector#AddFunctionBreakpoint("<cexpr>")',
  \ '<S-F8>':         ':call toggle#Gdiff()',
  \ '<S-F9>':         ':Gcommit --all',
  \ '<S-F10>':        ':Dispatch!',
  \ '<S-F11>':        ':Make!',
  \ 'debug:<F4>':     ':FKeyMode <BAR> call vimspector#Stop()',
  \ 'debug:<F5>':     ':call vimspector#Pause()',
  \ 'debug:<F6>':     ':call vimspector#Continue()',
  \ 'debug:<F8>':     ':call vimspector#StepOver()',
  \ 'debug:<F9>':     ':call vimspector#StepInto()',
  \ 'debug:<F10>':    ':call vimspector#StepOut()',
  \ 'debug:<S-F6>':   ':call vimspector#Restart()',
  \ }

" == COMMANDS ============================================================= {{{1

command! -nargs=+ -bang -complete=file
      \ E           silent call buffer#Open(expand(<q-args>, 0, 1), <bang>0)
command! -nargs=?
      \ ReplaceEach silent call f#ReplaceEach(<q-args>)
command! -nargs=?
      \ Profile     silent call toggle#Profiling(<q-args>)
command! -nargs=*
      \ LocalGrep   silent call qf#LocalGrep(<q-args>)
command! -nargs=+ -complete=expression
      \ PP          call pp#(<args>)
command!
      \ Changes     exe 'Split '..changes#View()
command! -nargs=? -complete=filetype
      \ FTPlugin    exe 'Split '..split(&rtp, ',')[0]..'/ftplugin/'..(empty(<q-args>) ? &filetype : <q-args>)..'.vim'
command! -nargs=0
      \ SynStack    echo join(syntax#Stack(), "\n")
command! -nargs=0 -range=%
      \ StripAnsi   <line1>,<line2>s/\[\(\d\{1,2}\(;\d\{1,2}\)\?\)\?[m\|K]//ge
command! -nargs=0 -range
      \ Hex2Rgb     <line1>,<line2>s/#\(\x\+\)/\='rgb'..(strlen(submatch(1))==6?'(':'a(')..join(map(split(submatch(1),'\x\{2}\zs'),{_,x->str2nr(x,16)}),', ')..')'/ge
command! -nargs=0 -range
      \ Rgb2Hex     <line1>,<line2>s/\(rgba\?\)(\([^)]*\))/\=call('printf',['#'..repeat('%X',strlen(submatch(1)))]+split(submatch(2),'\s*,\s*'))/ge

" Split: split depending on window width {{{2
command! -nargs=* -bar -complete=file Split
      \   if winwidth('.') < 140
      \ |   split <args>
      \ | else
      \ |   vsplit <args>
      \ | endif

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

" ScriptNames: write loaded scripts to file and open {{{2
command! -nargs=1 ScriptNames
      \ | call writefile(
      \          split(
      \            execute('scriptnames'), "\n"),
      \          expand(<q-args>))
      \ | exe printf("%s %s",
      \         winwidth('.') > 140 ? 'vsplit' : 'split',
      \         <q-args>)


" Highlight: echo highlight group for item under cursor, yank to register if provided {{{2
command! -nargs=? -register Highlight
      \   if empty(<q-reg>)
      \ |    exe 'highlight '..syntax#Stack()[-1]
      \ | else
      \ |    silent call setreg(<q-reg>, syntax#Stack()[-1])
      \ |    exe 'highlight '..getreg(<q-reg>)
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

" Open: open file with handler {{{2
command! -nargs=? -complete=file Open
      \   silent call
      \   netrw#BrowseX(
      \     expand(strwidth(<q-args>) ? <q-args> : '%'),
      \     netrw#CheckIfRemote())

" Rename: rename % and create directory structure {{{2
command! -nargs=1 -complete=file Move
      \   call mkdir(fnamemodify(<q-args>, ":p:h"), "p")
      \ | let bufname = expand('%')
      \ | let altname = expand('#')
      \ | call rename(bufname, <q-args>)
      \ | exe 'e '..<q-args>
      \ | let @# = altname
      \ | exe 'bdelete '..fnameescape(bufname)
      \ | unlet bufname altname

" Function: open vim function definition, default previous with error {{{2
command! -nargs=? -complete=function Function
      \   silent execute
      \   (winwidth('.') < 140 ? 'split' : 'vsplit')..' +'..
      \     join(
      \       reverse(
      \         matchlist(
      \           execute('verbose function '
      \             .substitute(
      \               strlen(<q-args>)
      \               ? <q-args>
      \               : get(
      \                   filter(
      \                     map(
      \                       split(
      \                         execute('messages'),
      \                         '\n'),
      \                       {_, m -> matchstr(m, 'processing function \zs[^:]*\ze')}),
      \                     {_, f -> strlen(f) }),
      \                   -1, ''),
      \               '(.*$', '', '')),
      \           'Last set from \(\S\+\) line \(\d\+\)')[1:2]))

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

" Tail: tail file in term window
command! -nargs=+ -complete=file Tail
      \   for f in split(expand(<q-args>))
      \ |   exe 'term ++rows=10 tail -F '..f
      \ | endfor

" Section: Expand deco heading
command! Section
      \   let line = getline('.')
      \ | let words = split(line)
      \ | let pad = 80 - (strlen(line) - strlen(words[-2]))
      \ | let words[-2] = repeat(words[-2][0], pad)
      \ | call setline('.', join(words))
      \ | unlet line words pad

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
      \ },
      \}

for [key, action] in items({
      \ ']}': 'jumpDefinition',
      \ 'dD': 'jumpDeclaration',
      \ 'iI': 'jumpImplementation',
      \ 'tT': 'jumpTypeDefinition',
      \ 'rR': 'jumpReferences',
      \})
  exe printf('nnoremap <silent><space>%s :<C-U>call CocAction("%s")<CR>', key[0], action)
  exe printf('nnoremap <silent><space>%s :<C-U>call CocAction("%s", "Split")<CR>', key[1], action)
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
      \ 'vim':        ['vint'],
      \ 'ruby':       [],
      \ }

let g:ale_fixers = {
      \ 'python': ['black'],
      \}

let g:ale_c_gcc_options   = join(g:gcc_flags['common'] + g:gcc_flags['c'])
let g:ale_cpp_gcc_options = join(g:gcc_flags['common'] + g:gcc_flags['cpp'])

" temp fix for https://github.com/w0rp/ale/issues/1656#issuecomment-423017658
let g:ale_python_auto_pipenv = 0

" -- AIRLINE -------------------------------------------------------------- {{{2

let g:airline_extensions = [
      \ 'ale',
      \ 'branch',
      \ 'tabline',
      \ 'tagbar',
      \ 'whitespace',
      \]
" remove (fileencoding, fileformat)
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" -- THEME ---------------------------------------------------------------- {{{3

" autoload/airline/themes/motoko.vim
let g:airline_theme = 'motoko'

let g:airline_mode_map = {
  \ '__'  : g:sym.nothing,
  \ 'n'   : g:sym.normal,
  \ 'no'  : g:sym.operator,
  \ 'ni'  : g:sym.normal,
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
      \ 'linenr':    g:sym.null,
      \ 'space':     g:sym.space,
      \ 'modified':  g:sym.modified,
      \ 'maxlinenr': g:sym.line,
      \ 'notexists': g:sym.nothing,
      \ 'readonly':  g:sym.readonly,
      \ 'dirty':     g:sym.dirty,
      \})

" extend default mode sections with table mode status
let g:airline_section_a = airline#section#create_left([
      \ 'mode',
      \ ])..
      \ '%{(get(b:, "table_mode_active") ? g:sym.table : "")}'


" extend the default file/path section with some 'auto echo' for debugging
let g:airline_section_c =
      \ '%{get(g:sym.num, winnr(), winnr())}'..
      \ airline#section#create([
      \ '%<',
      \ exists('+autochdir') && &autochdir ? 'path' : 'file',
      \ g:airline_symbols.space,
      \ 'readonly'])..
      \ '%{(has_key(g:, "airline_debug") ? (g:sym.bug . g:airline_debug) : "")}'

" percentage, line number, column number
call airline#parts#define_function('mine', 'airline#extensions#mine#status')
let g:airline_section_z = airline#section#create(['mine'])

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

let g:airline#extensions#tabline#ignore_bufadd_pat = join([
      \ '\c\v^!',
      \ 'debugged program',
      \ 'gdb communication',
      \ 'vimspector.*',
      \ ], '|')

" -- QUICKFIX ------------------------------------------------------------- {{{3

let g:airline#extensions#quickfix#quickfix_text = g:sym.quickfix
let g:airline#extensions#quickfix#location_text = g:sym.location

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
      \ g:sym.whitespace_trailing..'%s'..g:sym.line
let g:airline#extensions#whitespace#mixed_indent_format =
      \ g:sym.whitespace_tab..'%s'..g:sym.line
let g:airline#extensions#whitespace#mixed_indent_file_format =
      \ g:sym.whitespace_tab..g:sym.whitespace_trailing..'%s'..g:sym.line

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
let g:table_mode_corner = '|'

" -- ACK ------------------------------------------------------------------ {{{2
"
let g:ack_exe = 'ag'
let g:ack_default_options =
      \ ' --silent --filename --numbers'..
      \ ' --nocolor --nogroup --column'
let g:ack_options = '--vimgrep'
let g:ack_whitelisted_options = g:ack_options..
      \ ' --literal --depth --max-count --one-device'..
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

Key '(gitgutter) Next/Prev Hunk', '[/]c'

" -- ABOLISH -------------------------------------------------------------- {{{2

Key '(abolish) Change to snake/camel/mixed/upper case', 'cr(s/c/m/u)'

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

nnoremap <Plug>SpeedDatingFallbackDown <C-X>
nnoremap <Plug>SpeedDatingFallbackUp <C-A>

xnoremap g+ g<C-A>
xnoremap g- g<C-D>

" -- SUPERG --------------------------------------------------------------- {{{2

let g:superg_fallback = "\<CR>"
map <CR> <Plug>SuperG
map _ <Plug>SuperSOL
map $ <Plug>SuperEOL

nnoremap <expr> z<CR> v:count ? '<ESC>'.superg#(line('.'), v:count)."z+" : 'z<CR>'

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
imap <leader>s <Plug>Isurround
imap <leader>S <Plug>ISurround

" -- COMMENTARY EXTENSION ------------------------------------------------- {{{2

nnoremap <silent> gC :set opfunc=toggle#Comments<CR>g@
xnoremap <silent> gC :<C-U>call toggle#Comments(v:true)<CR>

" -- DISPATCH ------------------------------------------------------------- {{{2

let g:dispatch_no_maps = 1

" -- GUTENTAGS ------------------------------------------------------------ {{{2

let g:gutentags_init_user_func = 'tag#InitGutentags'
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'git ls-files',
      \ }
      \}

" -- FILTER --------------------------------------------------------------- {{{2

let g:filter_options = {
      \ 'use_commentstring': v:true,
      \}
let g:filter_commands = {
      \ 'dot': [ '/bin/sh', '-c', get(glob('~/.plenv/versions/*/bin/graph-easy', v:false, v:true), -1, 'false')..' --output={o} --as=ascii {i}' ],
      \}

" -- IMOTION -------------------------------------------------------------- {{{2

let g:imotion_mappings = {
  \ 'leaders': {
  \   'motions': '<Tab>',
  \   'incmotions': '<S-Tab>',
  \   'objects': 'i',
  \   'incobjects': 'a',
  \ },
  \ 'motions': {
  \   'nxo': {
  \     'j': 'NextSibling',
  \     'k': 'PrevSibling',
  \     'h': 'PrevParent',
  \     'l': 'NextChild',
  \     'J': 'NextSection',
  \     'K': 'PrevSection',
  \     'H': 'RevPrevParent',
  \     'L': 'OpenSection',
  \     'b': 'NextBlock',
  \     'B': 'PrevBlock',
  \   }
  \ },
  \ 'objects': {
  \   'xo': {
  \     's': 'SurroundingSection',
  \     'o': 'SurroundingOpenSection',
  \   }
  \ },
  \}

nmap <Tab>. <Plug>(imotion#Repeat)
xmap . <Plug>(imotion#Repeat)
omap . <Plug>(imotion#Repeat)



" -- PANDOC --------------------------------------------------------------- {{{2

" remove foldcolumn
let g:pandoc#folding#fdc = 0

let g:pandoc#spell#default_langs = ['en_us', 'nb']

let g:pandoc#syntax#conceal#use = 0

" }}}1

catch
  " TODO: handle errors in script-private methods
  set runtimepath&
  let g:throwpoint = v:throwpoint
  let [g:file, g:line] = matchlist(g:throwpoint, '\(\f\+\), line \(\d\+\)')[1:2]
  let g:exception = v:exception

  let &cmdheight = float2nr(ceil(1.0 * strdisplaywidth(g:exception) / &columns))
  set noruler

  augroup rescue
    au!
    au VimEnter * exe printf('edit +%s %s', g:line, g:file)
          \     | echohl WarningMsg
          \     | echo g:exception
          \     | echohl None
  augroup END
endtry
