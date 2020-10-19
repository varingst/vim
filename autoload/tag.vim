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
  let fn = fnamemodify(resolve(expand('%')), ':~:.')
  " TODO: fix taglist(regexp)
  return filter(taglist('.*'), { _, tag -> tag.filename == fn && F(tag) })
endfun

fun! tag#ListKinds()
  let out = systemlist(printf('cd %s && ctags --list-kinds-full=%s',
        \                     get(b:, 'gutentags_root', '.'), &filetype))

  return v:shell_error ? [] : out
endfun

fun! tag#FindKind()
  let kind = nr2char(getchar())
  if kind == '?'
    call tag#ShowKinds()
  else
    call popup#Tags({ tag -> kind == tag.kind })
  endif
endfun

fun! tag#Find()
  let kinds = get(b:, 'tag_kind_filter', '*')
  let parts = split(input(kinds..' tag > '), '/')

  if len(parts) == 2
    let b:tag_kind_filter = parts[0]
    let pattern = '\V'..parts[1]
  elseif empty(parts)
    let pattern = ''
  else
    let pattern = parts[0]
  endif

  if kinds == '*' && empty(pattern)
    call popup#Tags()
  elseif kinds == '*'
    call popup#Tags({ tag -> tag.name =~ pattern })
  elseif empty(pattern)
    call popup#Tags({ tag -> tag.kind =~ b:tag_kind_filter })
  else
    call popup#Tags({ tag -> tag.kind =~ b:tag_kind_filter
          \               && tag.name =~ pattern })
  endif
endfun

fun! tag#ShowKinds()
  call popup_create(tag#ListKinds(), {
        \ 'border': [1,1,1,1],
        \ 'borderhighlight': ['STLBufferNormal'],
        \ 'borderchars': g:sym.box,
        \ 'highlight': 'Normal',
        \ 'pos': 'center',
        \ 'moved': 'any',
        \ 'padding': [0,1,0,1],
        \})
endfun

fun! tag#GutentagsStatusline(mods) abort
  if index(a:mods, 'ctags') >= 0
    return g:sym.tag
  endif
endfun

fun! tag#push(foo, bar)
endfun

fun! tag#push(name, Jumper)
  let pos = getcurpos()
  let pos[0] = bufnr()
  if a:Jumper(a:name)
    call settagstack(winnr(), {
          \ 'items': [{
          \   'bufnr': pos[0],
          \   'from': pos,
          \   'tagname': a:name,
          \ }]
          \}, 't')
  endif
endfun

let &cpo = s:save_cpo
