nnoremap <silent><buffer><CR> :VimwikiFollowLink<CR>
nnoremap <silent><buffer><expr><S-CR> ":Vimwiki".(winwidth('.') > 140 ? 'V' : '')."SplitLink reuse move_cursor\<CR>"
nnoremap <silent><buffer><expr><C-CR> ":Vimwiki".(winwidth('.') > 140 ? 'V' : '')."SplitLink\<CR>"
nnoremap <silent><buffer><Backspace> :VimwikiGoBackLink<CR>

nnoremap <silent><buffer><Tab> :VimwikiNextLink<CR>
nnoremap <silent><buffer><S-Tab> :VimwikiPrevLink<CR>

nmap <silent><buffer>[[ <Plug>VimwikiGoToPrevHeader
nmap <silent><buffer>]] <Plug>VimwikiGoToNextHeader
nmap <silent><buffer>[= <Plug>VimwikiGoToPrevSiblingHeader
nmap <silent><buffer>]= <Plug>VimwikiGoToNextSiblingHeader

nnoremap <silent><buffer><C-@> :VimwikiToggleListItem<CR>

imap <silent><buffer><C-T> <Plug>VimwikiIncreaseLvlSingleItem
imap <silent><buffer><C-D> <Plug>VimwikiDecreaseLvlSingleItem

inoremap <silent><buffer><CR> <C-]><Esc>:VimwikiReturn 3 5<CR>
inoremap <silent><buffer><S-CR> <C-]><Esc>:VimwikiReturn 2 2<CR>

inoremap <silent><buffer><C-R>! <C-R>="- [ ] "<CR>
