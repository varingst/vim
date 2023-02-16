let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

inoremap <expr><buffer>> GetClosingTag()
inoremap <expr><buffer>><CR> GetClosingTag(1)
inoremap <buffer>>> >

nnoremap <silent><localleader>x :keeppatterns s/\(<\w\+\\|\w\+=\({[^}]*}\\|"[^"]*"\\|'[^']*'\)\)\s*/\1\r/ge<CR>:redraw<CR>='[
nnoremap <silent><localleader>X v/\/\?><CR>J:keeppatterns s/\s\(\/\?>\)/\1/<CR>

if !exists('*GetClosingTag')
  fun! GetClosingTag(...)
    let pos = getcurpos()

    let singlepos = searchpos('/>', 'bWn', pos[1])[1]
    if singlepos && singlepos + 2 == pos[2]
      return a:0 && a:1 ? "\<CR>" : ''
    endif

    call search('<\zs.', 'bW')
    let tag = expand('<cword>')
    call setpos('.', pos)

    return a:0 && a:1
          \ ? ">\<CR></"..tag..">\<C-O>O\<C-G>u"
          \ : "></"..tag..">"..repeat("\<C-G>U\<Left>", 3 + strlen(tag)).."\<C-G>u"
  endfun
endif

let &cpo = s:save_cpo
