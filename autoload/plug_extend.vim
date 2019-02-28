
fun! plug_extend#begin(...) " {{{1
  call plug#begin()
  let opt = a:0 ? a:1 : {}

  let s:plug_local_path = []
  let s:plug_local_users = {}
  let s:plug_formats = get(opt, 'formats', {})

  if has_key(opt, 'local_paths')
    let s:plug_local_path = type(opt.local_paths) is v:t_string
          \               ? [opt.local_paths]
          \               : opt.local_paths
  endif

  if has_key(opt, 'local_users')
    if type(opt.local_users) is v:t_string
      let s:plug_local_users[opt.local_users] = v:true
    elseif type(opt.local_users) is v:t_list
      for usr in opt.local_users
        let s:plug_local_users[usr] = v:true
      endfor
    endif
  endif

  command! -nargs=+ -bar Plug call s:Plug(<args>)
endfun

fun! s:Plug(repo, ...) abort " {{{1
  let [host, repo] = a:repo =~# '^[a-z]:'
        \          ? split(a:repo, ':')
        \          : ['', a:repo]

  let opts = get(a:000, 0, {})

  let local = s:CheckLocal(repo, opts)

  let g:plug_url_format =
        \ get(s:plug_formats, host, 'https://git::@github.com/%s.git')

  call plug#(strlen(local) ? local : repo, opts)
endfun

fun! s:CheckLocal(repo, opts) abort " {{{1
  let [usr, name] = split(a:repo, '/')
  let name = get(a:opts, 'local', get(a:opts, 'as', name))

  if name == '!' || !has_key(s:plug_local_users, usr)
    return ''
  endif

  for dir in s:plug_local_path
    let path = expand(dir.name)
    if isdirectory(path)
      return path
    endif
  endfor
  return ''
endfun
