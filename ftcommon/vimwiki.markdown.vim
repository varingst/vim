if !exists('*s:match')
  fun s:match(lnum)
    let l:line = getline(a:lnum)
    let l:matches = matchlist(l:line, '^\(\s*\)\(=\+\)\(.\{-}\)\(=\+\)$')
    return empty(l:matches)
          \ ? matchlist(l:line, '^\(\s*\)\(#\+\)\(.*\)$')
          \ : l:matches
  endfun

  fun s:adjust(start, end, prefix, surround)
    for l:lnum in range(a:start, a:end)
      let l:matches = s:match(l:lnum)
      if empty(l:matches)
        continue
      endif

      let l:matches = map(l:matches,
            \             empty(l:matches[4]) ? a:prefix : a:surround)
      call setline(l:lnum, join(l:matches[1:], ''))
    endfor
  endfun
endif

let s:inc_prefix = {idx,val -> idx==2 ? val.'#' : val}
let s:dec_prefix = {idx,val -> idx==2 && strlen(val) > 1 ? val[1:] : val}
let s:inc_surround = {idx,val -> idx==2 || idx==4 ? val.'=' : val}
let s:dec_surround = {idx,val -> (idx==2 || idx==4) && strlen(val) > 1 ? val[1:] : val}

command! -buffer -range HeadingIncrease call s:adjust(<line1>, <line2>, s:inc_prefix, s:inc_surround)
command! -buffer -range HeadingDecrease call s:adjust(<line1>, <line2>, s:dec_prefix, s:dec_surround)
command! -buffer Link call setline(line('.'), substitute(getline('.'), expand('<cfile>'), '[](&)', ''))
      \             | exe 'normal! F]'
      \             | startinsert

nnoremap <silent><buffer><localleader>< :HeadingDecrease<CR>:silent! call repeat#set("\<localleader><", 1)<CR>
nnoremap <silent><buffer><localleader>> :HeadingIncrease<CR>:silent! call repeat#set("\<localleader>>", 1)<CR>
xnoremap <silent><buffer><localleader>< :HeadingDecrease<CR>
xnoremap <silent><buffer><localleader>> :HeadingIncrease<CR>

command! -buffer -nargs=* -complete=file Scrot call scrot#(<q-args>)
command! -buffer -nargs=* -complete=file ScrotSelect call scrot#(<q-args>, '--select')

setlocal textwidth=0

