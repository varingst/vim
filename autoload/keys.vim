if has('patch-8.1.1116')
  scriptversion 3
endif

let s:keys = {}
let s:width = {}
let s:fkeys = {}

" == Interface ============================================================

fun! keys#list(...)
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

  let format = '%-'..(s:width['keys'] + 2)..'s%-'..(s:width['mode'] + 2)..'s%s'
  let available_width = &columns - strdisplaywidth(printf(format, '', '', '  '))

  call popup_atcursor(map(keys, {
          \ _, entry -> printf(format, entry['keys'], entry['mode'],
          \ strdisplaywidth(entry['text']) > available_width
          \ ? entry['text'][:available_width - 2]..'..'
          \ : entry['text'])}), {})
endfun

fun! keys#flist(...) abort
  let rows = [['']]
  let format = '%-7s'
  for fkey in a:0 ? a:000 : ['<F%d>', '<S-F%d>']
    call add(rows[0], printf(substitute(fkey, '%d', '%s', ''), 'n'))
    let max_width = strdisplaywidth(fkey) - 1

    for i in range(1, 12)
      let key = printf(fkey, i)
      if len(rows) < i + 1
        call add(rows, [])
        call add(rows[-1], key)
      endif
      let key = printf(fkey, i)
      let mapping = get(s:fkeys, key, '')
      let max_width = max([max_width, strdisplaywidth(mapping)])
      call add(rows[i], mapping)
    endfor

    let format ..= '%-'..(max_width + 2)..'s'
  endfor

  call popup_atcursor(map(rows, { _, row -> call('printf', [format] + row) }), {})
endfun

fun! keys#function(keys)
  for [key, cmd] in items(a:keys)
    let [_, _, mode, key; _] = matchlist(key, '\(\(\w\+\):\)\?\(<.*>\)')
    let mode = empty(mode) ? 'normal' : mode
    if !has_key(s:fkeys, mode)
      let s:fkeys[mode] = {}
    endif
    let s:fkeys[mode][key] = cmd
  endfor
  call s:SetFKeyMode()
endfun

fun! keys#statusline()
  if !exists('s:fkeymode')
    return ''
  endif
  return s:fkeymode == 'debug' ? g:sym.bug : ''
endfun

" == Private ==============================================================

let s:all_ft = '*'

fun! s:AddKey(ft, ...)
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

fun! s:KeyList(...)
  let ft = a:0 ? a:1 : s:all_ft

  if !has_key(s:keys, ft)
    let s:keys[ft] = []
  endif
  return s:keys[ft]
endfun

fun! s:SetFKeyMode(...)
  let s:fkeymode = !a:0 || empty(a:1) ? 'normal' : a:1
  for [key, cmd] in items(get(s:fkeys, s:fkeymode, {}))
    let s:fkeys[key] = cmd
    exe 'nnoremap ' .. key .. ' ' .. cmd .. '<CR>'
    exe 'inoremap ' .. key .. ' <C-O>' .. cmd .. '<CR>'
  endfor
endfun

" == KeyCodes ==================================================================

" adapted from https://github.com/CyberShadow/term-keys

"  [vim_keyname, urxvt_keyname]
let s:keytable = [
    \ ["Esc", "Escape"],
    \ ["F1", "F1"],
    \ ["F2", "F2"],
    \ ["F3", "F3"],
    \ ["F4", "F4"],
    \ ["F5", "F5"],
    \ ["F6", "F6"],
    \ ["F7", "F7"],
    \ ["F8", "F8"],
    \ ["F9", "F9"],
    \ ["F10", "F10"],
    \ ["F11", "F11"],
    \ ["F12", "F12"],
    \ ["`", "grave"],
    \ ["1", "1"],
    \ ["2", "2"],
    \ ["3", "3"],
    \ ["4", "4"],
    \ ["5", "5"],
    \ ["6", "6"],
    \ ["7", "7"],
    \ ["8", "8"],
    \ ["9", "9"],
    \ ["0", "0"],
    \ ["-", "minus"],
    \ ["=", "equal"],
    \ ["BS", "BackSpace"],
    \ ["Tab", "Tab"],
    \ ["q", "q"],
    \ ["w", "w"],
    \ ["e", "e"],
    \ ["r", "r"],
    \ ["t", "t"],
    \ ["y", "y"],
    \ ["u", "u"],
    \ ["i", "i"],
    \ ["o", "o"],
    \ ["p", "p"],
    \ ["[", "bracketleft"],
    \ ["]", "bracketright"],
    \ ["CR", "Return"],
    \ ["a", "a"],
    \ ["s", "s"],
    \ ["d", "d"],
    \ ["f", "f"],
    \ ["g", "g"],
    \ ["h", "h"],
    \ ["j", "j"],
    \ ["k", "k"],
    \ ["l", "l"],
    \ [";", "semicolon"],
    \ ["'", "apostrophe"],
    \ ["Bslash", "backslash"],
    \ ["z", "z"],
    \ ["x", "x"],
    \ ["c", "c"],
    \ ["v", "v"],
    \ ["b", "b"],
    \ ["n", "n"],
    \ ["m", "m"],
    \ [",", "comma"],
    \ [".", "period"],
    \ ["/", "slash"],
    \ ["Space", "space"],
    \ ["Up", "Up"],
    \ ["Down", "Down"],
    \ ["Left", "Left"],
    \ ["Right", "Right"],
    \ ["Insert", "Insert"],
    \ ["Delete", "Delete"],
    \ ["Home", "Home"],
    \ ["End", "End"],
    \ ["PageUp", "Page_Up"],
    \ ["PageDown", "Page_down"],
    \]

" modifier keys HHKB:
" CTRL_L, control, C
" Alt_L, mod1, A
" Super_L, mod4, D
" Super_R, mod4, D
" ISO_Level3_Shift, mod5, not used

" [vim_modname, urxvt_modname]
let s:modtable = [
      \ ['S', 'Shift'],
      \ ['C', 'Control'],
      \ ['A', 'Mod1'],
      \ ['D', 'Mod4'],
      \ ['CTRL', 'Control'],
      \]

fun! keys#VimUrxvt(keys, mods)
  let [prevvimkey, prevurxvtkey] = a:keys[0]

  fun! s:vimadd(modcode, keycode, modstr, keystr) closure
    let modstr = join(a:modstr, '-')
    let out = [
          \ printf("map  \<ESC>\<C-_>%s%s\<C-_> <%s-%s>", a:modcode, a:keycode, modstr, a:keystr),
          \ printf("map! \<ESC>\<C-_>%s%s\<C-_> <%s-%s>", a:modcode, a:keycode, modstr, a:keystr),
          \]

    if a:keystr != prevvimkey
      let prevvimkey = a:keystr
      return insert(out, '')
    else
      return out
    endif
  endfun

  fun! s:urxvtadd(modcode, keycode, modstr, keystr) closure
    let modstr = join(a:modstr, '-')
    let out = printf('URxvt.keysym.%s-%s: \033\037%s%s\037', modstr, a:keystr, a:modcode, a:keycode)

    if a:keystr != prevurxvtkey
      let prevurxvtkey = a:keystr
      return ['', out]
    else
      return out
    endif
  endfun

  let mkshift = [
    \ "Space",
    \ "Up",
    \ "Down",
    \ "Left",
    \ "Right",
    \ "Insert",
    \ "Delete",
    \ "Home",
    \ "End",
    \ "PageUp",
    \ "PageDown",
    \ "Esc",
    \ "BS",
    \ "CR",
    \ "F1",
    \ "F2",
    \]

  fun! s:skip(key, mods) closure
    let vimkey = a:key[1]
    let modflag = a:mods[0]

    if modflag == 1 "Shift
      return index(mkshift, vimkey) == -1
    elseif modflag == 2 && vimkey =~# '^\V\(\[a-z6\-\]]\|Bslash\)\$'
      " leave mappings for <C-6> (<C-^>), <C-]>, <C--> (<C-_>), <C-\>
      " and all <C-[alpha]> except <C-i>, <C-m>
      return 1
    elseif modflag == 8 || modflag == 15
      " skip super (used for WM) and all modifiers
      return 1
    elseif and(modflag, 16)
      " create keys <CTRL-[him]>
      return !(modflag == 16 && vimkey =~# '^\V\[him]')
    endif

    return 0
  endfun

  return map(s:generate_keydefs(a:keys,
        \                       a:mods,
        \                       [function('s:vimadd'), function('s:urxvtadd')],
        \                       function('s:skip')),
        \    { _, l -> Flatten(l) })
endfun

fun! s:generate_modifiers(mods)
  let out = []
  let nmods = len(a:mods)

  for i in range(1, float2nr(pow(2, nmods)) - 1)
    call add(out, [i])
    for idx in range(1, nmods)
      if and(i, float2nr(pow(2, idx-1)))
        call insert(out[-1], idx-1, 1)
      endif
    endfor
  endfor

  return out
endfun

fun! s:generate_keys(keys, mods, Skip)
  let out = []
  let modifiers = s:generate_modifiers(a:mods)

  for i in range(len(a:keys))
    " push key index to front, used to create a unique keycode
    let key = [i] + a:keys[i]
    for mods in modifiers
      if !a:Skip(key, mods)
        call add(out, [mods, key])
      endif
    endfor
  endfor

  return out
endfun

fun! s:generate_keydefs(keys, mods, formatters, ...)
  let nout = len(a:formatters)
  let out = map(range(nout), '[]')
  let offset = char2nr('a')

  let Skip = a:0 ? a:1 : { _mod, _key -> v:false }

  for key in s:generate_keys(a:keys, a:mods, Skip)
    let [mods, keys] = key
    let modcode = nr2char(mods[0] + offset)
    let keycode = join(map(s:dec2base(keys[0], 26), 'nr2char(v:val + offset)'), '')

    for i in range(nout)
      let modstr = map(mods[1:], { _, j -> a:mods[j][i] })
      call add(out[i], a:formatters[i](modcode, keycode, modstr, keys[i+1]))
    endfor
  endfor

  return out
endfun

fun! s:dec2base(n, base)
  let out = []

  let n = a:n
  while n
    call add(out, n % a:base)
    let n /= a:base
  endwhile

  return empty(out) ? [0] : reverse(out)
endfun

" == Commands =============================================================

command! KeyCodeGenerate
      \   let [vimkeys, xkeys] = keys#VimUrxvt(s:keytable, s:modtable)
      \ | tabnew
      \ | vnew
      \ | silent put! =vimkeys
      \ | set ft=vim
      \ | split $MYVIMHOME/keys.vim
      \ | wincmd h
      \ | silent put! =xkeys
      \ | set ft=xdefaults
      \ | split $HOME/.Xresources

command! -nargs=+ Key call s:AddKey(s:all_ft, <args>)
command! -nargs=+ FtKey call s:AddKey(<args>)
command! -nargs=1 FKeys call s:MapFkeys(<args>)
command! -nargs=? -bar FKeyMode call s:SetFKeyMode(<q-args>)
