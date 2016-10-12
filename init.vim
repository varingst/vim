
" ========== PLUG ========== " {{{1

set nocompatible
filetype off

call plug#begin()

Plug 'scrooloose/nerdcommenter'
Plug 'godlygeek/tabular' | Plug 'dhruvasagar/vim-table-mode'
" markdown, DEP: godlygeek/tabular
Plug 'plasticboy/vim-markdown'

if has("nvim")
  Plug 'benekastah/neomake'
else
  Plug 'scrooloose/syntastic'
endif

Plug 'Valloric/YouCompleteMe'

" plantuml
Plug 'aklt/plantuml-syntax'

" scrum, DEP: plasticboy/vim-markdown
Plug 'mmai/vim-markdown-wiki' | Plug 'mmai/vim-scrum-markdown'

" Git wrapper
Plug 'tpope/vim-fugitive'
" XML tags, brackets, quotes, etc
Plug 'tpope/vim-surround'
" adding endfunction/endif/end in vimscript, ruby, bourne shell, etc, etc
Plug 'tpope/vim-endwise'
" Run builds and test suites
Plug 'tpope/vim-dispatch'
" make '.' handle plugins nicers
Plug 'tpope/vim-repeat'
" Smarter substitution ++
Plug 'tpope/vim-abolish'
" Ruby snaxx
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-projectionist' | Plug 'tpope/vim-rake'
Plug 'tpope/vim-rails'
Plug 'danchoi/ri.vim'

" f/t enhancer/easymotion replacement
Plug 'justinmk/vim-sneak'

Plug 'nathanaelkane/vim-indent-guides'
Plug 'michaeljsmith/vim-indent-object'

" orgmode
Plug 'tpope/vim-speeddating' | Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-repeat'
Plug 'takac/vim-hardtime'
Plug 'vim-scripts/SyntaxRange'

" vim bdd
Plug 'tomtom/spec_vim'

" Language support
Plug 'gerw/vim-latex-suite'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'leafgarland/typescript-vim'
Plug 'bitc/vim-hdevtools'
Plug 'tpope/vim-fireplace'

" Sass's SCSS syntax
Plug 'hail2u/vim-css3-syntax'

" Homerolled prototypes
"Plug '~/dev/cheatsheet'
Plug 'varingst/vim-cheatsheet'

call plug#end()

" ========== OPTIONS ========= " {{{1
filetype plugin indent on
syntax enable
set background=dark
let g:solarized_termcolors=256
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

set textwidth=130
set colorcolumn=73,81,+1,+2
"hi OverLength cterm=underline
"exe "au BufWinEnter * match OverLength '\%".&textwidth."v.*'"

" ========== FOLDING ========= " {{{1
" {{{2
" If line contains nothing but a fold marker, use
" the next line of non-commented text as fold text
" TODO: Not working properly
" Fails with NON-ALNUM CHARS
fun! FoldText() " {{{
  let ft = split(foldtext(), ':')
  " this line in better, but does not work ?!
  "let ft[1] = substitite(ft[1], ' \s*','','')
  let ft[1] = ft[1][1:]
  let ft[0] = " ".substitute(ft[0], '^\D*','','')." "
  let txt = ""
  if match(ft[1], '\S') == -1
    let txt .= GetFirstNonComment(v:foldstart)
  else
    let txt .= join(ft[1:],':')
  endif
  let line = repeat('  ', v:foldlevel - 1).txt." "
  let offset = &columns - ( 4 + len(line) + len(ft[0]))
  if offset > 0
    return line.repeat('-', offset).ft[0]
  else
    return line.ft[0]
  endif
endfun " }}}

" Helper function for FoldText()
fun! GetFirstNonComment(start) " {{{
  let line = ""
  let i = a:start
  let col = 1
  while match(synIDattr(synID(i, col, 1), "name"), 'Comment$') != -1
    let i = nextnonblank(i+1)
  endwhile
  if !i | return "NO NONBLANK LINE: EMPTY FOLD?" | endif
  let max = strlen(getline(i))
  while col <= max && match(synIDattr(synID(i, col, 1), "name"), 'Comment$') == -1
    let col += 1
  endwhile
  return substitute(getline(i)[0:col-2], '^\s*\(\S*\)', '\1', '')
endfun
" }}}
set foldtext=FoldText()

" ========== AUTOCOMMANDS ========== {{{1

" auto save and load folds, options, and cursor
au BufWinLeave *.* mkview
au BufWinEnter *.* silent! loadview | normal! zMzv

" when editing a file, always jump to the last cursor position
autocmd BufReadPost *
         \ if ! exists("g:leave_my_cursor_position_alone") |
         \ if line("'\"") > 0 && line ("'\"") <= line("$") |
         \ exe "normal! g'\"" |
         \ endif |
         \ endif

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
highlight SpecialKey cterm=none ctermfg=233 ctermbg=none
" colorcolumn
highlight ColorColumn ctermbg=232

highlight IndentGuidesOdd ctermbg=black
highlight IndentGuidesEven ctermbg=233

" ========== KEY MAPPING ========== {{{1
" remapping <Leader> to ;
map ; <nop>
let mapleader   = ";"
let g:mapleader = ";"

" use default local leader: \

nnoremap <leader>j A<br><ESC>

" Make arrow keys useful
map <up> <C-W>k
map <down> <C-W>j
map <left> <C-W>h
map <right> <C-W>l

"inoremap <C-C> <ESC>
inoremap ,. ->
inoremap ., =>

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

nnoremap <silent><leader>g :!guardwrapper change %<CR><CR>

autocmd InsertEnter * set nohlsearch | :call InsertEnter()
autocmd InsertLeave * :call InsertLeave()

" Normal Space {{{2

nnoremap <localleader>- :split %<CR>
nnoremap <localleader>= :vsplit %<CR>


" Insert mode enter/leave hook functions {{{2
" TODO: Some of this is deprecated, like (f:key)

function! InsertEnter()
  "CH bar
  if exists("g:f_key")
    unlet g:f_key
  endif
  if exists("g:selectedParameter")
    unlet g:selectedParameter
  endif
endfun


function! InsertLeave()
  "CH 0
endfun

" Insert mode movement command shortcuts {{{2
"--Map <leader>f ForwardToChar()  i 'Move forward to char'
"--Map <leader>F BackwardToChar() i 'Move backward to char'

"--Map <leader>a <ESC>A i 'Continue insert at end of line'
"--Map <leader>s <ESC>o i 'Continue insert on next line'

"" <C-U>/<C-D> pageup/pagedown in completion menu
"inoremap <expr> <C-U> pumvisible() ? "\<PageUp>" : "\<C-U>"
"inoremap <expr> <C-D> pumvisible() ? "\<PageDown>" : "\<C-D>"
"inoremap <expr> <C-J> pumvisible() ? '<Down>' : '
"inoremap <expr> <C-J

" E group prototype {{{2
" TODO: Pull all of this out and make it a proper plugin.
" Issue: But that's a lot of work!
" Solution: Find time
vnoremap <expr><silent><C-j> exists("g:selectedParameter") ? ":call NextParam()\<CR>" : "\<C-j>"
vnoremap <expr><silent><C-k> exists("g:selectedParameter") ? ":call PrevParam()\<CR>" : "\<C-k>"
vnoremap <expr><silent><C-l> exists("g:selectedParameter") ? ":call SelectParameter(0)\<CR>" : "\<C-l>"

" MapGroup r : Replicate line, "near copy" and convenient quick edits {{{2
"--MapGroup <leader>r iv Replicate
inoremap <leader>r <ESC>:call RepeatToChar()<CR>
"--Map <leader>rk SpawnVariations() i Duplicate current line with search/replace variations
"--Map <leader>rl FixLastCase()     i Replace last [A-Z][A-Z] with [A-Z][a-z]
" TODO: Fix this, cleanup <C-U> and <C-N> in pum menu, not needed with ycm
inoremap <C-N> <ESC>:call RepeatToChar('.')<CR>




" Issue: This might not have to be in a group, even though it belongs in the
" Replicate group by association.
" Solution: Make more visual mode replicate functions ;)
"--Map <leader>rl SpawnMultilineVariations() v 'Insert search/replace variations'
vnoremap <leader>rl :<C-U>call SpawnMultilineVariations()<CR>

" "Pure" insert mode mappings {{{2
"--Map <C-R> RepeatToChar(1) i 'Duplicate current line up to char'
"Map <C-B> <Insert>        i 'Toggle Insert/Replace mode'
"imap <C-R> <ESC>:call RepeatToChar(1)<CR>
" {{{2
" Move to next/prev line of same indent level as current one
" PARAMS: dir <bool> : next line of true, prev line if false
fun! NextSimilarIndent(dir) " {{{
  let p = getpos(".")
  let ind = indent(p[1])
  let i = (a:dir ? p[1] + 1 : p[1] - 1)
  while ((indent(i) + 1) ? (indent(i) != ind) : 0)
    let i = (a:dir ? i + 1 : i - 1)
  endwhile
  if indent(i) == ind | call setpos('.', [ p[0], i, p[2], p[3] ]) | endif
endfun

" Various Normal mode convencience {{{2
" fold with space
"nnoremap <silent> <Space> @=(foldlevel('.')?'za':'l')<CR>
"nnoremap <silent> <Space> @=(foldlevel('.')
                            "\ ? (foldclosed('.') == -1 ? 'zc' : 'zx')
                            "\ : 'l')<CR>


" Utl lookup
" FIXME: These conflict and does not work as intended
"nnoremap <silent><C-]> :call GetUtls()<CR>
nnoremap <expr> <silent> <C-]> (synIDattr(synID(line("."), col("."), 1), "name") == "UtlUrl") ? "\<ESC>:Utl\<CR>" : "\<C-]>"

" This is also a candidate for Blistering enhancement
"nnoremap <silent> <bar> :call AutoTab()<CR>
"vnoremap <silent> <bar> :call AutoTab(1)<CR>
" TODO: fina another mapping for this
" nnoremap <silent> <C-L> :call RepeatToChar()<CR>

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
" <C-S> suspend terminal (unused)
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
"{{{3
if !has("nvim")
  " passive filetypes uses clang or eclim instead
  let g:syntastic_mode_map = { 'mode': 'active', 
          \ 'passive_filetypes': ['c', 'm', 'objc', 'cpp', 'java', 'ruby' ] }
  " auto opens the window on errors, autocloses when none detected
  let g:syntastic_auto_loc_list=1
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
  "let g:syntastic_ruby_checkers = [ 'mri', 'rubocop' ]

  " use this over the standard 'sh' checker
  let g:syntastic_sh_checkers = [ 'bashate' ]

  " get syntastic
  let g:syntastic_ruby_rubocop_args = "-D"
  command! Rubocop SyntasticCheck rubocop

  nnoremap <expr> <silent> <C-I> len(b:syntastic_loclist) > 0 ? ":call LocListIncr()\<CR>" : ":let b:loclistpos = 0\<CR>\<C-I>"
  nnoremap <expr> <silent> <C-O> len(b:syntastic_loclist) > 0 ? ":call LocListDecr()\<CR>" : ":let b:loclistpos = 0\<CR>\<C-O>"
  " Location/Jump list movement {{{3
  " Use the jump list movement keys to navigate
  " the syntactic error list, if it is active
  fun! LocListIncr() " {{{
    if !exists("b:loclistpos") || b:loclistpos >= len(b:syntastic_loclist)
      let b:loclistpos = 0
    endif
    let b:loclistpos += 1
    exe ":lfirst ".b:loclistpos
  endfun

  fun! LocListDecr()
    if !exists("b:loclistpos") || b:loclistpos <= 1
      let b:loclistpos = len(b:syntastic_loclist) + 1
    endif
    let b:loclistpos -= 1
    exe ":lfirst ".b:loclistpos
  endfun " }}}
else
endif

" === YOU COMPLETE ME === {{{2

let g:ycm_core_dirs = { 'Darwin' : '/../core_darwin/', 'Linux' : '/../core_linux/' }
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

"let g:ycm_semantic_triggers = {
  "\   'c' : ['->', '.'],
  "\   'objc' : ['->', '.'],
  "\   'ocaml' : ['.', '#'],
  "\   'cpp,objcpp' : ['->', '.', '::'],
  "\   'perl' : ['->'],
  "\   'php' : ['->', '::'],
  "\   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
  "\   'lua' : ['.', ':'],
  "\   'erlang' : [':'],
  "\ }
fun! s:YouCompleteMeCompileOptions(pairs)
  let opt_string = ' --clang-completer'
  for [exe, opt] in items(a:pairs)
    if executable(exe)
      let opt_string .= ' '.opt
    endif
  endfor
  return opt_string
endfun

fun! s:YouCompleteMeCompile()
  let cwd = getcwd()
  let vim_runtime = split(&runtimepath, ',')[0]
  let ycm_dir = vim_runtime.'/plugged/YouCompleteMe'
  call system('cd '.ycm_dir)
  if v:shell_error
    throw "YCM dir not located"
    return
  endif
  let install_cmd = './install.py'.s:YouCompleteMeCompileOptions({
        \ 'msbuild': '--omnisharp-completer',
        \ 'go': '--gocode-completer',
        \ 'node': '--tern-completer',
        \ 'rustc': '--racer-completer' })
  exe '!'.install_cmd
  "echo install_cmd
  call system('cd '.cwd)
endfun

command! YouCompleteMeCompile call s:YouCompleteMeCompile()<CR>
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
function! s:UtlOrTag()
  let line = getline('.')
  let utl_start = match(line, '<url:#r')

  if (utl_start >= 0)
    " strings are 0-indexed, while the columns are 1-indexed
    let pos = getpos('.')
    let pos[2] = utl_start + 1
    call setpos('.', pos)
    exe ":Utl"
    return
  elseif (match(line, '|\S\+|') >= 0)
    let tag = substitute(line, '.*|\(\S\+\)|.*', '\1', '')
    if len(tag)
      exe ":ta ".tag
      return
    endif
  endif

  normal! <C-]>
endfun
"nnoremap <silent><C-]> call s:UtlOrTag()<CR>
"nnoremap <silent><C-]> call s:UtlOrTag()<CR>

" ========== FUNCTIONS ========== {{{1

" TODO: refactor these

function! CopyLineUntil(offset, ...) " {{{2
  try
    call FindCharPos(a:offset, a:000)
  catch /NoMatch/
    return
  endtry
  call setline(s:lnum, s:other_line[0:(s:colmatch)])
  startinsert! 
endfun

function! AlignWithChar(offset, ...) " {{{2
  try
    call FindCharPos(a:offset, a:000)
  catch /NoMatch/
    return
  endtry
  let curline = getline(s:lnum)
  call setline(s:lnum, Fill(curline, s:col, s:colmatch - s:col))
  "call setline(s:lnum, curline[0:(s:col - 1)].repeat(' ', s:colmatch - s:col).curline[s:col :])
  call setpos('.', [s:bufnum, s:lnum, s:colmatch + 1, s:off])
endfun

function! Fill(string, pos, width) " {{{2
  return a:string[0:(a:pos - 1)].repeat(' ', a:width).a:string[a:pos :]
endfun

function! FindCharPos(line_offset, varargs) " {{{2
  let params = {}
  let ignorecase = &ignorecase
  let char = len(a:varargs) ? a:varargs[0] : nr2char(getchar())
  let [s:bufnum, s:lnum, s:col, s:off, s:curswant] = getcurpos()
  let s:other_line = getline(s:lnum + a:line_offset)
  set noignorecase
  let s:colmatch = match(s:other_line, char, s:col)
  if ignorecase | set ignorecase | endif
  if s:colmatch < 0 | throw "NoMatch" | endif
endfun

" === MAPPINGS === {{{2

inoremap <silent><C-Y> <ESC>:call CopyLineUntil(-1)<CR>
inoremap <silent><C-E> <ESC>:call CopyLineUntil(1)<CR>
nnoremap <silent><C-Y> <ESC>:call AlignWithChar(-1)<CR>
nnoremap <silent><C-E> <ESC>:call AlignWithChar(1)<CR>
