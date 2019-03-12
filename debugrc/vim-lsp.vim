set nocp

let $PATH = $HOME."/.vim/bin:".$PATH
call plug#begin()
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

let g:servers = [
      \ {
      \   'name': 'solargraph',
      \   'cmd': { -> [&shell, &shellcmdflag, 'solargraph stdio'] },
      \   'whitelist': ['ruby'],
      \ },
      \ {
      \   'name': 'emmylua',
      \   'cmd': { -> [&shell, &shellcmdflag, 'emmylua'] },
      \   'whitelist': ['lua'],
      \ },
      \ {
      \   'name': 'clj-lsp',
      \   'cmd': { -> [&shell, &shellcmdflag, 'clojure-lsp'] },
      \   'whitelist': ['clojure'],
      \ }
      \]

let g:servers2 = [
      \ {
      \   'name': 'solargraph',
      \   'cmd': f#lsp_cmd('solargraph stdio'),
      \   'whitelist': ['ruby'],
      \ },
      \ {
      \   'name': 'emmylua',
      \   'cmd': f#lsp_cmd('emmylua'),
      \   'whitelist': ['lua'],
      \ },
      \ {
      \   'name': 'clj-lsp',
      \   'cmd': f#lsp_cmd('clojure-lsp'),
      \   'whitelist': ['clojure'],
      \ }
      \]

let g:alt_servers = {
      \ 'ruby': {
      \   'name': 'solargraph',
      \   'cmd': 'solargraph stdio',
      \ },
      \ 'lua': 'emmylua',
      \ 'clojure': {
      \   'name': 'clj',
      \   'cmd': 'clojure-lsp',
      \ },
      \}

augroup setup-lsp
  au!
  au User lsp_setup call f#lsp_setup(g:alt_servers)
  " au User lsp_setup for server in f#lsp_setup(g:alt_servers) | call lsp#register_server(server) | endfor
  " au User lsp_setup for server in g:alt_servers | call lsp#register_server(server) | endfor
  " au User lsp_setup call f#lsp_setup(g:alt_servers)

  " au User lsp_setup for server in g:servers2 | call lsp#register_server(server) | endfor

  " au User lsp_setup call lsp#register_server(g:servers[0])
  " au User lsp_setup call lsp#register_server(g:servers[1])
  " au User lsp_setup call lsp#register_server(g:servers[2])
augroup END
