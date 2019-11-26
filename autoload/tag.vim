let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! tag#InitGutentags(file) abort
  if isdirectory(getcwd()..'/.git')
    let b:gutentags_ctags_tagfile = '.git/tags'
  endif
  return 1
endfun

fun! tag#TagsInFile(...) abort
  let F = a:0 ? a:1 : { -> v:true }
  return filter(taglist('.*'), { _, tag -> tag.filename == expand('%') && F(tag) })
endfun

fun! tag#GutentagsStatusline(mods) abort
  if index(a:mods, 'ctags') >= 0
    return g:sym.tag
  endif
endfun

let &cpo = s:save_cpo
