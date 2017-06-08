
" == PLUG ================================================================= {{{1

set nocompatible
filetype off

call plug#begin()

" -- Programmer QoL ------------------------------------------------------- {{{2

Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'scrooloose/syntastic'       " syntax checkers
Plug 'scrooloose/nerdcommenter'   " batch commenting +++
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }   " file navigator

Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Code search and nav
Plug 'mileszs/ack.vim'            " code grepper (ag/ack) wapper
Plug 'vim-scripts/taglist.vim'
Plug 'ctrlpvim/ctrlp.vim'         " file and buffer nav
Plug 'easymotion/vim-easymotion'

" Trailing whitespace
Plug 'vim-scripts/ingo-library'
Plug 'vim-scripts/ShowTrailingWhitespace'
Plug 'vim-scripts/CountJump'
Plug 'vim-scripts/JumpToTrailingWhitespace'
Plug 'vim-scripts/DeleteTrailingWhitespace'

" -- Programming languages ------------------------------------------------ {{{2

" Ruby
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'danchoi/ri.vim' " ri doc searcher

" Haskell
Plug 'bitc/vim-hdevtools'
Plug 'Twinside/vim-hoogle'
Plug 'eagletmt/neco-ghc'

" JavaScript and friends
Plug 'maxmellon/vim-jsx-pretty' | Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'nikvdp/ejs-syntax'
Plug 'othree/jspc.vim'                    " function parameter completion
Plug 'alexbyk/vim-ultisnips-react'        " react snippets

" VimScript
Plug 'tomtom/spec_vim'
Plug 'junegunn/vader.vim'
Plug 'h1mesuke/vim-unittest'

" -- Tim Pope obviously --------------------------------------------------- {{{2

Plug 'tpope/vim-fugitive'         " Git wrapper
Plug 'tpope/vim-surround'         " XML tags, brackets, quotes, etc
Plug 'tpope/vim-speeddating'      " increment/decrement dates +++
Plug 'tpope/vim-endwise'          " autoadd closing symbols (end/endif/endfun)
Plug 'tpope/vim-dispatch'         " Run builds and test suites
Plug 'tpope/vim-repeat'           " make '.' handle plugins nicer
Plug 'tpope/vim-abolish'          " Smarter substitution ++
Plug 'tpope/vim-fireplace'        " Clojure
Plug 'tpope/gem-ctags'            " RubyGems Automatic Ctags Invoker
" Ruby snaxx
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-projectionist' | Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'

" -- Markup, Template, Formatting, et al ---------------------------------- {{{2

Plug 'aklt/plantuml-syntax'       " plantuml
Plug 'vim-scripts/utl.vim'        " universal text linking
Plug 'gerw/vim-latex-suite'       " latex
Plug 'slim-template/vim-slim'     " slim html template lang
Plug 'vim-scripts/AnsiEsc.vim'    " ANSI color coding
Plug 'hail2u/vim-css3-syntax'     " Sass's SCSS syntax

" markdown
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular' | Plug 'dhruvasagar/vim-table-mode'
Plug 'JamshedVesuna/vim-markdown-preview' " preview github README.md

" orgmode
Plug 'jceb/vim-orgmode'
Plug 'vim-scripts/SyntaxRange'
Plug 'mattn/calendar-vim'

Plug 'nathanaelkane/vim-indent-guides'
Plug 'michaeljsmith/vim-indent-object'

" -- Homerolled ----------------------------------------------------------- {{{2

Plug '~/.vim/proto/vim-cheatsheet'

" }}}

call plug#end()

" == OPTIONS ============================================================== {{{1

filetype plugin indent on
syntax enable
set background=dark
let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
colorscheme solarized

set relativenumber        " number lines relative to current line
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
set foldtext=folding#Text()
set backspace=2                               " make backspace work like most other apps
set list                                      " vim builtin whitespace display
set listchars=tab:>-,trail:.,extends:#,nbsp:.
set conceallevel=2                            " conceal, replace if defined char
set concealcursor=nc                          " conceal in normal and commandmode
set textwidth=80

set viewoptions="cursor,folds"

set colorcolumn=81,+1,+2,130
set foldtext=do#FoldText()

" == AUTOCOMMANDS ========================================================= {{{1

" auto save and load folds, options, and cursor
au BufWinLeave *.* mkview
au BufWinEnter *.* silent! loadview

" Move quickfix window to the bottom
au FileType qf wincmd J

" Number in taglist window
"au BufWinEnter __Tag_List__ setlocal number

" Override matlab .m association
au BufRead,BufNewFile *.m setl filetype=objc

au FileType c,cpp,java,haskell setl shiftwidth=4 tabstop=4

au InsertEnter * highlight CursorLineNr term=bold ctermfg=Red
au InsertLeave * highlight CursorLineNr term=bold ctermfg=Yellow

" == HIGHLIGHTING ========================================================= {{{1

" folding highlighting
highlight Folded ctermfg=241 ctermbg=234 cterm=bold
" tab and trailing spaces
highlight SpecialKey ctermbg=none ctermfg=235
highlight ColorColumn ctermbg=232

highlight IndentGuidesOdd ctermbg=black
highlight IndentGuidesEven ctermbg=233

highlight ShowTrailingWhitespace ctermbg=red

" == KEY MAPPING ========================================================== {{{1

" -- Leader mapping
map ; <nop>
let mapleader   = ";"
let g:mapleader = ";"

map , <nop>
let maplocalleader = ","
let g:maplocalleader = ","

" -- Set fold markers " {{{2

inoremap <leader>1 <ESC>:call do#SetFoldMarker(1)<CR>A
inoremap <leader>2 <ESC>:call do#SetFoldMarker(2)<CR>A
inoremap <leader>3 <ESC>:call do#SetFoldMarker(3)<CR>A
inoremap <leader>4 <ESC>:call do#SetFoldMarker(4)<CR>A

nnoremap <leader>1 :call do#SetFoldMarker(1)<CR>
nnoremap <leader>2 :call do#SetFoldMarker(2)<CR>
nnoremap <leader>3 :call do#SetFoldMarker(3)<CR>
nnoremap <leader>4 :call do#SetFoldMarker(4)<CR>


" -- Faster file Saving --------------------------------------------------- {{{2

inoremap <leader>w <ESC>:w<CR>
nnoremap <leader>w :w<CR>

" -- Awkward symbol shorthands -------------------------------------------- {{{2
inoremap ,. ->
inoremap ., <-
inoremap ,, =>

" -- Insert mode insert line ---------------------------------------------- {{{2
inoremap <C-o> <ESC>O
inoremap <C-l> <ESC>o

" -- Copy next/previous line ---------------------------------------------- {{{2
"  .. how much do I really use these?
inoremap <silent><C-Y> <ESC>:call do#CopyLineUntil(-1)<CR>
inoremap <silent><C-E> <ESC>:call do#CopyLineUntil(1)<CR>
nnoremap <silent><C-Y> <ESC>:call do#AlignWithChar(-1)<CR>
nnoremap <silent><C-E> <ESC>:call do#AlignWithChar(1)<CR>

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
nnoremap <expr><silent>J foldlevel('.') && foldclosed('.') != -1 ? "za" : "zj"
nnoremap <expr><silent>K foldlevel('.') && (foldclosed('.') == -1 <BAR><BAR> foldlevel('.') > 1) ? "zc" : "gk"

nnoremap G Gzxzt

" -- Normal cC ------------------------------------------------------------ {{{2

nnoremap c" vi"c
nnoremap C" va"c
unlet! c
for c in split("'`(){}<>[]", '\zs')
  exe "nnoremap c".c." vi".c."c"
  exe "nnoremap C".c." va".c."c"
endfor

" -- Normal nN ------------------------------------------------------------ {{{2

nnoremap n nzx
nnoremap N Nzx

" -- Tabularize
nnoremap <bar> :Tabularize
nnoremap <leader><bar> :vsplit ~/.vim/after/plugin/tabular_extra.vim<CR>

" -- Split Window " {{{2
nnoremap <expr>S winwidth('.') > 160 ? ":vsplit " : ":split "
" replaces an 'cc' alias

" -- Linewise Movement " {{{2

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


" -- Fkeys ---------------------------------------------------------------- {{{2
nnoremap <F2> :Errors<CR>
inoremap <F2> <ESC>:Errors<CR>
nnoremap <F3> :set relativenumber!<CR>
nnoremap <F4> :set hlsearch!<CR>
nnoremap <F5> :CheatSheet<CR>
nnoremap <F6> :set cursorcolumn!<CR>

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
command! -nargs=* Variations call do#Variations(<f-args>)<CR>

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
let g:EasyMotion_do_mapping = 1
map <leader> <Plug>(easymotion-prefix)

nmap s <Plug>(easymotion-overwin-f2)

"map / <Plug>(easymotion-sn)
"omap / <Plug>(easymotion-tn)

let g:EasyMotion_smartcase = 1
" use uppercase target labels and type as a lower case
let g:EasyMotion_use_upper = 1

" -- SYNTASTIC / NEOMAKE -------------------------------------------------- {{{2
" passive filetypes uses clang or eclim instead
let g:syntastic_mode_map = { 'mode': 'active',
        \ 'passive_filetypes': ['c', 'm', 'objc', 'cpp', 'java' ] }
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

let g:syntastic_javascript_checkers = [ 'eslint' ]


" Use the jump list movement keys to navigate
" the syntactic error list, if it exists and has errors

nnoremap <expr><silent><C-I> exists("b:syntastic_loclist") && len(b:syntastic_loclist._rawLoclist) ? ":lnext<CR>" : "<C-I>"
nnoremap <expr><silent><C-O> exists("b:syntastic_loclist") && len(b:syntastic_loclist._rawLoclist) ? ":lprev<CR>" : "<C-O>"

" -- YOU COMPLETE ME ------------------------------------------------------ {{{2

"let g:ycm_filetype_whitelist = { '*': 1 }
"let g:ycm_filetype_blacklist = { 'notes' : 1, 'markdown' : 1, 'text' :1 }
"let g:ycm_filetype_specific_competion_to_disable = {}
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1

"let g:ycm_key_invoke_completion = '<C-P>'
let g:ycm_key_list_select_completion = ['<C-j>', '<Tab>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
let g:ycm_key_detailed_diagnostics = '<leader>y'

"let g:ycm_global_ycm_extra_conf = ''
let g:ycm_config_extra_conf = 0
"let g:ycm_extra_conf_globlist = []
"rules:: * ? [seq] [!seq]

let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

let s:dot_triggers = join([
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
      \ 'vim' ], ',')


let g:ycm_semantic_triggers = {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   s:dot_triggers : ['.'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
unlet! s:dot_triggers

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

" -- VIM TABLE MODE ------------------------------------------------------- {{{2
" Markdown-compatible tables
let g:table_mode_corner = '|'

" -- ACK ------------------------------------------------------------------ {{{2
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
nmap <leader>a :Ack

" -- CTRL-P --------------------------------------------------------------- {{{2
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ -g ""'

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

let g:org_agenda_files = [ '~/.org/*.org' ]

" -- MARKDOWN PREVIEW ----------------------------------------------------- {{{2
let vim_markdown_preview_github = 1
let vim_markdown_preview_use_xdg_open = 1

" -- RI ---- {{{2
let g:ri_no_mappings = 1

" -- NERDCommenter
let g:NERDSpaceDelims = 0
