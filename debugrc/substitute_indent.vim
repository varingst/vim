set nocp
call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'maxmellom/vim-jsx-pretty'
call plug#end()

set backspace=2
" filetype plugin indent on

set lazyredraw

map ; <nop>
let g:mapleader = ';'

" jsx/xml, indentexpr=GetJsxIndent()
nnoremap <leader>e :s/\(<\w\+\\|\w\+=\({[^}]*}\\|"[^"]*"\)\)\s*/\1\r/ge<CR>:redraw<CR>='[

" lua, indentexpr=GetLuaIndent()
nnoremap <leader>s :s/\(function \w\+([^)]*)\\|if \S\+ then\\|return \S\+\\|\S\+\)\s*/\1\r/ge<CR>='[
