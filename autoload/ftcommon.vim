let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! ftcommon#source(ft)
  for ft in split(a:ft, '\.')
    for src in get(s:ftcommon, ft, [])
      exe 'source '..src
    endfor
  endfor
endfun

let s:ftcommon = {}

for src in glob($MYVIMHOME..'/ftcommon/*.vim', v:false, v:true)
  for ft in split(fnamemodify(src, ':t'), '\.')[:-2]
    if has_key(s:ftcommon, ft)
      call add(s:ftcommon[ft], src)
    else
      let s:ftcommon[ft] = [src]
    endif
  endfor
endfor

let &cpo = s:save_cpo
