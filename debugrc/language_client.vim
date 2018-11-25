set nocp
call plug#begin()
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next' }
if !has('nvim')
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2'
call plug#end()

set signcolumn=yes
set backspace=2
set completeopt=noinsert,menuone,noselect

let g:LanguageClient_serverCommands = {
      \ 'ruby': ['solargraph', 'stdio']
      \}
let g:LanguageClient_rootMarkers = {
      \ 'ruby': ['Gemfile']
      \}
let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_loggingFile = '/tmp/langclient.log'
let g:LanguageClient_serverStderr = '/tmp/langserver.log'

command! Log exe 'split '.g:LanguageClient_loggingFile
command! SLog exe 'split '.g:LanguageClient_serverStderr

au BufWinEnter * call ncm2#enable_for_buffer()

imap <C-Space> <Plug>(ncm2_manual_trigger)
