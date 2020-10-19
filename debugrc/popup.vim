set nocp
set updatetime=1000

augroup foo
  au!
  au CursorHold * :
  au VimEnter * call Test()
augroup END

let pingchar = 'ý`'

fun! Test()
  let lines = []

  fun! Filter(winid, key) closure
    if a:key == "\<ESC>"
      call popup_close(a:winid, -1)
    endif

    let pingkey = a:key->split('\zs')->map('char2nr(v:val)')

    call add(lines, printf('%s, %s matches: %d, matches: %d',
          \ a:key,
          \ string(pingkey),
          \ a:key == pingkey->map('nr2char(v:val)')->join(''),
          \ a:key == g:pingchar
          \))
    call popup_settext(a:winid, lines)
    return 1
  endfun

  call popup_create(lines, {
        \ 'filter': function('Filter'),
        \ 'mapping': v:false,
        \})
endfun
