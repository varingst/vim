let s:file = printf('%s/.git/%s-changes.txt', split(&rtp, ',')[0], has('nvim') ? 'nvim' : 'vim')

" TODO: neovim has no changelog?

fun! changes#Bump()
  if has('nvim')
    return
  endif

  if !isdirectory(fnamemodify(s:file, ':h')) || v:version < 800
    return
  endif

  if !filereadable(s:file)
    call writefile([8000000, v:versionlong], s:file)
  else
    let l:last = readfile(s:file)[-1]
    if str2nr(l:last) < v:versionlong
      call writefile([v:versionlong], s:file, 'a')
    endif
  endif
endfun

fun! changes#View()
  if has('nvim')
    return
  endif

  call changes#Bump()

  if !filereadable(s:file)
    throw "could not read "..s:file
  endif
  let l:prev_version = readfile(s:file)[-2]
  let l:next_patch = str2nr(l:prev_version) + 1
  let l:human_version = call('printf', ['%d.%d.%04d']
        \ + map(matchlist(l:next_patch, '\(\d\)\(\d\d\)\(\d\{4\}\)')[1:3],
        \       {_, n -> str2nr(n) }))
  return printf('+/^Patch\ %s %s/doc/version%s.txt',
        \       l:human_version, $VIMRUNTIME, l:human_version[0])
endfun
