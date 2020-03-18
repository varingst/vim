let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

let s:outputs = join([
      \ 'stderr',
      \ 'Console',
      \ 'Vimspector-out',
      \ 'Vimspector-err',
      \ 'server',
      \ 'Telemetry'
      \], "\n")

fun! s:complete_outputs(...)
  return s:outputs
endfun

command! -nargs=1 -complete=custom,s:complete_outputs
      \ VimspectorOutput call vimspector#ShowOutput(<q-args>)

augroup Vimspector
  au!
  au BufNewFile,BufRead .vimspector.json command! -buffer -nargs=+ -complete=customlist,<SID>config_completion VimspectorAddConfig call s:add_config(<f-args>)
  " does not work, dunno why
  " au BufWinEnter vimspector.*,_vimspector_log* setlocal nonumber
  " au WinNew vimspector.* call add(g:vimspector, 'fooo')
  " au BufWinEnter vimspector.{StackTrace,Watches,Variables} setlocal relativenumber
  " au BufWinEnter vimspector.{Console,Output:stderr,Output:Telemetry,Output:server},_vimspector* setlocal nonumber
augroup END

fun! AddConfig(...)
  return call('s:add_config', a:000)
endfun

let &cpo = s:save_cpo

let s:template_dir = split(&rtp, ',')[0]..'/templates/vimspector/'

fun! s:add_config(type, name, ...) abort
  " TODO: human-friendly exception feedback
  if !executable('jq')
    return
  endif

  let template_file = s:template_dir..a:type..'.json'
  if !filereadable(template_file)
    return
  endif

  let vars = { 'name': a:name }
  if a:0
    let vars.program = a:1
  endif

  try
    let template = json_decode(join(readfile(template_file), "\n"))
  catch
    return
  endtry

  let config = s:current_config()
  if !has_key(config, 'configurations')
    let config.configurations = {}
  endif
  call extend(config.configurations, template.configurations)

  try
    let jsonlines = systemlist('jq', json_encode(config))
    if !v:shell_error
      1,$delete _
      call append(0, jsonlines)
      silent! %s/\(\${temp:\(\w\+\)}\)/\=get(vars, submatch(2), submatch(0))/g
    endif
  catch
    throw v:exception
  endtry
endfun

fun! s:config_completion(arglead, cmdline, curpos)
  let cmdlead = a:cmdline[0: a:curpos == 0 ? 0 : a:curpos - 1]
  let args = split(cmdlead, '\([^\\] \)\+')

  let curarg = len(args)
  if cmdlead[-1:-1] == ' '
    let curarg += 1
  endif
  if curarg == 2
    return map(
          \  glob(printf('%s%s*.json', s:template_dir, a:arglead),
          \       v:false,
          \       v:true),
          \  { _, temp -> fnamemodify(temp, ':t:r') })
  elseif curarg == 4
    return glob(a:arglead..'*', v:false, v:true)
  endif
endfun

fun! Comp(...)
  return call('s:config_completion', a:000)
endfun

fun! s:current_config()
  try
    let config = json_decode(join(getline(1, '$'), "\n"))
  catch
    return {}
  endtry
  return type(config) is v:t_dict ? config : {}
endfun

