let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

inoremap <buffer>> ><ESC>:call search('<', 'bW')<CR>wyiw:call search('>', 'W')<CR>a<C-R>="</"..@"..">"<CR><ESC>:call search('<', 'bW')<CR>i

nnoremap <silent><localleader>x :keeppatterns s/\(<\w\+\\|\w\+=\({[^}]*}\\|"[^"]*"\\|'[^']*'\)\)\s*/\1\r/ge<CR>:redraw<CR>='[
nnoremap <silent><localleader>X v/\/\?><CR>J:keeppatterns s/\s\(\/\?>\)/\1/<CR>

let &cpo = s:save_cpo
