
" ========== PLUG ========== " {{{1

set nocompatible
filetype off

call plug#begin()

Plug 'Valloric/YouCompleteMe'
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'vim-scripts/taglist.vim'

Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'

" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" plantuml
Plug 'aklt/plantuml-syntax'

" scrum, DEP: plasticboy/vim-markdown
Plug 'mmai/vim-markdown-wiki' | Plug 'mmai/vim-scrum-markdown'

" -- the mightly tim pope quality of life section -- {{{2
" Git wrapper
Plug 'tpope/vim-fugitive'
" XML tags, brackets, quotes, etc
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
" adding endfunction/endif/end in vimscript, ruby, bourne shell, etc, etc
Plug 'tpope/vim-endwise'
" Run builds and test suites
Plug 'tpope/vim-dispatch'
" make '.' handle plugins nicer
Plug 'tpope/vim-repeat'
" Smarter substitution ++
Plug 'tpope/vim-abolish'
" Ruby snaxx
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-projectionist' | Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'
" RubyGems Automatic Ctags Invoker
Plug 'tpope/gem-ctags'
Plug 'tpope/vim-fireplace'
" --- }}}

Plug 'godlygeek/tabular' | Plug 'dhruvasagar/vim-table-mode'
" markdown, DEP: godlygeek/tabular
Plug 'plasticboy/vim-markdown'

" ri doc searcher
Plug 'danchoi/ri.vim'
" code grepper (ag/ack) wapper
Plug 'mileszs/ack.vim'

" lusty exploration
Plug 'vim-scripts/LustyJuggler'

Plug 'ctrlpvim/ctrlp.vim'

" f/t enhancer/easymotion replacement
Plug 'justinmk/vim-sneak'

Plug 'nathanaelkane/vim-indent-guides'
Plug 'michaeljsmith/vim-indent-object'

" universal text linking
Plug 'vim-scripts/utl.vim'

" ANSI color coding
Plug 'vim-scripts/AnsiEsc.vim'

" orgmode
Plug 'jceb/vim-orgmode'
Plug 'vim-scripts/SyntaxRange'
Plug 'mattn/calendar-vim'

" vim testing
Plug 'tomtom/spec_vim'
Plug 'junegunn/vader.vim'
Plug 'h1mesuke/vim-unittest'

" Language support
Plug 'gerw/vim-latex-suite'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'leafgarland/typescript-vim'
Plug 'bitc/vim-hdevtools'
Plug 'Twinside/vim-hoogle'
Plug 'eagletmt/neco-ghc'

" slim
Plug 'slim-template/vim-slim'

" Sass's SCSS syntax
Plug 'hail2u/vim-css3-syntax'

" Trailing whitespace
Plug 'vim-scripts/ShowTrailingWhitespace'
Plug 'vim-scripts/CountJump'
Plug 'vim-scripts/JumpToTrailingWhitespace'
Plug 'vim-scripts/DeleteTrailingWhitespace'

" Homerolled prototypes
"Plug '~/dev/cheatsheet'
Plug '~/.vim/proto/vim-cheatsheet'

call plug#end()

" ========== OPTIONS ========= " {{{1
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

" Statusline {{{2
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

" ========== AUTOCOMMANDS ========== {{{1

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
" autosourcing vim files
" au BufWritePost .vimrc source ~/.vimrc
" au BufWritePost *.vim source %
" ========== HIGHLIGHTING ========== {{{1
" folding highlighting
highlight Folded ctermfg=241 ctermbg=234 cterm=bold
" tab and trailing spaces
highlight SpecialKey ctermbg=none ctermfg=235
highlight ColorColumn ctermbg=232

highlight IndentGuidesOdd ctermbg=black
highlight IndentGuidesEven ctermbg=233

" ========== KEY MAPPING ========== {{{1
" remapping <Leader> to ;
map ; <nop>
let mapleader   = ";"
let g:mapleader = ";"

map , <nop>
let maplocalleader = ","
let g:maplocalleader = ","


" use default local leader: \

" Make arrow keys useful
map <up> <C-W>k
map <down> <C-W>j
map <left> <C-W>h
map <right> <C-W>l

"inoremap <C-C> <ESC>
inoremap ,. ->
inoremap ., <-

" Copy next/previous line " {{{2
inoremap <silent><C-Y> <ESC>:call do#CopyLineUntil(-1)<CR>
inoremap <silent><C-E> <ESC>:call do#CopyLineUntil(1)<CR>
nnoremap <silent><C-Y> <ESC>:call do#AlignWithChar(-1)<CR>
nnoremap <silent><C-E> <ESC>:call do#AlignWithChar(1)<CR>
 
" Command mode mappings {{{2
" forgot to sudo? force it with w!!
cmap w!! w !sudo tee % > /dev/null
cnoremap <C-k> <up>
cnoremap <C-j> <down>


" Normal jkJK {{{2

" j/k on visual lines, not actual lines
nnoremap j gj
nnoremap k gk
" navigate folds with J/K
nnoremap <expr><silent>J foldlevel('.') && foldclosed('.') != -1 ? "za" : "zj"
nnoremap <expr><silent>K foldlevel('.') && (foldclosed('.') == -1 <BAR><BAR> foldlevel('.') > 1) ? "zc" : "gk"

nnoremap G Gzxzt


" Normal cC : select inside (char) {{{2

nnoremap c" vi"c
nnoremap C" va"c
unlet! c
for c in split("'`(){}<>[]", '\zs')
  exe "nnoremap c".c." vi".c."c"
  exe "nnoremap C".c." va".c."c"
endfor

" Normal /? {{{2

nnoremap n nzx
nnoremap N Nzx
nnoremap / :set hlsearch<CR>/
nnoremap ? :set hlsearch<CR>?
nnoremap <silent><F4> :set hlsearch!<CR>

autocmd InsertEnter * set nohlsearch

" Normal Space {{{2

nnoremap <localleader>- :split %<CR>
nnoremap <localleader>= :vsplit %<CR>

" Tab next and prev {{{2

" TabNext - Go to next tab page
nnoremap <C-l> gt
" TabPrev - Got to previous tab page
nnoremap <C-h> gT


" Unusable keys :: {{{2
"-------------------------------------------------------------------------------

" <C-M> <CR>
" <C-H> <BS>
" <C-[> <ESC>
" <C-I> <Tab>
" <C-A> tmux mode key (insert previously inserted text and stop insert)
" <C-Q> resume terminal
" <C-C> break
" <C-Z> kill/move to background


" ========== PLUGINS ========== {{{1
" === CHEATSHEET === {{{2
nnoremap <silent> <F10> :CheatSheet<CR>

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
" === EASYMOTION === {{{2
" {{{
let g:EasyMotion_do_mapping = 1
map <Space> <Plug>(easymotion_prefix)

" === SNEAK === {{{2

map H <Plug>SneakPrevious
map L <Plug>SneakNext

nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
xmap f <Plug>Sneak_f
xmap F <Plug>Sneak_F
omap f <Plug>Sneak_f
omap F <Plug>Sneak_F

nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T
xmap t <Plug>Sneak_t
xmap T <Plug>Sneak_T
omap t <Plug>Sneak_t
omap T <Plug>Sneak_T


" === SYNTASTIC / NEOMAKE === {{{2
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

" use this over the standard 'sh' checker
let g:syntastic_sh_checkers = [ 'bashate' ]

let g:syntastic_haskell_checkers = [ 'hdevtools', 'hlint' ]

let g:syntastic_ruby_checkers = [ 'mri', 'rubocop' ]
let g:syntastic_ruby_rubocop_args = "-D"

" .. why? is this here
nnoremap <F2> :Errors<CR>
inoremap <F2> <ESC>:Errors<CR>
nnoremap <F3> :set relativenumber!<CR>
nnoremap <F5> :CheatSheet<CR>

" this needs to change! throws so much errors. move the login into the function
" you damned nub
"nnoremap <expr> <silent> <C-I> len(b:syntastic_loclist) > 0 ? ":call do#LocListIncr()\<CR>" : ":let b:loclistpos = 0\<CR>\<C-I>"
"nnoremap <expr> <silent> <C-O> len(b:syntastic_loclist) > 0 ? ":call do#LocListDecr()\<CR>" : ":let b:loclistpos = 0\<CR>\<C-O>"
" Location/Jump list movement {{{3
" Use the jump list movement keys to navigate
" the syntactic error list, if it is active

" === YOU COMPLETE ME === {{{2

" i think this was some deprecated expermentation
" let g:ycm_core_dirs = { 'Darwin' : '/../core_darwin/', 'Linux' : '/../core_linux/' }

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
" === ECLIM === {{{2

" makes eclim play nice with YCM
let g:EclimCompletionMethod = 'omnifunc'

" === LATEX === {{{2
let g:tex_flavor='latex'
set grepprg=grep\ -nH\ $*
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='pdf, aux'
let g:Imap_UsePlaceHolders = 0
let g:Imap_FreezeImap = 1 " Turn off ANNOYING AUTO INPUT CRAP

" === VIM TABLE MODE === {{{2
" Markdown-compatible tables
let g:table_mode_corner = '|'
" === UTL === {{{2
"nnoremap <silent><C-]> call s:UtlOrTag()<CR>
"nnoremap <silent><C-]> call s:UtlOrTag()<CR>

" === ACK === {{{2
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
nmap <leader>a :Ack 

" === LUSTY JUGGLER === {{{2
nmap <leader>f :LustyJuggler<CR>

" === SURROUND === {{{2
"imap <leader>s <ESC>Isurround<CR>

" === CTRL-P === {{{2
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ -g ""'
" TODO: Check out neovim bg running, and global ag config file for ignores
" === ULTISNIPS === {{{2

" let g:UltiSnipsListSnippets = "<leader><TAB>"

" === CALENDAR === {{{2

let g:calendar_monday = 1
let g:calendar_wruler = "日 月 火 水 木 金 土"

" === ORGMODE === {{{2

let g:org_agenda_files = [ '~/.org/*.org' ]
