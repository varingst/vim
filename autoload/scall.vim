if has('patch-8.1.1116')
  scriptversion 3
endif

let s:snr_index = {}
let s:script_index = {}

fun! scall#(script, function, ...)
  return call(s:snr(a:script)..a:function, a:000)
endfun


fun! s:index_scriptnames()
  for line in split(execute('scriptnames'), '\n')
    let [snr, src] = matchlist(line, '^\s*\(\d\+\): \(.*\)')[1:2]
    let s:snr_index[src] = snr
  endfor
endfun

fun! s:match_scripts(script)
  return filter(s:snr_index,
        \       {src, _ -> match(src, escape(a:script, '\/')..'$') >= 0})
endfun

fun! s:last_match(matches)
  let order = 0
  let last = ""
  for [src, snr] in items(a:matches)
    if str2nr(snr) > order
      let order = str2nr(snr)
      let last = src
    endif
  endfor
  return last
endfun

fun! s:snr(script)
  if !has_key(s:script_index, a:script)
    let matches = s:match_scripts(a:script)
    if empty(matches)
      exe 'runtime '..a:script
      call s:index_scriptnames()
      let matches = s:match_scripts(a:script)
      if empty(matches)
        throw printf("Could not find '%s' in scripts", a:script)
      endif
    endif
    let last_match = s:last_match(matches)
    let s:script_index[a:script] = "<SNR>"..s:snr_index[last_match].."_"
  endif

  return s:script_index[a:script]
endfun

