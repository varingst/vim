" == PLUG ================================================================= {{{1
call f#plug_begin()

" -- Programmer QoL ------------------------------------------------------- {{{2

Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'w0rp/ale'
PlugLocal 'varingst/ale-silence'
Plug 'scrooloose/nerdcommenter'    " batch commenting +++
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }   " file navigator

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Code search, nav, vim-bling
Plug 'mileszs/ack.vim'             " code grepper (ag/ack) wapper
PlugLocal 'varingst/ack-extend'
Plug 'majutsushi/tagbar', { 'on' : 'TagbarToggle' }
Plug 'junegunn/fzf.vim'            " fuzzy file, buffer, everything nav
Plug 'vim-airline/vim-airline'     " statusline
Plug 'vim-airline/vim-airline-themes'
Plug 'KabbAmine/zeavim.vim'        " doc lookup
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/camelcasemotion' " camelcase text objects
Plug 'junegunn/vim-easy-align'
PlugLocal 'varingst/vim-skeleton', 'vim-skeleton-fork'

" testing nvim-completion-manager-2

Plug 'roxma/vim-hug-neovim-rpc'    " neovim rpc client comp layer
Plug 'roxma/nvim-yarp'             " yet another remote plugin framework
Plug 'ncm2/ncm2'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next',
                                       \ 'do': 'language-client-install' }

" -- Programming Language Extras ------------------------------------------ {{{2
"
Plug 'sheerun/vim-polyglot'        " language pack

PlugFT {
    \ 'ruby': [
      \ 'danchoi/ri.vim',
    \ ],
    \ 'javascript': [
      \ 'maxmellon/vim-jsx-pretty',
      \ 'othree/jspc.vim',
      \ 'othree/javascript-libraries-syntax.vim',
      \ 'alexbyk/vim-ultisnips-react',
      \ 'moll/vim-node'
    \ ],
    \ 'haxe': [
      \ 'jdonaldson/vaxe'
    \ ],
    \ 'ejs': [
      \ 'nikvdp/ejs-syntax'
    \ ],
    \ 'vim': [
      \ 'tomtom/spec_vim',
      \ 'h1mesuke/vim-unittest',
      \ 'kana/vim-vspec'
    \ ]
  \ }

Plug 'ncm2/ncm2-pyclang'           " c/c++
Plug 'ncm2/ncm2-vim'
Plug 'Shougo/neco-vim'             " vim dep

Plug 'junegunn/vader.vim'

" -- Tim Pope obviously --------------------------------------------------- {{{2

Plug 'tpope/vim-fugitive'         " Git wrapper
Plug 'tpope/vim-surround'         " XML tags, brackets, quotes, etc
Plug 'tpope/vim-speeddating'      " increment/decrement dates +++
Plug 'tpope/vim-endwise'          " autoadd closing symbols (end/endif/endfun)
Plug 'tpope/vim-dispatch'         " Run builds and test suites
Plug 'tpope/vim-repeat'           " make '.' handle plugins nicer
Plug 'tpope/vim-abolish'          " Smarter substitution ++
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-scriptease'

" Ruby snaxx
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rbenv'            " Tell vim to use the right ruby
Plug 'tpope/gem-ctags'            " RubyGems Automatic Ctags Invoker

" -- Markup, Template, Formatting, et al ---------------------------------- {{{2

Plug 'othree/html5-syntax.vim'     " handles HTML5 syntax highlighting

" Todo/Project
Plug 'vim-scripts/SyntaxRange'
Plug 'mattn/calendar-vim'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'tbabej/taskwiki'

Plug 'dhruvasagar/vim-table-mode'

Plug 'rhysd/vim-grammarous', { 'on': 'GrammarousCheck' }

Plug 'nathanaelkane/vim-indent-guides'
Plug 'michaeljsmith/vim-indent-object'

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
      \ 'open':                      '+',
      \ 'close':                     '-',
      \ 'whitespace_trailing':       '§',
      \ 'whitespace_tab':            '›',
      \ 'whitespace_tab_pad':        '\ ',
      \ 'whitespace_nobreak':        '¬',
      \ 'nowrap_precedes':           '‹',
      \ 'nowrap_extends':            '›',
      \ 'gutter_error':              '»',
      \ 'gutter_warning':            '›',
      \ 'gutter_info':               '¨',
      \ 'gutter_added':              '·',
      \ 'gutter_modified':           '–',
      \ 'gutter_removed':            '…',
      \ 'gutter_removed_first_line': '¨',
      \ 'gutter_removed_above_below':'‹',
      \ 'gutter_modified_removed':   '¬',
      \ 'num': split('零壱弐三四五六七八九', '\zs'),
      \ 'day': split('日月火水木金土', '\zs')
      \ }

" == OPTIONS ============================================================== {{{1

" vim-plug handles these automatically
" filetype plugin indent on
" syntax enable

set background=dark
let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
let g:solarized_menu = 0
colorscheme solarized

set number                " current line numbered
set scrolloff=5           " min lines to keep above/below cursor when scrolling
set wildmode=longest,list " bash style completion
set nomore                " remove more message after shell command
set winminheight=0        " windows may be minimized down to just a status bar
set splitright
set splitbelow
let g:default_completeopt = 'menuone' " use popupmenu also with just one match
exe 'set completeopt='.g:default_completeopt

if &modifiable && !has('nvim')
  set fileencoding=utf-8
  set encoding=utf-8
  set termencoding=utf-8
  scriptencoding utf-8
endif
set noswapfile
set autoread     " reloads file if changed and buffer not dirty

set title        " set terminal title
set visualbell   " dont beep
set noerrorbells " dont beep
set ttimeout

set history=1000    " command and search history
set undolevels=1000

set nohlsearch   " highlight search terms
set incsearch    " show matches as you type
set ignorecase   " ignore case when searching
set smartcase    " case-insensitive when all lowercase
set magic        " set magic on for regex
set hidden       " hides buffers instead of closing on new open

set autoindent               " auto indenting
set tabstop=2                " set tab character to 2 characters
set shiftwidth=2             " ident width for autoindent
set expandtab                " turn tabs into whitespace
set foldmethod=marker        " type of folding
set backspace=2              " make backspace work like most other apps
set list                     " replace whitespace with listchars
exe ':set listchars='.join([
      \ 'tab:'        .g:sym.whitespace_tab.g:sym.whitespace_tab_pad,
      \ 'trail:'      .g:sym.whitespace_trailing,
      \ 'nbsp:'       .g:sym.whitespace_nobreak,
      \ 'precedes:'   .g:sym.nowrap_precedes,
      \ 'extends:'    .g:sym.nowrap_extends
      \  ], ',')
let g:default_conceal_level = 2
exe 'set conceallevel='.g:default_conceal_level
set concealcursor=nc         " conceal in normal and commandmode

set textwidth=80
set synmaxcol=128     " limit max number of columns to search for syntax items
set signcolumn=yes
set iskeyword=@,48-57,_,192-255,-
set viewoptions="cursor,folds"

set ttyfast      " send more chars to screen for redrawing
set lazyredraw   " don't redraw while executing macros

let g:netrw_browsex_viewer = 'xdg-open'
let g:vimsyn_embed = 0 " no embedded perl, lua, ruby, etc syntax in .vim files

" == AUTOCOMMANDS ========================================================= {{{1

augroup vimrc_autocmd
  autocmd!
  " auto save and load folds, options, and cursor
  au BufWinLeave *.* mkview
  au BufWinEnter *.* silent! loadview

  au FileType gitcommit,qf wincmd J

  " Dont show tabs in vim help, vsplit if space available
  au FileType help setlocal nolist | if winwidth('.') > 140 | wincmd L | endif

  exe 'au BufWinEnter '.join([
        \ '~/.vimrc',
        \ '~/.config/nvim/init.vim',
        \ '~/.vim/init.vim',
        \ '~/.vim/autoload/f.vim',
        \ ], ','). ' call f#VimRcExtra()'

  au BufWinEnter ~/.vimrc cd ~/.vim | call FugitiveDetect(expand('~/.vim'))

  au BufWinEnter .eslintrc set filetype=json
augroup END

" -- NCM2 ----------------------------------------------------------------- {{{2

augroup ncm2_completion_autocmd
  autocmd!
  au BufWinEnter * if has_key(g:ncm2_filetype_whitelist, &filetype)
               \ |   call ncm2#enable_for_buffer()
               \ |   exe 'imap <buffer> '.g:completion_key.' <Plug>(ncm2_manual_trigger)'
               \ | endif
  au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
  exe "au User Ncm2PopupClose set completeopt=".g:default_completeopt
augroup END

" -- VimWiki -------------------------------------------------------------- {{{2

augroup vimwiki_mapping
  autocmd!
  au FileType vimwiki nmap <buffer><leader><CR> <Plug>VimwikiVSplitLink
augroup END


" == KEY MAPPING ========================================================== {{{1

" ~/.vim/autoload/keys.vim
call keys#init()
nnoremap <C-B> :call keys#list()<CR>

map ; <nop>
let g:mapleader = ';'

map , <nop>
let g:maplocalleader = ','
inoremap <leader><ESC> ;<ESC>

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
" increment under cursor
nnoremap + <C-A>
" decrement under cursor
nnoremap - <C-X>
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
let g:completion_key = '<C-Space>'

" fire InsertLeave even on <C-C>
inoremap <C-C> <ESC>

" like i_<C-W> but to the right
inoremap <C-L> <C-O>dw
" like i_<C-U> but to end of line, rather than start
inoremap <C-;> <C-O>d$
" like i_<C-W> but stop at snake_case/camelCase boundaries
inoremap <C-Q> <C-O>dv?^\<BAR>_\<BAR>\u\<BAR>\<\<BAR>\s<CR>
" like i_<C-W> but WORD rather than word
inoremap <C-E> <C-O>dB

inoremap <leader><C-V> <C-V>

" -- Various Visual ------------------------------------------------------- {{{2

" yank visual selection to register
vnoremap <silent><C-R> :<C-U>exe 'normal! gv"'.nr2char(getchar()).'y'<CR>
" replace on all lines of visual selection
vnoremap R dgvI

" -- Various Command ------------------------------------------------------ {{{2

cmap w!! w !sudo tee % > /dev/null
cmap e!! silent Git checkout -- % <BAR> redraw!
cmap r!! Read<space>
cnoremap <C-K> <up>
cnoremap <C-J> <down>
cnoremap <C-V> <HOME><S-Right><Right><C-W>vsplit<space><END>
cnoremap <C-X> <HOME><S-Right><Right><C-W>split<space><END>

" -- Arrowkeys/Buffernav -------------------------------------------------- {{{2

nmap <expr><Left>  v:count ? '<C-W><' : '<Plug>AirlineSelectPrevTab'
nmap <expr><Right> v:count ? '<C-W>>' : '<Plug>AirlineSelectNextTab'
nmap <expr><Up>    v:count ? '<C-W>+' : '<Plug>LPrev'
nmap <expr><Down>  v:count ? '<C-W>-' : '<Plug>LNext'
nmap       <S-Up>                        <Plug>CPrev
nmap       <S-Down>                      <Plug>CNext

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

nmap <C-Left>  <C-W>h
nmap <C-Right> <C-W>l
nmap <C-Up>    <C-W>k
nmap <C-Down>  <C-W>j

" -- <CR> mapping --------------------------------------------------------- {{{2

" jump to closest line matching <count>$
nnoremap <expr><CR> v:count ? f#G(v:count) : "<CR>"
xnoremap <expr><CR> v:count ? f#G(v:count) : "<CR>"

imap <expr><CR> (pumvisible() ? "\<C-Y>" : '')."\<CR>\<Plug>DiscretionaryEnd"

" -- <space> mapping ------------------------------------------------------ {{{2

nmap <space>gg <Plug>Goto
nmap <space>gd <Plug>Definition
nmap <space>gc <Plug>Declaration
nmap <space>gi <Plug>Implementation
nmap <space>gt <Plug>TypeDefinition
nmap <space>gr <Plug>References
nmap <space>gu <Plug>Include
nmap <space>gp <Plug>Parent
nmap <space>go <Plug>Doc

nnoremap <space>f :Files<CR>
nnoremap <space>F :GFiles<CR>
nnoremap <space>s :Snippets<CR>
nnoremap <space>t :BTags<CR>
nnoremap <space>T :Tags<CR>
nnoremap <space>h :History<CR>

nnoremap <space>? :nmap <lt>space><CR>

" -- pum movement --------------------------------------------------------- {{{2

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

" -- Faster file Saving --------------------------------------------------- {{{2

inoremap <leader>w <ESC>:w<CR>
nnoremap <leader>w :w<CR>

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

nnoremap <leader>*  :call f#LocalVimGrep('\<'.expand("<cword>").'\>')<CR>
nnoremap <leader>#  :call f#LocalVimGrep('\<'.expand("<cword>").'\>')<CR>
nnoremap <leader>g* :call f#LocalVimGrep(expand("<cword>"))<CR>
nnoremap <leader>g# :call f#LocalVimGrep(expand("<cword>"))<CR>
nnoremap <leader>/ :LocalGrep<space>

Key ':Ack (word under cursor)', '<leader>a/A'
nnoremap <leader>a :Ack<space>

" -- Open file under cursor in split window ------------------------------- {{{2

nnoremap <expr><silent>gf v:count ? "gf" : join([
       \ ":let cur=winbufnr('.')",
       \ "gF:let new=winbufnr('.')",
       \ ":exe 'buffer '.cur",
       \ ":exe (winwidth('.') > 140 ? 'vertical ' : '').'sbuffer '.new",
       \ ""], "\<CR>")

" -- Fun with o ----------------------------------------------------------- {{{2

Key 'yank {motion} from start of current line into @o',  '<leader>o'
Key 'yank current line until . to @o, put on next line', '<leader>o', 'i'

" open line above
inoremap <C-O><C-O> <C-O>O
inoremap <C-R><C-O> <C-R>o
inoremap <silent><leader>o <ESC>^"oyf.o<C-R>o
nnoremap <silent><leader>o ^:set opfunc=f#copyO<CR>g@


" -- Normal jkJKHL -------------------------------------------------------- {{{2

" j/k on visual lines, not actual lines
nnoremap j gj
nnoremap k gk
" navigate folds with J/K
nnoremap <expr><silent>J foldlevel('.') && foldclosed('.') != -1 ? "zo" : "zj"
nnoremap <expr><silent>K foldlevel('.') &&
      \ (foldclosed('.') == -1 <BAR><BAR> foldlevel('.') > 1) ? "zc" : "gk"

noremap <expr> H getcharsearch().forward ? ',' : ';'
noremap <expr> L getcharsearch().forward ? ';' : ','

" -- System Clipboard ----------------------------------------------------- {{{2

" TODO: "+ is Xwin clipboard, set this up for osx as well
inoremap <C-V> <C-O>"+p
vnoremap <C-C> "+y
vnoremap <C-X> "+d

" -- Sticky Shift Camel Case Relief --------------------------------------- {{{2

Key 'Downcase last uppercase letter', '<leader>u', 'ni'
nnoremap <silent><leader>u md:s/.*\zs\(\u\)/\L\1/e<CR>`d
inoremap <silent><leader>u <ESC>:s/.*\zs\(\u\)/\L\1/e<CR>`^i

" -- Line join/break ---------------------------------------- {{{2

Key 'join <count> lines/paragraph', '<leader>j/J'
nnoremap <leader>j J
nnoremap <leader>J v}J

Key 'Break/Join function arguments', '<leader>f/F'
nnoremap <silent><leader>f 0f(:let c=col('.')-1<CR>:s/,/\=",\r".repeat(' ', c)/ge<CR>
nnoremap <silent><leader>F 0f(v%J

Key 'Break/Join XML attributes',   '<leader>x/X'
nnoremap <silent><leader>x :s/\(<\w\+\\|\w\+=\({[^}]*}\\|"[^"]*"\\|'[^']*'\)\)\s*/\1\r/ge<CR>:redraw<CR>='[
nnoremap <silent><leader>X v/\/\?><CR>J:s/\s\(\/\?>\)/\1/<CR>


" -- Text objects --------------------------------------------------------- {{{2

" classes and methods, ruby only perhaps

map ]<space> ]m
map [<space> [m

" -- Linewise Movement Overrides ------------------------------------------ {{{2

" The default:
" ^       - First CHAR of current line
" N-      - First CHAR N lines higher
" N_      - First CHAR N-1 lines lower
" N+      - First CHAR N lines lower
" N<CR>   - First CHAR N lines lower
" N$      - End of line N-1 lines lower

" Here
" N_         - First char N-1 lines lower
" N<leader>_ - First char N-1 lines higher
" N$         - Last char N-1 lines lower
" N<leader>_ - Last char N-1 lines higher

" TODO: operator-pending mode

noremap <expr><leader>_ f#linewise(v:count, "-", "_")
noremap <expr><leader>$ f#linewise(v:count, "k$", "$")

" -- EasyAlign ------------------------------------------------------------ {{{2

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

xmap <bar> gaip
nmap <bar> gaip

Key '(EasyAlign) Align operator',  'ga', 'nv'
Key '(EasyAlign) inner paragraph', '|',  'nv'

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

" -- Surround ------------------------------------------------------------- {{{2

xmap s <Plug>VSurround
imap <leader>s <Plug>Isurround

" -- Fkeys ---------------------------------------------------------------- {{{2

FKeys {
  \ '<F1>':           ':call keys#flist()',
  \ '<F2>':           ':call f#LocListToggle()',
  \ '<F3>':           ':NERDTreeToggle',
  \ '<F4>':           ':TagbarToggle',
  \ '<F5>':           ':CheatSheet',
  \ '<F6>':           ':call f#AutoCompletionToggle()',
  \ '<F8>':           ':call f#PreviewHunkToggle()',
  \ '<F9>':           ':Gstatus',
  \ '<F10>':          ':Dispatch',
  \ '<F11>':          ':Make',
  \ '<leader><F2>':   ':call f#QuickFixFlush()',
  \ '<leader><F3>':   ':set relativenumber!',
  \ '<leader><F4>':   ':set hlsearch!',
  \ '<leader><F5>':   ':call f#ConcealToggle()',
  \ '<leader><F6>':   ':call f#ColorColumnToggle()',
  \ '<leader><F8>':   ':call f#GdiffToggle()',
  \ '<leader><F9>':   ':Gcommit --all',
  \ '<leader><F10>':  ':Dispatch!',
  \ '<leader><F11>':  ':Make!'
  \ }


" == COMMANDS ============================================================= {{{1

command! -nargs=* Variations   silent call f#Variations(<f-args>)
command! -nargs=0 CloseBuffers silent call f#CloseBuffers()
command! -nargs=1 ScriptNames  silent call f#ScriptNames(<q-args>)
command! -nargs=1 Profile      silent call f#Profile(<q-args>)
command! -nargs=0 SynStack     echo join(f#SynStack(), "\n")
command! -nargs=* LocalGrep    silent call f#LocalVimGrep(<q-args>)
command! -nargs=* Date         read !date --date=<q-args> "+\%Y-\%m-\%d"

" see :he :DiffOrig
command! DiffOrig vert new
              \ | set bt=nofile
              \ | r++edit #
              \ | 0d_
              \ | diffthis
              \ | wincmd p
              \ | diffthis

command! -nargs=0 Exe silent call
      \ system(printf('chmod +x "%s"', expand("%")))

command! -nargs=? Read silent call
      \ append(line('.'),
      \        systemlist(strlen(<q-args>)
      \                   ? <q-args>
      \                   : substitute(getline('.'), '^\$ *', '', '')))

command! -nargs=? -complete=file Open silent call
      \ netrw#BrowseX(expand(strwidth(<q-args>) ? <q-args> : '%'),
      \               netrw#CheckIfRemote())

command! -nargs=1 -complete=function Function execute
      \ (winwidth('.') < 140 ? 'split' : 'vsplit').' +'.
      \   join(
      \     reverse(
      \       matchlist(
      \         execute('verbose function'),
      \         <q-args>.'[^\n]*\n\s*Last set from \(\S\+\) line \(\d\+\)')[1:2]))

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

" -- COMPLETION/LSP ------------------------------------------------------- {{{2

" ~/.vim/autoload/ide.vim
call ide#init()

" -- Language Client ------------------------------------------------------ {{{3

" leave diagnostics to ALE, for now
let g:LanguageClient_diagnosticsEnable = 0

let g:LanguageClient_serverCommands = {
    \ 'ruby': ['solargraph', 'stdio'],
    \ }

if filereadable(expand('~/.jars/EmmyLua-LS-all.jar'))
  let g:LanguageClient_serverCommands['lua'] = [
        \ 'java',
        \ '-cp',
        \ expand('~/.jars/EmmyLua-LS-all.jar'),
        \ 'com.tang.vscode.MainKt' ]
endif

let g:LanguageClient_rootMarkers = {
    \ 'ruby': ['Gemfile']
    \ }

let g:LanguageClient_diagnosticsList = 'Quickfix'

if v:false " needs more haxx
  let tmp = tempname()
  let g:LanguageClient_loggingFile = tmp.'lc-client.log'
  let g:LanguageClient_serverStderr = tmp.'lc-server.log'
  command! LangClientLog exe "vsplit ".g:LanguageClient_loggingFile
  command! LangServerLog exe "vsplit ".g:LanguageClient_serverStderr
endif

let g:LanguageClient_diagnosticsDisplay = {
      \ 1: {
      \   'name': g:sym.error,
      \   'texthl': 'ALEError',
      \   'signText': g:sym.gutter_error,
      \   'signTexthl': 'ALEErrorSign',
      \ },
      \ 2: {
      \   'name': g:sym.warning,
      \   'texthl': 'ALEWarning',
      \   'signText': g:sym.gutter_warning,
      \   'signTexthl': 'ALEWarningSign',
      \ },
      \ 3: {
      \   'name': g:sym.info,
      \   'texthl': 'ALEInfo',
      \   'signText': g:sym.gutter_info,
      \   'signTexthl': 'ALEInfoSign',
      \ },
      \ 4: {
      \   'name': g:sym.info,
      \   'texthl': 'ALEInfo',
      \   'signText': g:sym.gutter_info,
      \   'signTexthl': 'ALEInfoSign',
      \ },
      \}


" -- NCM2 ----------------------------------------------------------------- {{{3

let g:ncm2_filetype_whitelist = extend({
      \ 'vim': 1,
      \}, g:LanguageClient_serverCommands)

let g:clang_path = '/usr/lib/llvm/6'
let g:ncm2_pyclang#library_path = g:clang_path.'/lib64/libclang.so.6'
let g:ncm2_pyclang#clang_path   = g:clang_path.'/bin/clang'
let g:ncm2_pyclang#database_path = [ 'compile_commands.json' ]
let g:ncm2_pyclang#args_file_path = [ '.clang_complete' ]

" see :help Ncm2PopupOpen
let g:normal_completeopt = &completeopt


" -- YCM ------------------------------------------------------------------ {{{3

let g:ycm_filetype_whitelist = { '*': 1 }
let g:ycm_filetype_blacklist = extend({
      \ 'tagbar': 1,
      \ 'markdown': 1,
      \ 'vimwiki': 1,
      \}, g:ncm2_filetype_whitelist)

" minimum chars to trigger identifier completion (2)
let g:ycm_min_num_of_chars_for_completion = 2
" minimum matching characters for candidate to be shown (0)
let g:ycm_min_num_identifier_candidate_chars = 0
" max number of indentifier suggestions in menu (10)
let g:ycm_max_num_identifier_candidates = 50

" max number of semantic suggestions in menu (50)
let g:ycm_max_num_candidates = 100

" completion menu auto popup (1)
let g:ycm_auto_trigger = 1

let g:ycm_complete_in_comments = 0
let g:ycm_complete_in_strings = 1

" filetypes for which to disable filepath completion
let g:ycm_filepath_blacklist = {
      \ 'html': 1,
      \ 'jsx': 1,
      \ 'xml': 1,
      \ }
" -- diagnostics -- {{{4
"
" Let ALE handle diagnostics

" diagnostics for c, cpp, objc, objcpp, cuda
let g:ycm_show_diagnostics_ui = 0

" put icons in vim's gutter
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0

" echo diagnostic of current line
let g:ycm_echo_current_diagnostic = 0

" gutter symbols
let g:ycm_error_symbol = g:sym.gutter_error
let g:ycm_warning_symbol = g:sym.gutter_warning


" filter
" 'filetype: { 'regex': [ ... ], 'level': 'error',
let g:ycm_filter_diagnostics = {}

" populate location list on new data
let g:ycm_always_populate_location_list = 0

" auto open location list after :YcmDiags
let g:ycm_open_loclist_on_ycm_diags = 0

" --- }}}

let g:ycm_use_ultisnips_completer = 0

let g:ycm_add_preview_to_completeopt = 0


"let g:ycm_filetype_specific_completion_to}
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1

let g:ycm_key_invoke_completion = g:completion_key
let g:ycm_key_list_select_completion = ['<C-j>', '<Tab>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<S-Tab>', '<Up>']


let g:ycm_global_ycm_extra_conf = expand('$HOME').'/.vim/ycm.py'
let g:ycm_extra_conf_vim_data = [
      \ '&filetype',
      \ 'g:gcc_flags',
      \]
" let g:ycm_config_extra_conf = 0

let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:ycm_semantic_triggers = {
  \   'c'               : ['->', '.'],
  \   'objc'            : ['->', '.'],
  \   'ocaml'           : ['.', '#'],
  \   'cpp,objcpp'      : ['->', '.', '::'],
  \   'perl'            : ['->'],
  \   'php'             : ['->', '::'],
  \   join([
        \ 'cs',
        \ 'd',
        \ 'elixir',
        \ 'haskell',
        \ 'java',
        \ 'javascript',
        \ 'python',
        \ 'perl6',
        \ 'ruby',
        \ 'scala',
        \ 'vb',
        \ 'vim'
  \   ], ',')           : [ '.' ],
  \   'lua'             : ['.', ':'],
  \   'erlang'          : [':'],
  \ }

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
    \ 'autoload/&plugin/': {
      \ '*.vim' : { 'alternate': 'test/{}.vader' },
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

let g:ale_linters = {
      \ 'python': ['flake8'],
      \ 'sh':     ['shellcheck'],
      \ 'vim':    [],
      \ 'ruby':   ['rubocop', 'solargraph'],
      \ }

let g:ale_c_gcc_options   = join(g:gcc_flags['common'] + g:gcc_flags['c'])
let g:ale_cpp_gcc_options = join(g:gcc_flags['common'] + g:gcc_flags['cpp'])

" temp fix for https://github.com/w0rp/ale/issues/1656#issuecomment-423017658
let g:ale_python_auto_pipenv = 0

" highlight ALEWarning ctermfg=166
highlight ALEWarningSign ctermfg=166

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

" extend the default file/path section with some 'auto echo' for debugging
let g:airline_section_c = airline#section#create([
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

" -- ULTISNIPS ------------------------------------------------------------ {{{2

let g:UltiSnipsExpandTrigger       = '<leader>l'
let g:UltiSnipsJumpForwardTrigger  = '<leader>j'
let g:UltiSnipsJumpBackwardTrigger = '<leader>k'

let g:UltiSnipsEditSplit           = 'horizontal'
let g:UltiSnipsSnippetsDirectories = [ '~/.vim/UltiSnips', 'UltiSnips' ]

" -- CALENDAR ------------------------------------------------------------- {{{2

let g:calendar_monday = 1
let g:calendar_wruler = join(g:sym.day, ' ')

" -- POLYGLOT ------------------------------------------------------------- {{{2
" lua: bad syntax
"
let g:polyglot_disabled = [
      \ 'markdown',
      \ 'lua',
      \ ]


" -- MARKDOWN ------------------------------------------------------------- {{{2

let g:markdown_fenced_languages = [
      \ 'c',
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
