fun! s:ItemsDone()
  let l:match_pattern = '\[\d\+/\d\+\]'
  let l:extract_pattern = '\[\(\d\+\)/\(\d\+\)\]'

  fun! s:Increment(string, offset, increment) closure
    let [l:now, l:max] = map(matchlist(a:string, l:extract_pattern)[1:2], 'str2nr(v:val)')
    let l:now += a:increment

    if l:now < 0
      let l:now = 0
    elseif l:now > l:max
      let l:now = l:max
    endif

    return [printf('[%d/%d]', l:now, l:max), -1]
  endfun

  return {
        \ 'regexp': l:match_pattern,
        \ 'increment': funcref('s:Increment')
        \}
endfun

let g:speeddating_handlers = get(g:, 'speeddating_handlers', []) + [
      \ s:ItemsDone(),
      \]

