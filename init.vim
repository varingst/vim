" == PLUG ================================================================= {{{1

call f#plug_begin()

" -- Programmer QoL ------------------------------------------------------- {{{2

Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'w0rp/ale'                   " async syntax checker
Plug 'scrooloose/nerdcommenter'   " batch commenting +++
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }   " file navigator

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'sheerun/vim-polyglot'       " language pack

" Code search, nav, vim-bling
Plug 'mileszs/ack.vim'            " code grepper (ag/ack) wapper
Plug 'majutsushi/tagbar', { 'on' : 'TagbarToggle' }
Plug 'junegunn/fzf.vim'           " fuzzy file, buffer, everything nav
Plug 'vim-airline/vim-airline'    " statusline
Plug 'vim-airline/vim-airline-themes'
Plug 'KabbAmine/zeavim.vim'
Plug 'airblade/vim-gitgutter'

" Trailing whitespace, formatting, et al
" Plug 'vim-scripts/ingo-library'
" Plug 'vim-scripts/ShowTrailingWhitespace'
" Plug 'vim-scripts/CountJump'
" Plug 'vim-scripts/JumpToTrailingWhitespace'
" Plug 'vim-scripts/DeleteTrailingWhitespace'
Plug 'vim-scripts/camelcasemotion' " camelcase text objects
Plug 'junegunn/vim-easy-align'

" -- Programming languages ------------------------------------------------ {{{2

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
    \ 'ejs': [
      \ 'nikvdp/ejs-syntax'
    \ ],
    \ 'vim': [
      \ 'tomtom/spec_vim',
      \ 'junegunn/vader.vim',
      \ 'h1mesuke/vim-unittest',
      \ 'kana/vim-vspec'
    \ ]
  \ }

" ruby, but not working 'hackhowtofaq/vim-solargraph',

" Is this required with YCM ?
" Plug 'ternjs/tern_for_vim'

" testing for neovim
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ }
" needs to run: 'bash install.sh',


" -- Tim Pope obviously --------------------------------------------------- {{{2

Plug 'tpope/vim-fugitive'         " Git wrapper
Plug 'tpope/vim-surround'         " XML tags, brackets, quotes, etc
Plug 'tpope/vim-speeddating'      " increment/decrement dates +++
Plug 'tpope/vim-endwise'          " autoadd closing symbols (end/endif/endfun)
Plug 'tpope/vim-dispatch'         " Run builds and test suites
Plug 'tpope/vim-repeat'           " make '.' handle plugins nicer
Plug 'tpope/vim-abolish'          " Smarter substitution ++
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'tpope/vim-scriptease', { 'for': 'vim' }

" Ruby snaxx
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rbenv'            " Tell vim to use the right ruby
Plug 'tpope/gem-ctags'            " RubyGems Automatic Ctags Invoker

" -- Markup, Template, Formatting, et al ---------------------------------- {{{2

Plug 'powerman/vim-plugin-AnsiEsc' " ANSI color coding
Plug 'othree/html5-syntax.vim'     " handles HTML5 syntax highlighting

" markdown
" Plug 'dhruvasagar/vim-table-mode'
" Plug 'godlygeek/tabular'
" Plug 'chmp/mdnav'

" Todo/Project
Plug 'vim-scripts/SyntaxRange'
Plug 'mattn/calendar-vim'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'tbabej/taskwiki'
" Plug 'farseer90718/vim-taskwarrior'
Plug 'varingst/vim-skeleton'

" grammar
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
      \ 'whitespace_trailing':       '¡',
      \ 'whitespace_tab':            '»',
      \ 'whitespace_tab_pad':        '\ ',
      \ 'whitespace_nobreak':        '¬',
      \ 'nowrap_precedes':           '‹',
      \ 'nowrap_extends':            '›',
      \ 'gutter_error':              '»',
      \ 'gutter_warning':            '›',
      \ 'gutter_added':              '·',
      \ 'gutter_modified':           '–',
      \ 'gutter_removed':            '…',
      \ 'gutter_removed_first_line': '¨',
      \ 'gutter_modified_removed':   '¬',
      \ }

" == OPTIONS ============================================================== {{{1

" vim-plug do these automatically
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
set completeopt=menuone   " use popupmenu also with just one match

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
set lazyredraw   " don't redraw while executing macros
set magic        " set magic on for regex
set hidden       " hides buffers instead of closing on new open

set autoindent               " auto indenting
set tabstop=2                " set tab character to 2 characters
set shiftwidth=2             " ident width for autoindent
set expandtab                " turn tabs into whitespace
set foldmethod=marker        " type of folding
set foldtext=f#FoldText()
set backspace=2              " make backspace work like most other apps
set list                     " replace whitespace with listchars
exe ':set listchars='.join([
      \ 'tab:'        .g:sym.whitespace_tab.g:sym.whitespace_tab_pad,
      \ 'trail:'      .g:sym.whitespace_trailing,
      \ 'nbsp:'       .g:sym.whitespace_nobreak,
      \ 'precedes:'   .g:sym.nowrap_precedes,
      \ 'extends:'    .g:sym.nowrap_extends
      \  ], ',')
set conceallevel=2           " conceal, replace if defined char
set concealcursor=nc         " conceal in normal and commandmode

set textwidth=80
set iskeyword=@,48-57,_,192-255,-
" set colorcolumn=+1
set viewoptions="cursor,folds"

" limit max number of columns to search for syntax items
set synmaxcol=128
" send more chars to screen for redrawing
set ttyfast
" don't redraw while macro is executed
set lazyredraw

" == AUTOCOMMANDS ========================================================= {{{1

augroup vimrc_autocmd
  autocmd!
" auto save and load folds, options, and cursor
  au BufWinLeave *.* mkview
  au BufWinEnter *.* silent! loadview

  " Move quickfix window and fugitive preview to the bottom
  au FileType qf,gitcommit wincmd J

  " Dont show tabs in vim help
  au FileType help setlocal nolist | if winwidth('.') > 140 | wincmd L | endif

  au BufRead,BufNewFile .eslintrc,*.tern-config set filetype=json

  au FileType c,cpp,java,haskell setl shiftwidth=4 tabstop=4

  au InsertEnter * set norelativenumber

  au BufWinEnter ~/.vimrc,~/.config/nvim/init.vim call f#VimRcExtra()
augroup END

" == HIGHLIGHTING ========================================================= {{{1

" folding highlighting
" highlight Folded ctermfg=241 ctermbg=234 cterm=bold
" tab and trailing spaces
" highlight SpecialKey ctermbg=none ctermfg=235
" highlight ColorColumn ctermfg=3 ctermbg=4 term=none

" highlight ShowTrailingWhitespace ctermbg=Red ctermfg=Black
" highlight EndOfBuffer ctermfg=black
" highlight SignColumn ctermbg=None

" == KEY MAPPING ========================================================== {{{1

" ~/.vim/autoload/keys.vim
call keys#init()

" -- Leader mapping
map ; <nop>
let g:mapleader = ';'

map , <nop>
let g:maplocalleader = ','
inoremap <leader><ESC> ;<ESC>

" terminal sends ^@ on <C-Space>
inoremap <C-@> <C-Space>
" prevent editing from fumbling with tmux key
nnoremap <C-A> <nop>

nnoremap <C-B> :call keys#list()<CR>

" <C-W><C-U> compliment
inoremap <C-L> <C-O>d$

nnoremap <expr><CR> v:count ? "G" : "<CR>"
xnoremap <expr><CR> v:count ? "G" : "<CR>"

nnoremap <space><CR> :set relativenumber!<CR>
nnoremap <leader>v :set relativenumber<CR>V
nnoremap <leader>/ :set hlsearch!<CR>

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

iabbr ƒ function

" -- Swap quotes ---------------------------------------------------------- {{{2

inoremap <leader>' <ESC>:silent s/[^\\]\zs"/%%%/ge \| s/[^\\]\zs'/"/ge \| s/%%%/'/ge<CR>
nnoremap <leader>' :silent s/[^\\]\zs"/%%%/ge \| s/[^\\]\zs'/"/ge \| s/%%%/'/ge<CR>
inoremap <leader>" <ESC>:silent s/[^\\]\zs"/'/ge<CR>
nnoremap <leader>" :silent s/[^\\]\zs"/'/ge<CR>

" -- Yank visual selection to register ------------------------------------ {{{2

vnoremap <silent><C-R> :<C-U>exe 'normal! gv"'.nr2char(getchar()).'y'<CR>

" -- oO mapping ----------------------------------------------------------- {{{2

Key 'copy to register o and insert above/below', 'o/O',        'v'
Key 'select from start of line to .',            '<leader>o',  'ni'
Key 'open next line and insert from register o', '<C-R><C-O>', 'oi'

" open line above
inoremap <C-O><C-O> <C-O>O

xnoremap o "oyo<ESC>"opa
xnoremap O "oyO<ESC>"opa

nnoremap <leader>o ^vf.
inoremap <leader>o <ESC>^vf.

nnoremap <C-R><C-O> o<C-R>oa
inoremap <C-R><C-O> <CR><C-R>o

" -- Command mode mappings ------------------------------------------------ {{{2

cmap w!! w !sudo tee % > /dev/null
cmap e!! silent Git checkout -- % <bar> redraw!
cnoremap date r! date "+\%Y-\%m-\%d"
cnoremap <C-k> <up>
cnoremap <C-j> <down>

" -- Normal jkJK ---------------------------------------------------------- {{{2

" j/k on visual lines, not actual lines
nnoremap j gj
nnoremap k gk
" navigate folds with J/K
nnoremap <expr><silent>J foldlevel('.') && foldclosed('.') != -1 ? "zo" : "zj"
nnoremap <expr><silent>K foldlevel('.') && (foldclosed('.') == -1 <BAR><BAR> foldlevel('.') > 1) ? "zc" : "gk"
" join <count> lines
nnoremap <leader>j J
" lookup keyword under cursor with 'keywordprg'
nnoremap <leader>k K

Key 'join <count> lines', '<leader>j'

" -- normal ftFT -> LH ---------------------------------------------------- {{{2

" L and H repeats ftFT, but H always <- and L always ->

nnoremap <silent> f :nnoremap H ,<CR>:nnoremap L ;<CR>f
nnoremap <silent> F :nnoremap H ;<CR>:nnoremap L ,<CR>F
nnoremap <silent> t :nnoremap H h,<CR>:nnoremap L l;<CR>t
nnoremap <silent> T :nnoremap H h;<CR>:nnoremap L l,<CR>T

vnoremap f :<C-U>vnoremap H ,<CR>:vnoremap L ;<CR>gvf
vnoremap F :<C-U>vnoremap H ;<CR>:vnoremap L ,<CR>gvF
vnoremap t :<C-U>vnoremap H h,<CR>:vnoremap L l;<CR>gvt
vnoremap T :<C-U>vnoremap H h;<CR>:vnoremap L l,<CR>gvT

" -- Sticky Shift Camel Case Relief --------------------------------------- {{{2

Key 'Downcase last uppercase letter', '<leader>u', 'ni'
nnoremap <leader>u :s/.*\zs\(\u\)/\L\1/<CR><C-O>
inoremap <leader>u <ESC>:s/.*\zs\(\u\)/\L\1/<CR><C-O>a

" -- Function arguments join/break ---------------------------------------- {{{2

Key 'Break/Join function arguments', '<leader>f/F'
nnoremap <silent> <leader>f :s/,/,\r/g<CR>$=%
nnoremap <leader>F f(v%J

Key 'Break inline tag/properties',   '<leader>d/D'
nnoremap <silent><leader>d vit:s/\(\%V.*\%V\S\?\)\s*/\r\1\r/<CR>vat=
nnoremap <silent><leader>D md:s/\(\S\+\zs\s\+\\|\(\s*\ze\)>\)/\r/g<CR>v`d=

" -- Linewise Movement ---------------------------------------------------- {{{2

" The default:
" ^       - First CHAR of current line
" N-      - First CHAR N lines higher
" N_      - First CHAR N-1 lines lower
" N+      - First CHAR N lines lower
" N<CR>   - First CHAR N lines lower
" N$      - End of line N-1 lines lower

" What would make more sense:

" N-      - First CHAR N lines higher
" N^      - First CHAR N-1 lines lower
" N<CR>   - First CHAR N lines lower

" N+      - End of line N lines lower
" N$      - End of line N-1 lines lower
" N_      - End of line N lines higher

" Even better:

nnoremap <expr>^         v:count ? "<CR>" : "^"
nnoremap <expr><leader>^ v:count ? "-"    : "^"
xnoremap <expr>^         v:count ? "<CR>" : "^"
xnoremap <expr><leader>^ v:count ? "-"    : "^"

nnoremap <expr>$         v:count ? "j$" : "$"
nnoremap <expr><leader>$ v:count ? "k$" : "$"
xnoremap <expr>$         v:count ? "j$" : "$"
xnoremap <expr><leader>$ v:count ? "k$" : "$"

" Could probably find better use for these, but ..

nnoremap + <C-A>
nnoremap - <C-X>
nnoremap _ :<C-U>call f#crosshair(v:count1)<CR>

" -- Fkeys ---------------------------------------------------------------- {{{2

FKeys {
  \ '<F1>':           ':call keys#flist("")',
  \ '<F2>':           ':call f#LocListToggle()',
  \ '<F3>':           ':NERDTreeToggle',
  \ '<F4>':           ':TagbarToggle',
  \ '<F5>':           ':CheatSheet',
  \ '<F9>':           ':Gstatus',
  \ '<F10>':          ':Dispatch',
  \ '<F11>':          ':Make',
  \ '<leader><F1>':   ':call keys#flist("<lt>leader>")',
  \ '<leader><F2>':   ':set relativenumber!',
  \ '<leader><F3>':   ':set cursorcolumn!',
  \ '<leader><F4>':   ':set hlsearch!',
  \ '<leader><F5>':   ':call f#ConcealToggle()',
  \ '<leader><F6>':   ':call f#ColorColumnToggle()',
  \ '<leader><F9>':   ':Gdiff',
  \ '<leader><F10>':  ':Dispatch!',
  \ '<leader><F11>':  ':Make!'
  \ }

" -- wrapping next/prev in location list ---------------------------------- {{{2

nnoremap <up>   :call f#LPrev()<CR>
nnoremap <down> :call f#LNext()<CR>

" -- Unusable keys -------------------------------------------------------- {{{2

 "<C-M> <CR>
 "<C-H> <BS>
 "<C-[> <ESC>
 "<C-I> <Tab>
 "<C-A> tmux mode key (insert previously inserted text and stop insert)
 "<C-Q> resume terminal
 "<C-C> break
 "<C-Z> kill/move to background


" == COMMANDS ============================================================= {{{1

command! -nargs=* Variations call f#Variations(<f-args>)<CR>
" see :he :DiffOrig
command! DiffOrig vert new | set bt=nofile | r++edit # | 0d_ | diffthis | wincmd p | diffthis
command! Exe !chmod +x %
command! ClearBuffers call f#ClearBuffers()<CR>

" == PLUGINS ============================================================== {{{1



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
      \ 'README.md': {
      \   'type': 'readme'
      \ }
    \ },
    \ 'CMakeLists.txt|Makefile': {
      \ 'CMakeLists.txt': {
      \   'type': 'cmake'
      \ },
      \ '*.c': {
      \   'alternate': '{}.h'
      \ },
      \ '*.cpp': {
      \  'alternate': ['{}.h', '{}.hpp']
      \ },
      \ '*.h' : {
      \   'alternate': ['{}.c', '{}.cpp', '{}.cxx' ]
      \ }
    \ },
    \ 'package.json': {
      \ 'package.json' : {
      \   'type': 'package'
      \ },
      \ 'jsconfig.json' : {
        \ 'type': 'jsconfig'
      \ }
    \ }
  \ })

" -- ALE ------------------------------------------------------------------ {{{2

let g:ale_sign_error = g:sym.gutter_error
let g:ale_sign_warning = g:sym.gutter_warning
let g:ale_sign_column_always = 1
let g:ale_echo_msg_format = '[%linter%] %code%: %s'

let g:ale_linters = {
      \ 'python': ['flake8'],
      \ 'sh': ['shellcheck'],
      \ 'vim': [],
      \ }

" highlight ALEWarning ctermfg=166
highlight ALEWarningSign ctermfg=166


" -- YOU COMPLETE ME ------------------------------------------------------ {{{2

"let g:ycm_filetype_whitelist = { '*': 1 }
" let g:ycm_filetype_blacklist = {
      " \ 'ruby': 1
      " \}
"let g:ycm_filetype_specific_completion_to_disable = {}
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1

let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_list_select_completion = ['<C-j>', '<Tab>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']

let g:ycm_max_num_candidates = 200

let g:ycm_global_ycm_extra_conf = expand('$HOME').'/.vim/ycm.py'
let g:ycm_extra_conf_vim_data = ['&filetype']
let g:ycm_config_extra_conf = 0

let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_use_ultisnips_completer = 0

let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:ycm_error_symbol = g:sym.gutter_error
let g:ycm_warning_symbol = g:sym.gutter_warning

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

nnoremap <leader>gg :YcmCompleter GoTo<CR>
nnoremap <leader>gt :YcmCompleter GetType<CR>
nnoremap <leader>gT :YcmCompleter GoToType<CR>
nnoremap <leader>gp :YcmCompleter GetParent<CR>
nnoremap <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gD :YcmCompleter GoToDeclaration<CR>

nnoremap <leader>g<space> :call keys#list({ 'filetype': '_ycm' })<CR>

FtKey '_ycm', '(ycm) GoTo',                '<leader>gg'
FtKey '_ycm', '(ycm) GoTo Type',           '<leader>gT'
FtKey '_ycm', '(ycm) GoTo References',     '<leader>gr'
FtKey '_ycm', '(ycm) GoTo Include',        '<leader>gi'
FtKey '_ycm', '(ycm) GoTo Definition',     '<leader>gd'
FtKey '_ycm', '(ycm) Goto Declaration',    '<leader>gD'

FtKey '_ycm', '(ycm) Get Type',            '<leader>gt'
FtKey '_ycm', '(ycm) Get Parent',          '<leader>gp'

" -- AIRLINE -------------------------------------------------------------- {{{2

nmap <left>    <Plug>AirlineSelectPrevTab
nmap <right>   <Plug>AirlineSelectNextTab

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" remove (fileencoding, fileformat)
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

" -- THEME ---------------------------------------------------------------- {{{3

" autoload/airline/themes/motoko.vim
let g:airline_theme = 'motoko'

" percentage, line number, column number
let g:airline_section_z = ''
let g:airline_mode_map = {
  \ '__' : '一',
  \ 'n'  : '常',
  \ 'i'  : '挿',
  \ 'R'  : '代',
  \ 'c'  : '令',
  \ 'v'  : '視',
  \ 'V'  : '視',
  \ '' : '視',
  \ 's'  : '選',
  \ 'S'  : '選',
  \ '' : '選',
  \}

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_symbols.branch    = '枝'
let g:airline_symbols.paste     = '貼'
let g:airline_symbols.linenr    = ''
let g:airline_symbols.maxlinenr = g:sym.line
let g:airline_symbols.notexists = '無'
let g:airline_symbols.readonly  = '読'

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
      \ '0': '零',
      \ '1': '一',
      \ '2': 'ニ',
      \ '3': '三',
      \ '4': '四',
      \ '5': '五',
      \ '6': '六',
      \ '7': '七',
      \ '8': '八',
      \ '9': '九'
      \}

" -- QUICKFIX ------------------------------------------------------------- {{{3

let g:airline#extensions#quickfix#quickfix_text = '直'
let g:airline#extensions#quickfix#location_text = '場'

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

" -- GIT GUTTER ----------------------------------------------------------- {{{2

let g:airline#extensions#hunks#enabled = 0

" -- WHITESPACE ----------------------------------------------------------- {{{3

let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#whitespace#symbol = ''
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'mixed-indent-file' ]
let g:airline#extensions#whitespace#trailing_format = g:sym.whitespace_trailing.'%s'.g:sym.line
let g:airline#extensions#whitespace#mixed_indent_format = g:sym.whitespace_tab.'%s'.g:sym.line
let g:airline#extensions#whitespace#mixed_indent_file_format = g:sym.whitespace_tab.g:sym.whitespace_trailing.'%s'.g:sym.line

" -- TAGBAR --------------------------------------------------------------- {{{2

let g:tagbar_iconchars = [ '+', '-' ]

" -- JSX ------------------------------------------------------------------ {{{2

" jsx highlight
let g:vim_jsx_pretty_enable_jsx_highlight = 1

" -- ECLIM ---------------------------------------------------------------- {{{2

" makes eclim play nice with YCM
let g:EclimCompletionMethod = 'omnifunc'

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
" folding
let g:ruby_fold = 0
" let ruby_foldable_ground = ' '
let g:ruby_no_expensive = 1

" let ruby_spellcheck_strings = 1

" -- VIM TABLE MODE ------------------------------------------------------- {{{2
" Markdown-compatible tables
let g:table_mode_corner = '|'

" -- ACK ------------------------------------------------------------------ {{{2
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

Key ':Ack (word under cursor)', '<leader>a/A'
nnoremap <leader>a :Ack

" -- FZF ------------------------------------------------------------------ {{{2

nnoremap <space>f :Files<CR>
nnoremap <space>g :GFiles<CR>
nnoremap <space>s :Snippets<CR>
nnoremap <space>t :BTags<CR>
nnoremap <space>p :Tags<CR>
nnoremap <space>h :History<CR>

" -- ULTISNIPS ------------------------------------------------------------ {{{2

let g:UltiSnipsExpandTrigger       = '<leader>l'
let g:UltiSnipsJumpForwardTrigger  = '<leader>j'
let g:UltiSnipsJumpBackwardTrigger = '<leader>k'

let g:UltiSnipsEditSplit           = 'horizontal'
let g:UltiSnipsSnippetsDirectories = [ '~/.vim/UltiSnips', 'UltiSnips' ]

" -- CALENDAR ------------------------------------------------------------- {{{2

let g:calendar_monday = 1
let g:calendar_wruler = '日 月 火 水 木 金 土'

" -- POLYGLOT ------------------------------------------------------------- {{{2
let g:polyglot_disabled = [
      \ 'markdown',
      \ 'lua',
      \ ]
" lua: bad syntax

" -- MARKDOWN ------------------------------------------------------------- {{{2

let g:markdown_fenced_languages = [
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

for [key, desc] in [
      \ [ '+', 'start task' ],
      \ [ '-', 'stop task' ],
      \ [ 'd', 'task done' ],
      \ [ 'C', 'calendar' ]
      \ ]
  FtKey 'vimwiki', '(vimwiki) '.desc, '<leader>t'.key
endfor

" -- EASY ALIGN ----------------------------------------------------------- {{{2

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

xmap <bar> gaip
nmap <bar> gaip

Key '(EasyAlign) Align operator',  'ga', 'nv'
Key '(EasyAlign) inner paragraph', '|',  'nv'

" -- ZEAVIM --------------------------------------------------------------- {{{2

Key '(Zeavim) Search word under cursor', '<leader>z', 'nv'
Key '(Zeavim) Search motion operator',   'gz'
Key '(Zeavim) Docset',                   '<leader><leader>z'

" don't know why these don't work in config

nmap <leader>z <Plug>Zeavim
vmap <leader>z <Plug>ZVVisSelection
nmap <leader><leader>z <Plug>ZVKeyDocset
nmap gz <Plug>ZVOperator

" -- GIT GUTTER ----------------------------------------------------------- {{{2

let g:gitgutter_sign_added              = g:sym.gutter_added
let g:gitgutter_sign_modified           = g:sym.gutter_modified
let g:gitgutter_sign_removed            = g:sym.gutter_removed
let g:gitgutter_sign_removed_first_line = g:sym.gutter_removed_first_line
let g:gitgutter_sign_modified_removed   = g:sym.gutter_modified_removed

let g:gitgutter_override_sign_column_highlight = 0

" -- SURROUND ------------------------------------------------------------- {{{2

xmap s <Plug>VSurround

" -- ABOLISH -------------------------------------------------------------- {{{2

Key '(abolish) Change to snake/camel/mixed/upper case', 'cr(s/c/m/u)'

" -- LanguageClient PROTO ------------------------------------------------- {{{2

" this thing is .. messy
call add(g:polyglot_disabled, 'ruby')
let g:LanguageClient_serverCommands = {
      \ 'ruby': ['solargraph', 'stdio']
      \ }

let g:LanguageClient_autoStop = 1
let g:LanguageClient_autoStart = 0

let g:LanguageClient_rootMarkers = {
  \ 'ruby': ['Gemfile']
  \}

augroup ruby_langserver
  autocmd!
  autocmd FileType ruby setlocal omnifunc=LanguageClient#complete
augroup END
