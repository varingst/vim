" Disable haskell-vim omnifunc

let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifuc=neocghc#omnifunc
