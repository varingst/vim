if has('patch-8.1.1116')
  scriptversion 3
endif

let s:readme = { 'type': 'readme' }

fun! projectionist_extra#expand(conf)
  for [l:root, l:config] in items(a:conf)
    for [l:filematch, _] in items(config)
      if l:filematch =~# '|'
        let l:c = remove(l:config, l:filematch)
        for l:fm in split(l:filematch, '|')
          let l:config[l:fm] = l:c
        endfor
      endif
    endfor
    if !has_key(l:config, 'README.md')
      let l:config['README.md'] = s:readme
    endif
  endfor

  return a:conf
endfun

fun! s:activate() abort
endfun

augroup projectionist-extra
  au!
  au User ProjectionistActivate call s:activate()
augroup END


