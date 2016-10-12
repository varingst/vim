if !exists(':Tabularize')
  finish " Tabular has not been bloaded
endif

let s:save_cpo = &cpo
set cpo&vim

let s:tab_patterns = {}
function! HasTabPattern(pat)
  return has_key(s:tab_patterns, a:pat)
endfun
function! s:Add(name)
  let s:tab_patterns[a:name] = 1
endfun

AddTabularPattern! haskell /=\||/
AddTabularPattern! bachusneur /^[^|:]*\zs\(::=\||\)/l1r1l0
call s:Add('haskell')
call s:Add('backusnaur')

let &cpo = s:save_cpo
unlet s:save_cpo
