
" == Interface ============================================================ {{{1

fun! keys#init() " {{{2
  let s:keys = {}
  let s:width = {}
  let s:fkeys = {}
endfun

fun! keys#list(...) " {{{2
  let args = a:0 ? a:1 : { 'all': 1 }

  let filetype = get(args, 'filetype', &filetype)

  let keys = get(s:keys, filetype, [])

  if get(args, 'all', 0)
    let keys += s:keys[s:all_ft]
  endif

  let keys = filter(keys, get(args, 'filter', {idx, val -> 1}))

  if !len(keys)
    echo 'no keys to list ..'
    return
  endif

  let format = '%-'.(s:width['keys'] + 2).'s%-'.(s:width['mode'] + 2).'s%s'
  let available_width = &columns - strdisplaywidth(printf(format, '', '', '  '))

  for entry in keys
    echo printf(format, entry['keys'], entry['mode'],
          \ strdisplaywidth(entry['text']) > available_width
          \ ? entry['text'][:available_width - 2].'..'
          \ : entry['text'])
  endfor
endfun

fun! keys#flist(...) " {{{2
  let rows = [['']]
  let format = '%-7s'
  for pre in a:0 ? a:000 : ['', '<leader>']
    call add(rows[0], pre)
    let max_width = strdisplaywidth(pre)

    for i in range(1, 12)
      let key = '<F'.i.'>'
      if len(rows) < i + 1
        call add(rows, [])
        call add(rows[-1], key)
      endif
      let key = pre.key
      let mapping = get(s:fkeys, key, '')
      let max_width = max([max_width, strdisplaywidth(mapping)])
      call add(rows[i], mapping)
    endfor

    let format .= '%-'.(max_width + 2).'s'
  endfor

  for row in rows
    echo call('printf', [format] + row)
  endfor
endfun

" == Private ============================================================== {{{1

let s:all_ft = '*'

fun! s:AddKey(ft, ...) " {{{2
  let entry = {
        \ 'text': a:1,
        \ 'keys': a:2,
        \ 'mode': a:0 > 2 ? a:3 : 'n'
        \ }
  call add(s:KeyList(a:ft), entry)

  for k in ['keys', 'mode', 'text']
    let s:width[k] = max([get(s:width, k, 0), strdisplaywidth(entry[k])])
  endfor
endfun

fun! s:KeyList(...) " {{{2
  let ft = a:0 ? a:1 : s:all_ft

  if !has_key(s:keys, ft)
    let s:keys[ft] = []
  endif
  return s:keys[ft]
endfun

fun! s:MapFkeys(keys) " {{{2
  for [key, cmd] in items(a:keys)
    let s:fkeys[key] = cmd
    exe 'nnoremap ' . key . ' ' . cmd . '<CR>'
    exe 'inoremap ' . key . ' <ESC>' . cmd . '<CR>'
  endfor
endfun

fun! s:MapCode(code, key) " {{{2
  exe 'map <ESC>['.a:code.' '.a:key
  exe 'map! <ESC>['.a:code.' '.a:key
endfun

let s:prefixes = ['S', 'C', 'C-S']

fun! s:MapCodes(codemap) " {{{2
  for [key, code] in items(a:codemap)
    let type = type(code)
    if type is v:t_list
      for i in range(len(code))
        try
          if strlen(code[i])
            call s:MapCode(code[i],
                  \        printf('<%s-%s>',
                  \               s:prefixes[i],
                  \               substitute(key, '<\|>', '', 'g')))
          endif
        catch /E684/
          echoerr 'No prefix for index '.i
        endtry
      endfor
    elseif type is v:t_string
      call s:MapCode(code, key)
    endif
  endfor
endfun

" == Commands ============================================================= {{{1

command! -nargs=+ Key call s:AddKey(s:all_ft, <args>)
command! -nargs=+ FtKey call s:AddKey(<args>)
command! -nargs=1 FKeys call s:MapFkeys(<args>)
command! -nargs=1 KeyCodes call s:MapCodes(<args>)
