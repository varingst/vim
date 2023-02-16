let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

" TODO: handle errors in python, missing modules etc
if !get(g:, 'openscad_pyenv')
python3 << EOF
import dbus
import vim

def init_scad():
  try:
    bus = dbus.SessionBus()
    scadobj = bus.get_object("org.openscad.OpenSCAD",
                             "/org/openscad/OpenSCAD/Application")
    return dbus.Interface(scadobj, dbus_interface="org.openscad.OpenSCAD")
  except dbus.exceptions.DBusException as e:
    print(e)


scad = init_scad()
EOF
endif

let g:openscad_pyenv = 1

let s:factors = {
      \ 'zoom': 100,
      \ 'rotate': 5,
      \ 'translate': 5,
      \ 'translateview': 1,
      \}

let s:counts = copy(s:factors)->map('1')

fun! s:count(count, type)
  if a:count
    let s:counts[a:type] = a:count
  endif
  return s:counts[a:type] * get(s:factors, a:type, 1)
endfun

fun! s:scadf(...)
  try
    call py3eval('scad.'..call('printf', a:000))
  catch
    py3 scad = init_scad()
    try
      call py3eval('scad.'..call('printf', a:000))
    catch
      echoerr "Could not make a DBus connection to OpenSCAD"
    endtry
  endtry
endfun

fun! s:actioncomplete(...)
  return py3eval('scad.getActions()')->join("\n")
endfun

fun! s:setfactor(type, val)
  let s:factors[a:type] = v:val
endfun

fun! s:openscad_running()
  call system("pidof openscad")
  return v:shell_error == 0
endfun

command! -buffer -nargs=1 -complete=custom,s:actioncomplete ScadAction call <SID>scadf('action("%s")', <q-args>)
command! -buffer -count ScadRotateXMore call <SID>scadf('rotate(%d, 0, 0)', <SID>count(<count>, 'rotate'))
command! -buffer -count ScadRotateXLess call <SID>scadf('rotate(-%d, 0, 0)', <SID>count(<count>, 'rotate'))
command! -buffer -count ScadRotateYMore call <SID>scadf('rotate(0, %d, 0)', <SID>count(<count>, 'rotate'))
command! -buffer -count ScadRotateYLess call <SID>scadf('rotate(0, -%d, 0)', <SID>count(<count>, 'rotate'))
command! -buffer -count ScadRotateZMore call <SID>scadf('rotate(0, 0, %d)', <SID>count(<count>, 'rotate'))
command! -buffer -count ScadRotateZLess call <SID>scadf('rotate(0, 0, -%d)', <SID>count(<count>, 'rotate'))
command! -buffer -count ScadTranslateXMore call <SID>scadf('translate(%d, 0, 0)', <SID>count(<count>, 'translate'))
command! -buffer -count ScadTranslateXLess call <SID>scadf('translate(-%d, 0, 0)', <SID>count(<count>, 'translate'))
command! -buffer -count ScadTranslateYMore call <SID>scadf('translate(0, %d, 0)', <SID>count(<count>, 'translate'))
command! -buffer -count ScadTranslateYLess call <SID>scadf('translate(0, -%d, 0)', <SID>count(<count>, 'translate'))
command! -buffer -count ScadTranslateZMore call <SID>scadf('translate(0, 0, %d)', <SID>count(<count>, 'translate'))
command! -buffer -count ScadTranslateZLess call <SID>scadf('translate(0, 0, -%d)', <SID>count(<count>, 'translate'))
command! -buffer -count ScadZoomIn call <SID>scadf('zoom(%d)', <SID>count(<count>, 'zoom'))
command! -buffer -count ScadZoomOut call <SID>scadf('zoom(-%d)', <SID>count(<count>, 'zoom'))
" command! -buffer -count ScadTranslateViewXMore call <SID>scadf('translateView(%d, 0)', <SID>count(<count>, 'translateview'))
" command! -buffer -count ScadTranslateViewXLess call <SID>scadf('translateView(-%d, 0)', <SID>count(<count>, 'translateview'))
" command! -buffer -count ScadTranslateViewYMore call <SID>scadf('translateView(0, %d)', <SID>count(<count>, 'translateview'))
" command! -buffer -count ScadTranslateViewYLess call <SID>scadf('translateView(0, -%d)', <SID>count(<count>, 'translateview'))
command! -buffer -count=1 ScadFactorZoom call <SID>setfactor('zoom', <count>)
command! -buffer -count=1 ScadFactorRotate call <SID>setfactor('rotate', <count>)
command! -buffer -count=1 ScadFactorTranslate call <SID>setfactor('translate', <count>)
command! -buffer -count=1 ScadFactorTranslateView call <SID>setfactor('translateview', <count>)

if !has('popupwin')
  let &cpo = s:save_cpo
  finish
endif

command! -buffer ScadMenu call <SID>menu()

let s:menuview =<< EOS
View                      With Count                           Extra
[vv] reset view            x+  x-  y+  y-  z+  z-  axis        [ec]  console
[vd] diagonal view        [j] [k] [m] [n] [l] [h]  rotate      [ea]  axes
[vc] center view          [x] [X] [y] [Y] [z] [Z]  translate   [ep]  preview
[vr] view right                                                [er]  render
[vt] view top             [I] zoom in      Count factors       [ei]  export image
[vu] view bottom (under)  [O] zoom out     [fr]  rotate        [es]  export stl
[vl] view left                             [ft]  translate
[vf] view front           Without Count    [fz]  zoom
[vb] view back            [i] zoom in
[va] view all             [o] zoom out
EOS

fun! s:dict2trie(dict)
  let root = {}

  for [key, val] in items(a:dict)
    let node = root
    for k in split(key, '\zs')
      if !has_key(node, k)
        let node[k] = {}
      endif
      let node = node[k]
    endfor
    let node['val'] = val
  endfor

  return root
endfun

let s:maptrie = s:dict2trie({
      \ 'vv': 'ScadAction viewActionResetView',
      \ 'vd': 'ScadAction viewActionDiagonal',
      \ 'vr': 'ScadAction viewActionRight',
      \ 'vt': 'ScadAction viewActionTop',
      \ 'vu': 'ScadAction viewActionBottom',
      \ 'vl': 'ScadAction viewActionLeft',
      \ 'vf': 'ScadAction viewActionFront',
      \ 'vb': 'ScadAction viewActionBack',
      \ 'vc': 'ScadAction viewActionCenter',
      \ 'va': 'ScadAction viewActionViewAll',
      \ 'ec': 'ScadAction viewActionHideConsole',
      \ 'ea': 'ScadAction viewActionShowAxes',
      \ 'ep': 'ScadAction designActionPreview',
      \ 'er': 'ScadAction designActionRender',
      \ 'ei': 'ScadAction fileActionExportImage',
      \ 'es': 'ScadAction fileActionExportSTL',
      \ 'i': 'ScadAction viewActionZoomIn',
      \ 'o': 'ScadAction viewActionZoomOut',
      \ 'I': 'ScadZoomIn',
      \ 'O': 'ScadZoomOut',
      \ 'j': 'ScadRotateXMore',
      \ 'k': 'ScadRotateXLess',
      \ 'm': 'ScadRotateYMore',
      \ 'n': 'ScadRotateYLess',
      \ 'l': 'ScadRotateZMore',
      \ 'h': 'ScadRotateZLess',
      \ 'z': 'ScadTranslateZMore',
      \ 'Z': 'ScadTranslateZLess',
      \ 'x': 'ScadTranslateXMore',
      \ 'X': 'ScadTranslateXLess',
      \ 'y': 'ScadTranslateYMore',
      \ 'Y': 'ScadTranslateYLess',
      \ 'a': 'ScadTranslateViewXMore',
      \ 'd': 'ScadTranslateViewXLess',
      \ 'w': 'ScadTranslateViewYMore',
      \ 's': 'ScadTranslateViewYLess',
      \ 'fr': 'ScadFactorRotate',
      \ 'ft': 'ScadFactorTranslate',
      \ 'fz': 'ScadFactorZoom',
      \})

fun! s:popup(view, maptrie, ...)
  let _updatetime = &updatetime
  let &updatetime = &timeoutlen
  let prevcmd = ''
  let input = []
  let count = []
  let node = a:maptrie

  fun! s:reset() closure
    let input = []
    let count = []
    let node = a:maptrie
  endfun

  fun! s:exe(cmd) closure
    let prevcmd = a:cmd =~ '^ScadAction'
          \ ? a:cmd
          \ : count->join('')..a:cmd
    exe prevcmd
  endfun

  fun! s:filter(winid, key) closure
    if a:key == "\<ESC>"
      if !empty(input)
        let input = []
        let node = a:maptrie
      elseif !empty(count)
        let count = []
      else
        let &updatetime = _updatetime
        call popup_close(a:winid)
      endif
    elseif a:key =~ '\d' && !(empty(count) && a:key == '0')
      call add(count, a:key)
    elseif a:key == "\<CursorHold>"
      if has_key(node, 'val')
        call s:exe(node.val)
      endif
      call s:reset()
    elseif has_key(node, a:key)
      call add(input, a:key)
      let node = node[a:key]
      if has_key(node, 'val') && len(node) == 1
        call s:exe(node.val)
        call s:reset()
      endif
    else
      call s:reset()
    endif

    call popup_settext(a:winid,
          \ a:view +
          \ ['', prevcmd, (['> ']+count+input)->join('')])

    return 1
  endfun

  let winid = popup_create(a:view + ['', '', '> '],
        \ extend(copy(a:0 ? a:1 : {}), {
        \ 'mapping': v:false,
        \ 'padding': [0, 1, 0, 1],
        \ 'filter': funcref('s:filter'),
        \}))

  call win_execute(winid, 'match Special /\[\zs.\{-}\ze\]/')
endfun

fun! s:menu()
  call s:popup(s:menuview, s:maptrie, {})
endfun

if get(g:, 'openscad_TESTING') || index(v:argv, '--clean') != -1
  fun! S(f, ...)
    return call('s:'..a:f, a:000)
  endfun
endif

let &cpo = s:save_cpo
