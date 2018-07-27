if get(g:, 'motoko_termcolor', 256) == 16
  let s:term_red = 1
  let s:term_green = 2
  let s:term_yellow = 3
  let s:term_blue = 4
  let s:term_purple = 5
  let s:term_white = 7
  let s:term_black = 0
  let s:term_grey = 8
  let s:term_orange = s:term_yellow
  let s:term_cyan = 6
else
  let s:term_red = 160
  let s:term_green = 64
  let s:term_yellow = 136
  let s:term_blue = 25
  let s:term_purple = 170
  let s:term_white = 255
  let s:term_black = 0
  let s:term_grey = 235
  let s:term_orange = 166
  let s:term_cyan = 37
endif

let s:gui_red = ''
let s:gui_green = ''
let s:gui_yellow = ''
let s:gui_blue = ''
let s:gui_purple = ''
let s:gui_white = ''
let s:gui_black = ''
let s:gui_grey = ''
let s:gui_orange = ''
let s:gui_cyan = ''

fun! s:C(fg, bg)
  return [ s:['gui_'.a:fg], s:['gui_'.a:bg], s:['term_'.a:fg], s:['term_'.a:bg] ]
endfun



let g:airline#themes#motoko#palette = {}

let g:airline#themes#motoko#palette.accents = {
      \ 'red': [ '#E06C75', '', s:term_red, 0 ]
      \ }

let s:N1 = [ '#282C34', '#98C379', s:term_blue, s:term_grey ]
let s:N2 = [ '#ABB2BF', '#3E4452', s:term_white, s:term_grey ]
let s:N3 = [ '#98C379', '#282C34', s:term_blue, '' ]
let g:airline#themes#motoko#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let group = airline#themes#get_highlight('vimCommand')
let g:airline#themes#motoko#palette.normal_modified = {
      \ 'airline_c': [ group[0], '', group[2], '', '' ]
      \ }

let s:I1 = [ '#282C34', '#61AFEF', s:term_black, s:term_orange ]
let s:I2 = s:N2
let s:I3 = [ '#61AFEF', '#282C34', s:term_orange, '' ]
let g:airline#themes#motoko#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#motoko#palette.insert_modified = g:airline#themes#motoko#palette.normal_modified

let s:R1 = [ '#282C34', '#E06C75', s:term_black, s:term_red ]
let s:R2 = s:N2
let s:R3 = [ '#E06C75', '#282C34', s:term_red, '' ]
let g:airline#themes#motoko#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#motoko#palette.replace_modified = g:airline#themes#motoko#palette.normal_modified

let s:V1 = [ '#282C34', '#C678DD', s:term_black, s:term_purple ]
let s:V2 = s:N2
let s:V3 = [ '#C678DD', '#282C34', s:term_purple, '' ]
let g:airline#themes#motoko#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#motoko#palette.visual_modified = g:airline#themes#motoko#palette.normal_modified

let s:IA1 = [ '#282C34', '#ABB2BF', s:term_black, s:term_white ]
let s:IA2 = [ '#ABB2BF', '#3E4452', s:term_white, s:term_grey ]
let s:IA3 = s:N2
let g:airline#themes#motoko#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#motoko#palette.inactive_modified = {
      \ 'airline_c': [ group[0], '', group[2], '', '' ]
      \ }

let g:airline#themes#motoko#palette.tabline = {
      \ 'airline_tablabel': s:C('blue', 'grey'),
      \ 'airline_tab':      s:C('blue', 'grey'),
      \ 'airline_tabsel':   s:C('white', 'blue'),
      \}

" Warnings
let s:WI = [ '#282C34', '#E5C07B', s:term_black, s:term_orange ]
let g:airline#themes#motoko#palette.normal.airline_warning = [
      \ s:WI[0], s:WI[1], s:WI[2], s:WI[3]
      \ ]

let g:airline#themes#motoko#palette.normal_modified.airline_warning =
    \ g:airline#themes#motoko#palette.normal.airline_warning

let g:airline#themes#motoko#palette.insert.airline_warning =
    \ g:airline#themes#motoko#palette.normal.airline_warning

let g:airline#themes#motoko#palette.insert_modified.airline_warning =
    \ g:airline#themes#motoko#palette.normal.airline_warning

let g:airline#themes#motoko#palette.visual.airline_warning =
    \ g:airline#themes#motoko#palette.normal.airline_warning

let g:airline#themes#motoko#palette.visual_modified.airline_warning =
    \ g:airline#themes#motoko#palette.normal.airline_warning

let g:airline#themes#motoko#palette.replace.airline_warning =
    \ g:airline#themes#motoko#palette.normal.airline_warning

let g:airline#themes#motoko#palette.replace_modified.airline_warning =
    \ g:airline#themes#motoko#palette.normal.airline_warning

" Errors
let s:ER = [ '#282C34', '#E06C75', s:term_black, s:term_red ]
let g:airline#themes#motoko#palette.normal.airline_error = [
      \ s:ER[0], s:ER[1], s:ER[2], s:ER[3]
      \ ]

let g:airline#themes#motoko#palette.normal_modified.airline_error =
    \ g:airline#themes#motoko#palette.normal.airline_error

let g:airline#themes#motoko#palette.insert.airline_error =
    \ g:airline#themes#motoko#palette.normal.airline_error

let g:airline#themes#motoko#palette.insert_modified.airline_error =
    \ g:airline#themes#motoko#palette.normal.airline_error

let g:airline#themes#motoko#palette.visual.airline_error =
    \ g:airline#themes#motoko#palette.normal.airline_error

let g:airline#themes#motoko#palette.visual_modified.airline_error =
    \ g:airline#themes#motoko#palette.normal.airline_error

let g:airline#themes#motoko#palette.replace.airline_error =
    \ g:airline#themes#motoko#palette.normal.airline_error

let g:airline#themes#motoko#palette.replace_modified.airline_error =
    \ g:airline#themes#motoko#palette.normal.airline_error
