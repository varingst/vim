
" == PLUG ================================================================= {{{1

set nocompatible
" filetype off

call plug#begin()

" -- Programmer QoL ------------------------------------------------------- {{{2

Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'scrooloose/syntastic'       " syntax checkers
Plug 'scrooloose/nerdcommenter'   " batch commenting +++
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }   " file navigator

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Code search, nav, vim-bling
Plug 'mileszs/ack.vim'            " code grepper (ag/ack) wapper
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'         " file and buffer nav
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'    " statusline
Plug 'vim-airline/vim-airline-themes'

" Trailing whitespace
Plug 'vim-scripts/ingo-library'
Plug 'vim-scripts/ShowTrailingWhitespace'
Plug 'vim-scripts/CountJump'
Plug 'vim-scripts/JumpToTrailingWhitespace'
Plug 'vim-scripts/DeleteTrailingWhitespace'
Plug 'vim-scripts/camelcasemotion' " camelcase text objects

" -- Programming languages ------------------------------------------------ {{{2

" Ruby
Plug 'vim-ruby/vim-ruby'
Plug 'danchoi/ri.vim' " ri doc searcher

" Haskell
Plug 'bitc/vim-hdevtools'
Plug 'Twinside/vim-hoogle'
Plug 'eagletmt/neco-ghc'

" JavaScript and friends
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'nikvdp/ejs-syntax'
Plug 'othree/jspc.vim'                        " function parameter completion
Plug 'othree/javascript-libraries-syntax.vim' " For underscore, angular, react, etc
Plug 'alexbyk/vim-ultisnips-react'        " react snippets
Plug 'moll/vim-node'

" Is this required with YCM ?
" Plug 'ternjs/tern_for_vim'

" VimScript
Plug 'tomtom/spec_vim'
Plug 'junegunn/vader.vim'
Plug 'h1mesuke/vim-unittest'

" Lua
" Plug 'xolox/vim-lua-ftplugin' | Plug 'xolox/vim-misc'

" -- Tim Pope obviously --------------------------------------------------- {{{2

Plug 'tpope/vim-fugitive'         " Git wrapper
Plug 'tpope/vim-surround'         " XML tags, brackets, quotes, etc
Plug 'tpope/vim-speeddating'      " increment/decrement dates +++
Plug 'tpope/vim-endwise'          " autoadd closing symbols (end/endif/endfun)
Plug 'tpope/vim-dispatch'         " Run builds and test suites
Plug 'tpope/vim-repeat'           " make '.' handle plugins nicer
Plug 'tpope/vim-abolish'          " Smarter substitution ++
Plug 'tpope/vim-fireplace'        " Clojure
" Ruby snaxx
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rbenv'            " Tell vim to use the right ruby
Plug 'tpope/gem-ctags'            " RubyGems Automatic Ctags Invoker

" -- Markup, Template, Formatting, et al ---------------------------------- {{{2

Plug 'aklt/plantuml-syntax'        " plantuml
Plug 'vim-scripts/utl.vim'         " universal text linking
Plug 'gerw/vim-latex-suite'        " latex
Plug 'slim-template/vim-slim'      " slim html template lang
Plug 'powerman/vim-plugin-AnsiEsc' " ANSI color coding
Plug 'hail2u/vim-css3-syntax'      " Sass's SCSS syntax
Plug 'othree/html5-syntax.vim'     " handles HTML5 syntax highlighting
Plug 'othree/html5.vim'            " HTML5 autocomplete
Plug 'groenewege/vim-less'         " indentation, completion
" may need:
" autocmd BufNewFile,BufRead *.less set filetype=less
" autocmd FileType less set omnifunc=csscomplete#CompleteCSS
" Check how this work with YCM

" markdown
Plug 'plasticboy/vim-markdown'
Plug 'dhruvasagar/vim-table-mode'
Plug 'godlygeek/tabular'
Plug 'chmp/mdnav'
Plug 'JamshedVesuna/vim-markdown-preview' " preview github README.md

" Todo/Project
Plug 'vim-scripts/SyntaxRange'
Plug 'mattn/calendar-vim'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'tbabej/taskwiki'
Plug 'farseer90718/vim-taskwarrior'

" grammar
Plug 'rhysd/vim-grammarous'

Plug 'nathanaelkane/vim-indent-guides'
Plug 'michaeljsmith/vim-indent-object'

" -- Homerolled ----------------------------------------------------------- {{{2

Plug '~/.vim/proto/vim-cheatsheet'

" }}}

call plug#end()

runtime macros/matchit.vim

" == OPTIONS ============================================================== {{{1

" vim-plug do these automatically
" filetype plugin indent on
" syntax enable

set background=dark
let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
colorscheme solarized

" this is sloooooooooooooooooooooow ...
" set relativenumber        " number lines relative to current line
set number                " current line numbered
set scrolloff=5
set wildmode=longest,list " bash style completion
set nomore                " remove more message after shell command
set winminheight=0        " windows may be minimized down to just a status bar
set splitright
set completeopt=menuone   " use popupmenu also with just one match

if &modifiable && !has("nvim")
  set fileencoding=utf-8
  set encoding=utf-8
  set termencoding=utf-8
endif
set noswapfile

set title        " set terminal title
set visualbell   " dont beep
set noerrorbells " dont beep
set ttimeout

set history=1000    " command and search history
set undolevels=1000

set hlsearch     " highlight search terms
set incsearch    " show matches as you type
set ignorecase   " ignore case when searching
set smartcase    " case-insensitive when all lowercase
set nolazyredraw " don't redraw while executing macros
set magic        " set magic on for regex
set hidden       " hides buffers instead of closing on new open

" -- Statusline ----------------------------------------------------------- {{{2
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%{exists('g:loaded_fugitive')?fugitive#statusline():''}
set statusline+=%h%m%r%w                     " flags
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%#warningmsg#
set statusline+=%{exists('g:loaded_syntastic_plugin')?SyntasticStatuslineFlag():''}
set statusline+=%*
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset
set laststatus=2
set showtabline=2 " Always show tabline
" }}}

set autoindent                                " auto indenting
set tabstop=2                                 " set tab character to 2 characters
set shiftwidth=2                              " ident width for autoindent
set expandtab                                 " turn tabs into whitespace
filetype indent on                            " indent depends on filetype
set foldmethod=marker                         " type of folding
set foldtext=f#FoldText()
set backspace=2                               " make backspace work like most other apps
set list                                      " vim builtin whitespace display
set listchars=tab:├─,trail:.,extends:#,nbsp:.
set conceallevel=2                            " conceal, replace if defined char
set concealcursor=nc                          " conceal in normal and commandmode
set textwidth=80
set iskeyword=@,48-57,_,192-255,-

set viewoptions="cursor,folds"

" set colorcolumn=81,+1,+2,130
" limit max number of columns to search for syntax items
set synmaxcol=128
" send more chars to screen for redrawing
set ttyfast
" don't redraw while macro is executed
set lazyredraw

" == AUTOCOMMANDS ========================================================= {{{1

" auto save and load folds, options, and cursor
au BufWinLeave *.* mkview
au BufWinEnter *.* silent! loadview

" Move quickfix window to the bottom
au FileType qf wincmd J

" Move fugitive preview to the bottom
au FileType gitcommit wincmd J

" Number in taglist window
"au BufWinEnter __Tag_List__ setlocal number

" Override matlab .m association
au BufRead,BufNewFile *.m setl filetype=objc

au BufRead,BufNewFile .eslintrc,*.tern-config set filetype=json

au FileType c,cpp,java,haskell setl shiftwidth=4 tabstop=4

au InsertEnter * highlight CursorLineNr term=bold ctermfg=Red
au InsertLeave * highlight CursorLineNr term=bold ctermfg=Yellow

au BufWinEnter ~/.vimrc,~/.config/nvim/init.vim call f#VimRcExtra()

" == HIGHLIGHTING ========================================================= {{{1

" folding highlighting
highlight Folded ctermfg=241 ctermbg=234 cterm=bold
" tab and trailing spaces
highlight SpecialKey ctermbg=none ctermfg=235
highlight ColorColumn ctermbg=232

highlight ShowTrailingWhitespace ctermbg=red

" == KEY MAPPING ========================================================== {{{1
"
call keys#clear()

" -- Leader mapping
map ; <nop>
let mapleader   = ";"
let g:mapleader = ";"

map , <nop>
let maplocalleader = ","
let g:maplocalleader = ","
inoremap <leader><ESC> ;<ESC>

inoremap <C-@> <C-Space>
inoremap <C-O><C-O> <C-O>O

nnoremap <C-B> :call keys#list()<CR>

" -- completion menu navigation
" inoremap <expr><C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
" inoremap <expr><C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>"   : "\<C-u>"


" -- Set fold markers ----------------------------------------------------- {{{2

" TODO: fix setfoldmarker(0)
nnoremap z0 :call f#SetFoldMarker(0)<CR>
nnoremap z1 :call f#SetFoldMarker(1)<CR>
nnoremap z2 :call f#SetFoldMarker(2)<CR>
nnoremap z3 :call f#SetFoldMarker(3)<CR>
nnoremap z4 :call f#SetFoldMarker(4)<CR>

call keys#add('z<0-4>', 'Set foldlevel with marker')

" nnoremap <leader>1 :call f#SetFoldMarker(1)<CR>
" nnoremap <leader>2 :call f#SetFoldMarker(2)<CR>
" nnoremap <leader>3 :call f#SetFoldMarker(3)<CR>
" nnoremap <leader>4 :call f#SetFoldMarker(4)<CR>


" -- Faster file Saving --------------------------------------------------- {{{2

inoremap <leader>w <ESC>:w<CR>
nnoremap <leader>w :w<CR>

" -- Awkward symbol shorthands -------------------------------------------- {{{2
inoremap ,. ->
inoremap ., <-
inoremap ,, =>
inoremap <> </><ESC>2ha

" -- Swap quotes ---------------------------------------------------------- {{{2

inoremap <leader>' <ESC>:silent s/[^\\]\zs"/%%%/ge \| s/[^\\]\zs'/"/ge \| s/%%%/'/ge<CR>
nnoremap <leader>' :silent s/[^\\]\zs"/%%%/ge \| s/[^\\]\zs'/"/ge \| s/%%%/'/ge<CR>
inoremap <leader>" <ESC>:silent s/[^\\]/zs"/'/ge<CR>
nnoremap <leader>" :silent s/[^\\]/zs"/'/ge<CR>

" -- Insert mode insert line ---------------------------------------------- {{{2


" inoremap <C-o> <ESC>O
" inoremap <C-l> <ESC>o

" -- Copy next/previous line ---------------------------------------------- {{{2
"  .. how much do I really use these?
"
call keys#add('<C-Y>', 'i', 'Copy the line above, until char <c>')
call keys#add('<C-E>', 'i', 'Copy the line below, until char <c>')
inoremap <silent><C-Y> <ESC>:call f#CopyLineUntil(-1)<CR>
inoremap <silent><C-E> <ESC>:call f#CopyLineUntil(1)<CR>


call keys#add('<C-Y', 'Align current line with first char <c> in  the line above')
call keys#add('<C-E', 'Align current line with first char <c> in  the line below')
nnoremap <silent><C-Y> <ESC>:call f#AlignWithChar(-1)<CR>
nnoremap <silent><C-E> <ESC>:call f#AlignWithChar(1)<CR>


" -- Command mode mappings ------------------------------------------------ {{{2

" forgot to sudo? force it with w!!
cmap w!! w !sudo tee % > /dev/null
cnoremap <C-k> <up>
cnoremap <C-j> <down>

" -- Normal jkJKG --------------------------------------------------------- {{{2

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

call keys#add('<leader>j', 'join <count> lines')

nnoremap G Gzxzt

" -- Normal cC ------------------------------------------------------------ {{{2

unlet! c
for c in split("\"'`(){}<>[]", '\zs')
  exe "nnoremap c".c." vi".c."c"
  exe "nnoremap C".c." va".c."c"
endfor

" -- Normal nN ------------------------------------------------------------ {{{2

nnoremap n nzx
nnoremap N Nzx

" -- normal ftFT -> LH ---------------------------------------------------- {{{2

" L and H repeats next char, but H always <- and L always ->

nnoremap <silent> f :nnoremap H ,<CR>:nnoremap L ;<CR>f
nnoremap <silent> F :nnoremap H ;<CR>:nnoremap L ,<CR>F
nnoremap <silent> t :nnoremap H h,<CR>:nnoremap L l;<CR>t
nnoremap <silent> T :nnoremap H h;<CR>:nnoremap L l;<CR>T

" -- Tabularize ----------------------------------------------------------- {{{2
nnoremap <expr><bar> ":Tabularize "
vnoremap <expr><bar> ":Tabularize "
nnoremap <leader><bar> :vsplit ~/.vim/after/plugin/tabular_extra.vim<CR>
call keys#add('|', 'nv', ':Tabularize')
call keys#add('<leader>|', ':Tabularize: edit tabular_extra')


" -- Split Window --------------------------------------------------------- {{{2
nnoremap <expr>S winwidth('.') > 160 ? ":vsplit " : ":split "
" replaces an 'cc' alias

" -- Error List Navigation ------------------------------------------------ {{{2
"
" Use the jump list movement keys to navigate
" the syntactic error list, if it exists and has errors

nnoremap <expr><silent><C-I> f#ErrorsVisible()
      \ ? ":call f#LNext()<CR>" : "<C-I>"
nnoremap <expr><silent><C-O> f#ErrorsVisible()
      \ ? ":call f#LPrev()<CR>" : "<C-O>"

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
" <CR>    - First CHAR N lines lower

" N+      - End of line N lines lower
" N$      - End of line N-1 lines lower
" N_      - End of line N lines higher

" The Fix:

nnoremap ^ _
nnoremap + $j$
nnoremap _ -$

vnoremap ^ _
vnoremap + $j$
vnoremap _ -$

" Change <CR> to work with absolute line numbers
nnoremap <CR> G
vnoremap <CR> G

" -- Fkeys ---------------------------------------------------------------- {{{2

call f#MapFkeys({
      \ '<F1>':         ':call f#ListFkeys()',
      \ '<F2>':         ':Errors',
      \ '<F3>':         ':set relativenumber!',
      \ '<F4>':         ':set hlsearch!',
      \ '<F5>':         ':CheatSheet',
      \ '<F6>':         ':set cursorcolumn!',
      \ '<F7>':         ':set paste!',
      \ '<F8>':         ':TagbarToggle',
      \ '<F9>':         ':call f#ConcealToggle()',
      \ '<F10>':        ':Gstatus',
      \ })

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
command! -nargs=? -complete=file Open call f#Open(<f-args>)
" see :he :DiffOrig
command! DiffOrig vert new | set bt=nofile | r++edit # | 0d_ | diffthis | wincmd p | diffthis
command! Exe !chmod +x %

" == PLUGINS ============================================================== {{{1

" -- CHEATSHEET ----------------------------------------------------------- {{{2

let g:cheatsheet_filetype_redirect = {
      \ 'sh': 'bash',
      \ 'org': 'vim-orgmode'
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

" -- EASYMOTION ----------------------------------------------------------- {{{2

map <space> <Plug>(easymotion-prefix)

" disable syntax shading (slow)
let g:EasyMotion_do_shade = 0

call keys#add('<space> j/k', "(EasyMotion) Select first char up/down")
call keys#add('<space> s',   "(EasyMotion) Find chard forward and backward")

let g:EasyMotion_smartcase = 1
" use uppercase target labels and type as a lower case
let g:EasyMotion_use_upper = 1

" -- SYNTASTIC / NEOMAKE -------------------------------------------------- {{{2
" passive filetypes uses clang or eclim instead
let g:syntastic_mode_map = {
      \ 'mode': 'active',
      \ 'passive_filetypes': ['c', 'm', 'objc', 'cpp', 'java' ]
      \ }

" NOTE: this hooks into CursorMoved and filters the error list.
" With huge error lists this will be choke vim to a halt.
" Set this to 0 and restart if Syntastic is to be running
let g:syntastic_echo_current_error = 1

" auto close, but no auto open
let g:syntastic_auto_loc_list = 2
" jump to fist error on open or save

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" when running multiple checkers, put all errors in one window
let g:syntastic_aggregate_errors = 1

"let g:syntastic_auto_jump=1
" statusline format: [Err: 20 #5, Warn: 10 #1] .. 20 errors, first on line 5
let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
let g:syntastic_enable_balloons = 0

let g:syntastic_lua_checkers = [ 'luacheck' ]
let g:syntastic_lua_luacheck_args = "--codes"

" use this over the standard 'sh' checker
let g:syntastic_sh_checkers = [ 'bashate' ]

let g:syntastic_haskell_checkers = [ 'hdevtools', 'hlint' ]

let g:syntastic_ruby_checkers = [ 'mri', 'rubocop' ]
let g:syntastic_ruby_rubocop_args = "-D"

let g:syntastic_python_checkers = [ 'python', 'pylint' ]

let g:syntastic_javascript_checkers = [ 'eslint' ]



" -- YOU COMPLETE ME ------------------------------------------------------ {{{2

"let g:ycm_filetype_whitelist = { '*': 1 }
" let g:ycm_filetype_blacklist = {
      " \ 'lua' : 1
      " \}
"let g:ycm_filetype_specific_competion_to_disable = {}
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1

let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_key_list_select_completion = ['<C-j>', '<Tab>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
let g:ycm_key_detailed_diagnostics = '<leader>y'

let g:ycm_max_num_candidates = 100

"let g:ycm_global_ycm_extra_conf = ''
let g:ycm_config_extra_conf = 0
"let g:ycm_extra_conf_globlist = []
"rules:: * ? [seq] [!seq]

let g:ycm_add_preview_to_completeopt = 1
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
unlet! s:dot_triggers

" -- AIRLINE -------------------------------------------------------------- {{{2

let g:airline_theme = 'motoko'

let g:airline_section_z = ''
let g:airline#extensions#whitespace#enabled = 0
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

let g:airline_symbols.branch = '別'
let g:airline_symbols.paste = '貼'
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = '行'
let g:airline_symbols.notexists = '無'
let g:airline_symbols.readonly = '読'


let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#buffer_nr_format = '%s '
let g:airline#extensions#tabline#buffer_idx_mode = 1
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
let g:airline#extensions#tabline#show_close_button = 0

let g:airline#extensions#ycm#error_symbol = '誤'
let g:airline#extensions#ycm#warning_symbol = '戒'

" remove (fileencoding, fileformat)
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

nmap <leader>h <Plug>AirlineSelectPrevTab
nmap <leader>l <Plug>AirlineSelectNextTab
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

call keys#add('<leader>h/l', "(Airline) Switch buffer next/prev")
call keys#add('<leader>1-9', "(Airline) Switch to buffer (1-9)")

" -- TAGBAR --------------------------------------------------------------- {{{2

" let g:tagbar_type_javascript = {
      " \ 'ctagstype': 'js'
      " \ }

let g:tagbar_iconchars = [ 'v', '>' ]

" -- JSX ------------------------------------------------------------------ {{{2

" jsx highlight
let g:vim_jsx_pretty_enable_jsx_highlight = 1

" -- ECLIM ---------------------------------------------------------------- {{{2

" makes eclim play nice with YCM
let g:EclimCompletionMethod = 'omnifunc'

" -- LATEX ---------------------------------------------------------------- {{{2
let g:tex_flavor='latex'
set grepprg=grep\ -nH\ $*
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf, aux'
let g:Imap_UsePlaceHolders = 0
let g:Imap_FreezeImap = 1 " Turn off ANNOYING AUTO INPUT CRAP

" -- VIM-RUBY -------------------------------------------------------------- {{{2
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
let ruby_fold = 1
" let ruby_foldable_ground = ' '
let ruby_no_expensive = 1

" let ruby_spellcheck_strings = 1

" -- VIM TABLE MODE ------------------------------------------------------- {{{2
" Markdown-compatible tables
let g:table_mode_corner = '|'

" -- ACK ------------------------------------------------------------------ {{{2
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
nmap <leader>a :Ack

" -- CTRL-P --------------------------------------------------------------- {{{2
let g:ctrlp_extensions = ['tag', 'buffertag']
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ -g ""'

" open new files in vertical split
let g:ctrlp_open_new_file = 'v'

call keys#add('<C-F><C-B>', "(ctrlp) Cycle modes")
call keys#add('<C-J><C-K>', "(ctrlp) Down/Up in list")
call keys#add('<C-X>', "(ctrlp) Open in horizontal split")
call keys#add('<C-V>', "(ctrlp) Open in vertical split")
call keys#add('<C-T>', "(ctrlp) Open in new tab")
call keys#add('<C-Y>', "(ctrlp) Open new file")

" -- ULTISNIPS ------------------------------------------------------------ {{{2

let g:UltiSnipsExpandTrigger = "<leader>l"
let g:UltiSnipsListSnippets = "<leader><tab>"
let g:UltiSnipsJumpForwardTrigger = "<leader>j"
let g:UltiSnipsJumpBackwardTrigger = "<leader>k"

let g:UltiSnipsEditSplit = 'horizontal'
let g:UltiSnipsSnippetsDirectories = [ '~/.vim/UltiSnips', 'UltiSnips' ]


" -- CALENDAR ------------------------------------------------------------- {{{2

let g:calendar_monday = 1
let g:calendar_wruler = "日 月 火 水 木 金 土"

" -- ORGMODE -------------------------------------------------------------- {{{2

let g:org_agenda_files = [ '~/.org/agenda.org' ]

" -- MARKDOWN PREVIEW ----------------------------------------------------- {{{2
let vim_markdown_preview_github = 1
let vim_markdown_preview_use_xdg_open = 1

" -- RI ---- {{{2
let g:ri_no_mappings = 1

call keys#add_ft('ruby', '<leader>ri', 'ri search prompt')
call keys#add_ft('ruby', '<leader>rw', 'ri lookup name under cursor')

" -- NERDCommenter " {{{2
let g:NERDSpaceDelims = 1
let g:NERDRemoveExtraSpaces = 1

" -- VimWiki/TaskWIki " {{{2

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
  call keys#add_ft('vimwiki', '<leader>t'.key, '(vimwiki) '.desc)
endfor

" -- UTL ----- {{{2
let g:utl_cfg_hdl_scm_http_system = "silent !firefox-bin '%u' &"
