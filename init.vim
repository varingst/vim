" == PLUG ================================================================= {{{1
call f#plug_begin()

" -- Programmer QoL ------------------------------------------------------- {{{2

Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'w0rp/ale'                    " async syntax checker
Plug 'scrooloose/nerdcommenter'    " batch commenting +++
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }   " file navigator

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Code search, nav, vim-bling
Plug 'mileszs/ack.vim'             " code grepper (ag/ack) wapper
Plug 'majutsushi/tagbar', { 'on' : 'TagbarToggle' }
Plug 'junegunn/fzf.vim'            " fuzzy file, buffer, everything nav
Plug 'vim-airline/vim-airline'     " statusline
Plug 'vim-airline/vim-airline-themes'
Plug 'KabbAmine/zeavim.vim'        " doc lookup
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/camelcasemotion' " camelcase text objects
Plug 'junegunn/vim-easy-align'

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

" testing for neovim
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ }
" needs to run: 'bash install.sh',

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
      \ 'readonly':                  '読',
      \ 'quickfix':                  '直',
      \ 'location':                  '場',
      \ 'terminal':                  '端',
      \ 'query':                     '問',
      \ 'open':                      '+',
      \ 'close':                     '-',
      \ 'whitespace_trailing':       '§',
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
exe ':set conceallevel='.g:default_conceal_level
set concealcursor=nc         " conceal in normal and commandmode

set textwidth=80
set synmaxcol=128     " limit max number of columns to search for syntax items
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

  " Move fugitive preview to the bottom
  au FileType gitcommit wincmd J

  au FileType qf wincmd J

  " Dont show tabs in vim help, vsplit if space available
  au FileType help setlocal nolist | if winwidth('.') > 140 | wincmd L | endif

  au BufWinEnter ~/.vimrc,~/.config/nvim/init.vim,~/.vim/init.vim call
                 \ f#VimRcExtra()
  au BufWinEnter .eslintrc set filetype=json
augroup END

" == KEY MAPPING ========================================================== {{{1

" ~/.vim/autoload/keys.vim
call keys#init()

nnoremap <C-B> :call keys#list()<CR>

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

" <C-W><C-U> complement
inoremap <C-L> <C-O>d$

" jump to closest line matching <count>$
nnoremap <expr><CR> v:count ? f#G(v:count) : "<CR>"
xnoremap <expr><CR> v:count ? f#G(v:count) : "<CR>"

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

" -- Yank visual selection to register ------------------------------------ {{{2

vnoremap <silent><C-R> :<C-U>exe 'normal! gv"'.nr2char(getchar()).'y'<CR>

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

" -- Command mode mappings ------------------------------------------------ {{{2
" requires urxvt configuration, see ~/.Xresources
map  <ESC>[; <C-;>
map! <ESC>[; <C-;>
nnoremap <C-;> :

cmap w!! w !sudo tee % > /dev/null
cmap e!! silent Git checkout -- % <BAR> redraw!
cmap d!! r! date "+\%Y-\%m-\%d"
cnoremap <C-K> <up>
cnoremap <C-J> <down>
cnoremap <C-V> vsplit<space>
cnoremap <C-X> split<space>

" -- Normal jkJK ---------------------------------------------------------- {{{2

" j/k on visual lines, not actual lines
nnoremap j gj
nnoremap k gk
" navigate folds with J/K
nnoremap <expr><silent>J foldlevel('.') && foldclosed('.') != -1 ? "zo" : "zj"
nnoremap <expr><silent>K foldlevel('.') &&
      \ (foldclosed('.') == -1 <BAR><BAR> foldlevel('.') > 1) ? "zc" : "gk"
" join <count> lines
nnoremap <leader>j J
" lookup keyword under cursor with 'keywordprg'
nnoremap <leader>k K

Key 'join <count> lines', '<leader>j'

noremap <expr> H getcharsearch().forward ? ',' : ';'
noremap <expr> L getcharsearch().forward ? ';' : ','

" -- System Clipboard ----------------------------------------------------- {{{2

" TODO: "+ is Xwin clipboard, set this up for osx as well
nnoremap <leader><C-V> "+p
vnoremap <C-C> "+y
vnoremap <C-X> "+d

" -- Sticky Shift Camel Case Relief --------------------------------------- {{{2

Key 'Downcase last uppercase letter', '<leader>u', 'ni'
nnoremap <silent><leader>u :s/.*\zs\(\u\)/\L\1/<CR><C-O>
inoremap <silent><leader>u <ESC>:s/.*\zs\(\u\)/\L\1/<CR><C-O>a

" -- Function arguments join/break ---------------------------------------- {{{2

Key 'Break/Join function arguments', '<leader>f/F'
nnoremap <silent><leader>f :s/,/,\r/g<CR>$=%
nnoremap <silent><leader>F f(v%J

Key 'Break inline tag/properties',   '<leader>d/D'
nnoremap <silent><leader>d vit:s/\(\%V.*\%V\S\?\)\s*/\r\1\r/<CR>vat=
nnoremap <silent><leader>D md:s/\(\S\+\zs\s\+\\|\(\s*\ze\)>\)/\r/g<CR>v`d=

" -- Classes and methods -------------------------------------------------- {{{2

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
" N<space>_  - First char N-1 lines higher
" N$         - Last char N-1 lines lower
" N<space>_  - Last char N-1 lines higher

" TODO: operator-pending mode

noremap <expr><space>_ f#linewise(v:count, "-", "_")
noremap <expr><space>$ f#linewise(v:count, "k$", "$")

nnoremap + <C-A>
nnoremap - <C-X>
nnoremap ^ :<C-U>call f#crosshair(v:count1)<CR>

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

" == COMMANDS ============================================================= {{{1

command! -nargs=* Variations   call f#Variations(<f-args>)
command! -nargs=0 CloseBuffers call f#CloseBuffers()
command! -nargs=1 ScriptNames  call f#ScriptNames(<q-args>)
command! -nargs=1 Profile      call f#Profile(<q-args>)
command! -nargs=0 SynStack     echo join(f#SynStack(), "\n")

" see :he :DiffOrig
command! DiffOrig
      \   vert new
      \ | set bt=nofile
      \ | r++edit #
      \ | 0d_
      \ | diffthis
      \ | wincmd p
      \ | diffthis

command! Exe silent call system(printf('chmod +x "%s"', expand("%")))

command! -nargs=? -complete=file Open
      \ call netrw#BrowseX(
                  \ expand(strwidth(<q-args>) ? <q-args> : '%'),
                  \ netrw#CheckIfRemote())


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
  \ })

" -- ALE ------------------------------------------------------------------ {{{2

let g:ale_sign_error =         g:sym.gutter_error
let g:ale_sign_warning =       g:sym.gutter_warning
let g:ale_sign_column_always = 1
let g:ale_echo_msg_format =    '[%linter%] %code%: %s'

let g:gcc_flags = {
    \  'common': [
      \ '-Wall',
      \ '-Wextra',
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

let g:ale_linters = {
      \ 'python': ['flake8'],
      \ 'sh':     ['shellcheck'],
      \ 'vim':    [],
      \ 'c':      ['gcc'],
      \ }

let g:ale_c_gcc_options   = join(g:gcc_flags['common'] + g:gcc_flags['c'])
let g:ale_cpp_gcc_options = join(g:gcc_flags['common'] + g:gcc_flags['cpp'])

" temp fix for https://github.com/w0rp/ale/issues/1656#issuecomment-423017658
let g:ale_python_auto_pipenv = 0

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
let g:ycm_extra_conf_vim_data = [
      \ '&filetype',
      \ 'g:gcc_flags',
      \]
let g:ycm_config_extra_conf = 0

let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_use_ultisnips_completer = 0

let g:ycm_add_preview_to_completeopt = 0
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
      \ 'maxlinenr': g:sym.line,
      \ 'notexists': g:sym.nothing,
      \ 'readonly':  g:sym.readonly
      \})

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

" -- GIT GUTTER ----------------------------------------------------------- {{{2

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
if executable('ag')
  let g:ack_exe = 'ag'
  let g:ack_default_options =
        \ ' --silent --filename --numbers'.
        \ ' --nocolor --nogroup --column'
  let g:ack_options = '--vimgrep'
  let g:ack_whitelisted_options = g:ack_options.
        \ ' --literal --depth --max-count --one-device'.
        \ ' --case-sensitive --smart-case --unrestricted'
  let g:ack_use_dispatch = 1

  Key ':Ack (word under cursor)', '<leader>a/A'
  nnoremap <leader>a :Ack
else
  nnoremap <leader>a :echoerr "ag executable not found"<CR>
endif

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

for [key, desc] in [
      \ [ '+', 'start task' ],
      \ [ '-', 'stop task' ],
      \ [ 'd', 'task done' ],
      \ [ 'C', 'calendar' ]
    \ ]
  FtKey 'vimwiki', '(vimwiki) '.desc, '<leader>t'.key
endfor
nmap <leader><CR> <Plug>VimwikiVSplitLink

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
if v:false
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
endif

" vim: foldmethod=marker
