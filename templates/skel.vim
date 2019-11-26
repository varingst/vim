let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

@CURSOR@

let &cpo = s:save_cpo
