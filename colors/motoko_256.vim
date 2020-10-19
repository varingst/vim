highlight clear
if exists('syntax_on')
  syntax reset
endif
let colors_name = 'motoko_256'



highlight Normal guifg=#808080 guibg=NONE gui=NONE ctermfg=244 ctermbg=NONE cterm=NONE term=NONE
highlight Comment guifg=#4e4e4e guibg=NONE gui=NONE ctermfg=239 ctermbg=NONE cterm=NONE term=NONE
highlight Constant guifg=#00afaf guibg=NONE gui=NONE ctermfg=37 ctermbg=NONE cterm=NONE term=NONE
highlight Identifier guifg=#0087ff guibg=NONE gui=NONE ctermfg=33 ctermbg=NONE cterm=NONE term=NONE
highlight Statement guifg=#5f8700 guibg=NONE gui=NONE ctermfg=64 ctermbg=NONE cterm=NONE term=NONE
highlight PreProc guifg=#d75f00 guibg=NONE gui=NONE ctermfg=166 ctermbg=NONE cterm=NONE term=NONE
highlight Type guifg=#af8700 guibg=NONE gui=NONE ctermfg=136 ctermbg=NONE cterm=NONE term=NONE
highlight Special guifg=#af0000 guibg=NONE gui=NONE ctermfg=124 ctermbg=NONE cterm=NONE term=NONE
highlight Underlined guifg=#5f5faf guibg=NONE gui=underline ctermfg=61 ctermbg=NONE cterm=underline term=underline
highlight Ignore guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE term=NONE
highlight Error guifg=#af0000 guibg=NONE gui=NONE ctermfg=124 ctermbg=NONE cterm=NONE term=NONE
highlight Todo guifg=#af005f guibg=#262626 gui=bold ctermfg=125 ctermbg=235 cterm=bold term=bold

highlight Visual guifg=NONE guibg=#262626 gui=NONE ctermfg=NONE ctermbg=235 cterm=NONE term=NONE
highlight VisualNOS guifg=#00afaf guibg=#262626 gui=NONE ctermfg=37 ctermbg=235 cterm=NONE term=NONE

highlight Directory guifg=#0087ff guibg=NONE gui=NONE ctermfg=33 ctermbg=NONE cterm=NONE term=NONE
highlight ErrorMsg guifg=#af0000 guibg=NONE gui=NONE ctermfg=124 ctermbg=NONE cterm=NONE term=NONE
highlight MoreMsg guifg=#0087ff guibg=NONE gui=NONE ctermfg=33 ctermbg=NONE cterm=NONE term=NONE
highlight ModeMsg guifg=#0087ff guibg=NONE gui=NONE ctermfg=33 ctermbg=NONE cterm=NONE term=NONE

highlight Search guifg=NONE guibg=#262626 gui=reverse ctermfg=NONE ctermbg=235 cterm=reverse term=reverse
highlight IncSearch guifg=#ffffff guibg=#262626 gui=reverse ctermfg=255 ctermbg=235 cterm=reverse term=reverse
highlight MatchParen guifg=#af0000 guibg=#4e4e4e gui=bold ctermfg=124 ctermbg=239 cterm=bold term=bold

highlight LineNr guifg=#4e4e4e guibg=NONE gui=NONE ctermfg=239 ctermbg=NONE cterm=NONE term=NONE
highlight CursorLineNr guifg=#d75f00 guibg=NONE gui=NONE ctermfg=166 ctermbg=NONE cterm=NONE term=NONE

highlight QuickFixLine guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE term=NONE

highlight Title guifg=#d75f00 guibg=NONE gui=bold ctermfg=166 ctermbg=NONE cterm=bold term=bold
highlight Question guifg=#d75f00 guibg=NONE gui=bold ctermfg=166 ctermbg=NONE cterm=bold term=bold
highlight WarningMsg guifg=#af0000 guibg=NONE gui=bold ctermfg=124 ctermbg=NONE cterm=bold term=bold
highlight WildMenu guifg=#d75f00 guibg=#262626 gui=NONE ctermfg=166 ctermbg=235 cterm=NONE term=NONE
highlight Folded guifg=#4e4e4e guibg=NONE gui=bold ctermfg=239 ctermbg=NONE cterm=bold term=bold
highlight FoldColumn guifg=#808080 guibg=NONE gui=NONE ctermfg=244 ctermbg=NONE cterm=NONE term=NONE

highlight EndOfBuffer guifg=#262626 guibg=NONE gui=NONE ctermfg=235 ctermbg=NONE cterm=NONE term=NONE
highlight SignColumn guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE term=NONE
highlight link Conceal Operator
highlight SpecialKey guifg=#4e4e4e guibg=NONE gui=NONE ctermfg=239 ctermbg=NONE cterm=NONE term=NONE
highlight NonText guifg=#af0000 guibg=#262626 gui=NONE ctermfg=124 ctermbg=235 cterm=NONE term=NONE
highlight VertSplit guifg=#262626 guibg=NONE gui=NONE ctermfg=235 ctermbg=NONE cterm=NONE term=NONE

highlight SpellBad guifg=#af0000 guibg=NONE gui=undercurl ctermfg=124 ctermbg=NONE cterm=undercurl term=undercurl
highlight SpellCap guifg=#af005f guibg=NONE gui=undercurl ctermfg=125 ctermbg=NONE cterm=undercurl term=undercurl
highlight SpellRare guifg=#d75f00 guibg=NONE gui=undercurl ctermfg=166 ctermbg=NONE cterm=undercurl term=undercurl
highlight SpellLocal guifg=#00afaf guibg=NONE gui=undercurl ctermfg=37 ctermbg=NONE cterm=undercurl term=undercurl

highlight Pmenu guifg=#808080 guibg=#262626 gui=NONE ctermfg=244 ctermbg=235 cterm=NONE term=NONE
highlight PmenuSel guifg=#ffffff guibg=#0087ff gui=NONE ctermfg=255 ctermbg=33 cterm=NONE term=NONE
highlight PmenuSbar guifg=NONE guibg=#262626 gui=NONE ctermfg=NONE ctermbg=235 cterm=NONE term=NONE
highlight PmenuThumb guifg=NONE guibg=#262626 gui=NONE ctermfg=NONE ctermbg=235 cterm=NONE term=NONE

highlight CursorColumn guifg=NONE guibg=#262626 gui=NONE ctermfg=NONE ctermbg=235 cterm=NONE term=NONE
highlight CursorLine guifg=NONE guibg=#262626 gui=NONE ctermfg=NONE ctermbg=235 cterm=NONE term=NONE
highlight ColorColumn guifg=NONE guibg=#262626 gui=NONE ctermfg=NONE ctermbg=235 cterm=NONE term=NONE

highlight Cursor guifg=NONE guibg=#262626 gui=NONE ctermfg=NONE ctermbg=235 cterm=NONE term=NONE

highlight DiffAdd guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE term=NONE
highlight DiffChange guifg=NONE guibg=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold term=bold
highlight DiffDelete guifg=NONE guibg=NONE gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE term=NONE
highlight DiffText guifg=NONE guibg=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline term=underline

" Statusline

highlight StatusLine guifg=#0087ff guibg=NONE gui=NONE ctermfg=33 ctermbg=NONE cterm=NONE term=NONE
highlight StatusLineNC guifg=#005faf guibg=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE term=NONE
highlight StatusLineTerm guifg=#0087ff guibg=NONE gui=NONE ctermfg=33 ctermbg=NONE cterm=NONE term=NONE
highlight StatusLineTermNC guifg=#005faf guibg=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE term=NONE
highlight TabLineFill guifg=#005faf guibg=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE term=NONE

highlight STLServerName guifg=#005faf guibg=#262626 gui=bold ctermfg=25 ctermbg=235 cterm=bold term=bold
highlight STLTabIndex guifg=#ffffff guibg=#005faf gui=NONE ctermfg=255 ctermbg=25 cterm=NONE term=NONE
highlight STLTabLineGit guifg=#ffffff guibg=#262626 gui=NONE ctermfg=255 ctermbg=235 cterm=NONE term=NONE
highlight STLTabLineGitDirty guifg=#d75f00 guibg=#262626 gui=NONE ctermfg=166 ctermbg=235 cterm=NONE term=NONE

highlight STLNormalMode guifg=#ffffff guibg=#005faf gui=NONE ctermfg=255 ctermbg=25 cterm=NONE term=NONE
highlight STLInsertMode guifg=#ffffff guibg=#d75f00 gui=NONE ctermfg=255 ctermbg=166 cterm=NONE term=NONE
highlight STLReplaceMode guifg=#ffffff guibg=#af8700 gui=NONE ctermfg=255 ctermbg=136 cterm=NONE term=NONE
highlight STLVisualMode guifg=#ffffff guibg=#00afaf gui=NONE ctermfg=255 ctermbg=37 cterm=NONE term=NONE
highlight STLSelectMode guifg=#ffffff guibg=#5f8700 gui=NONE ctermfg=255 ctermbg=64 cterm=NONE term=NONE
highlight STLCommandMode guifg=#ffffff guibg=#af005f gui=NONE ctermfg=255 ctermbg=125 cterm=NONE term=NONE
highlight STLTerminalMode guifg=#ffffff guibg=#af0000 gui=NONE ctermfg=255 ctermbg=124 cterm=NONE term=NONE

highlight STLBuffer guifg=#005faf guibg=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE term=NONE
highlight STLBufferReadonly guifg=#af0000 guibg=NONE gui=NONE ctermfg=124 ctermbg=NONE cterm=NONE term=NONE
highlight STLBufferModified guifg=#d75f00 guibg=NONE gui=NONE ctermfg=166 ctermbg=NONE cterm=NONE term=NONE
highlight link STLBufferNormal STLBuffer
highlight STLBufferLink guifg=#00afaf guibg=NONE gui=NONE ctermfg=37 ctermbg=NONE cterm=NONE term=NONE

highlight STLWinnr guifg=#005faf guibg=#262626 gui=NONE ctermfg=25 ctermbg=235 cterm=NONE term=NONE
highlight STLFiletype guifg=#005faf guibg=NONE gui=NONE ctermfg=25 ctermbg=NONE cterm=NONE term=NONE


highlight STLAleError guifg=#d70000 guibg=#262626 gui=NONE ctermfg=160 ctermbg=235 cterm=NONE term=NONE
highlight STLAleWarning guifg=#d75f00 guibg=#262626 gui=NONE ctermfg=166 ctermbg=235 cterm=NONE term=NONE
highlight STLAleInfo guifg=#5f8700 guibg=#262626 gui=NONE ctermfg=64 ctermbg=235 cterm=NONE term=NONE
highlight STLAleStyle guifg=#5f5faf guibg=#262626 gui=NONE ctermfg=61 ctermbg=235 cterm=NONE term=NONE

highlight STLQuickfix guifg=#d75f00 guibg=#262626 gui=NONE ctermfg=166 ctermbg=235 cterm=NONE term=NONE
highlight STLLocList guifg=#5f5faf guibg=#262626 gui=NONE ctermfg=61 ctermbg=235 cterm=NONE term=NONE
highlight link STLQFTitle STLBuffer
highlight link STLTermTitle STLBuffer

highlight STLStatus guifg=#ffffff guibg=#d75f00 gui=NONE ctermfg=255 ctermbg=166 cterm=NONE term=NONE
highlight STLCtrlG guifg=#d75f00 guibg=NONE gui=NONE ctermfg=166 ctermbg=NONE cterm=NONE term=NONE

