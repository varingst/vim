if has('patch-8.1.1116')
  scriptversion 3
endif

fun! plugged#begin(...) " {{{1
  let l:opt = a:0 ? a:1 : {}

  if has_key(l:opt, 'root')
    call plug#begin(l:opt.root)
  else
    call plug#begin()
  endif

  call s:CocBegin(l:opt)

  let s:plug_local_path = []
  let s:plug_local_users = {}
  let s:plug_formats = get(l:opt, 'formats', {})

  if has_key(l:opt, 'local_paths')
    let s:plug_local_path = type(l:opt.local_paths) is v:t_string
          \               ? [l:opt.local_paths]
          \               : l:opt.local_paths
  endif

  if has_key(l:opt, 'local_users')
    if type(l:opt.local_users) is v:t_string
      let s:plug_local_users[l:opt.local_users] = v:true
    elseif type(l:opt.local_users) is v:t_list
      for usr in l:opt.local_users
        let s:plug_local_users[usr] = v:true
      endfor
    endif
  endif

  command! -nargs=+ -bar Plug silent call s:Plug(<args>)
  command! -nargs=+ CoC silent call s:Coc(<args>)
endfun

fun! plugged#end() "{{{1
  call plug#end()
  delcommand CoC
  " delcommand PlugUpdate
endfun

" -- Plug Extensions ------------------------------------------------------ {{{1

fun! s:Plug(repo, ...) abort " {{{2
  let [host, repo] = a:repo =~# '^[a-z]:'
        \          ? split(a:repo, ':')
        \          : ['', a:repo]

  let opts = get(a:000, 0, {})

  let local = s:CheckLocal(repo, opts)

  let g:plug_url_format =
        \ get(s:plug_formats, host, 'https://git::@github.com/%s.git')

  call plug#(strlen(local) ? local : repo, opts)
endfun

fun! s:CheckLocal(repo, opts) abort " {{{2
  let [usr, name] = split(a:repo, '/')
  let name = get(a:opts, 'local', get(a:opts, 'as', name))

  if name == '!' || !has_key(s:plug_local_users, usr)
    return ''
  endif

  for dir in s:plug_local_path
    let path = expand(dir..name)
    if isdirectory(path)
      return path
    endif
  endfor
  return ''
endfun

fun! s:Update() abort " {{{2
  let s:time = reltimestr(reltime())
  call scall#('autoload/plug.vim', 'update', 0, [])
  " PlugUpdate
  call timer_start(100, { id -> s:DelayedInstall(id) }, { 'repeat': -1 })
endfun

" command! Update call s:Update()

fun! s:DelayedInstall(timer_id) abort " {{{2
  if get(getbufline('[Plugins]', 1), 0, '') !~ '^Updated'
    return
  endif

  call timer_stop(a:timer_id)
  call s:CocInstall()
endfun

" -- CoC ------------------------------------------------------------------ {{{1

fun! s:CocBegin(opt) "{{{1
  let s:coc_ext_root = g:plug_home..get(a:opt,
        \                               'coc_ext_root',
        \                               '/coc-extensions')..'/'
  if !isdirectory(s:coc_ext_root)
    call mkdir(s:coc_ext_root, 'p')
  endif

  let s:coc_ext = {}
endfun

fun! s:Coc(...) " {{{1
  let l:opt = { 'do': 'yarn install --frozen-lockfile' }
  for l:ext in map(copy(a:000), { _, repo -> repo =~ '/'
        \                                  ? repo
        \                                  : 'neoclide/coc-'..repo })
    call plug#(l:ext, l:opt)
  endfor
endfun

" TODO: get this working with the yarn workspace
fun! s:CocFancier(...) "{{{1
  let l:opt = { 'do': function('s:CocDo') }
  for l:ext in map(copy(a:000), { _, repo -> repo =~ '/'
        \                                  ? repo
        \                                  : 'neoclide/coc-'..repo })
    let l:name = matchstr(l:ext, '/\zs.*')
    let l:opt.dir = s:coc_ext_root.l:name
    let s:coc_ext[l:name] = { 'dir': l:opt.dir }
    call plug#(l:ext, l:opt)
  endfor
endfun

fun! s:CocDo(info) abort "{{{1
  call extend(s:coc_ext[a:info.name], a:info)
  call s:CocEnsureIgnoredModules(s:coc_ext[a:info.name].dir)
endfun

fun! s:CocInstall(...) "{{{1
  if empty(filter(s:coc_ext,
        \         { name, plug ->
        \                      get(plug, 'status', '') != 'unchanged' }))
    return
  endif

  call writefile([json_encode({
        \ 'private': v:true,
        \ 'workspaces': keys(s:coc_ext),
        \ })], s:coc_ext_root..'package.json')

  let l:pwd = getcwd()
  call chdir(s:coc_ext_root)
  !yarn install --frozen-lockfile
        \       --non-interactive
        \       --audit
        \       --ignore-engines
        \       --production
  call chdir(l:pwd)
endfun

fun! s:CocEnsureIgnoredModules(dir) abort
  " un-fucking-believable
  let l:info = a:dir..'/.git/info/'
  if !isdirectory(l:info)
    call mkdir(l:info)
  endif
  call writefile(['node_modules'], l:info..'exclude')
endfun

" -- Snapshot ------------------------------------------------------------- {{{1

command! -bang Snapshot call s:Snapshot(<q-bang>)
command! -nargs=1 -complete=custom,s:complete Rollback call s:Rollback(<q-args>)

let s:vimroot = split(&rtp, ',')[0]

fun! s:Snapshot(force)
  if empty(a:force)
    let l:not_ready = s:NotReady()
    if !empty(l:not_ready)
      for l:name in sort(keys(l:not_ready))
        call s:echowarn(printf("%s: %s", l:name, fnamemodify(l:not_ready[l:name].dir, ':~')), 1)
        call map(l:not_ready[l:name].repostatus, { _, status -> s:echo(status, 2)})
      endfor
      call s:echowarn(printf("%d repos dirty, cannot create snapshot", len(l:not_ready)), 1)
      return
    endif
  endif

  exe 'PlugSnapshot! '..s:SnapFile()
endfun

fun! s:Rollback(file) abort
  let l:rcrev = split(a:file, '[.-]')[-2]
  let l:snapfile = s:SnapPath(a:file)
  if !filereadable(l:snapfile)
    throw printf("Could not find snapshot '%s'", l:snapfile)
  endif
  return l:rcrev
endfun

fun! s:SnapFile()
  return s:SnapPath(printf('%s-%s.vim',
        \ strftime('%Y-%m-%d'),
        \ trim(system(printf('git -C "%s" rev-parse --short HEAD',
        \                    s:vimroot)))))
endfun

fun! s:SnapPath(...)
  return s:vimroot..'/.git/snapshots/'..(a:0 ? a:1 : '')
endfun

fun! s:RepoStatus(dir)
  return systemlist(printf('git -C "%s" status --short', a:dir))
endfun

fun! s:NotReady()
  return filter(map(copy(g:plugs),
        \           { _, plug -> extend(plug, { 'repostatus': s:RepoStatus(plug.dir)})}),
        \       { _, plug -> !empty(plug.repostatus) })
endfun

fun! s:echo(msg, ...)
  echo repeat('  ', a:0 ? a:1 : 0)..a:msg
endfun

fun! s:echowarn(...)
  echohl WarningMsg
  call call('s:echo', a:000)
  echohl None
endfun

fun! s:complete(...)
  return join(map(reverse(glob(s:SnapPath('*.vim'), v:true, v:true)),
        \         { _, file -> fnamemodify(file, ':t:r')}),
        \     "\n")
endfun

" -- PlugClean alternative ------------------------------------------------ {{{1

fun! s:dmod(dir)
  return fnamemodify(a:dir, ':h')
endfun

fun! s:clean(force) abort
  call scall#('autoload/plug.vim', 'prepare')
  call append(0, 'Searching for invalid plugins in '..g:plug_home)
  call append(1, '')

  let dirs = {}
  let errs = {}
  let [cnt, total] = [0, len(g:plugs)]
  for [name, spec] in items(g:plugs)
    if !scall#('autoload/plug.vim', 'is_managed', name)
      let dirs[s:dmod(spec.dir)] = name
    else
      let [err, clean] = scall#('autoload/plug.vim', 'git_validate', spec, 1)
      if clean
        let errs[s:dmod(spec.dir)] = scall#('autoload/plug.vim', 'lines', err)[0]
      else
        let dirs[s:dmod(spec.dir)] = name
      endif
    endif
    let cnt += 1
    call scall#('autoload/plug.vim', 'progress_bar', 2, repeat('=', cnt), total)
    normal! 2G
    redraw
  endfor

  let todo = []
  for dir in map(glob(g:plug_home..'/*/.git', v:false, v:true),
        \        { _, d -> s:dmod(d) })
    if !has_key(dirs, dir)
      call add(todo, dir)
      call append(line('$'), '- '..dir)
      if has_key(errs, dir)
        call append(line('$'), '    '..errs[dir])
      endif
    endif
  endfor

  4
  redraw
  if empty(todo)
    call append(line('$'), 'Already clean.')
  else
    " TODO: this sets state for s:delete function, booo, need to reeimplement
    let s:clean_count = 0
    call append(3, ['Directories to delete:', ''])
    redraw!
    if a:force || scall#('autoload/plug.vim', 'ask_no_interrupt', 'Delete all directories?')
      call scall#('autoload/plug.vim', 'delete', [6, line('$')], 1)
    else
      call setline(4, 'Cancelled.')
      nnoremap <silent> <buffer> d :set opfunc=<SID>delete_op<CR>g@
      nmap     <silent> <buffer> dd d_
      xnoremap <silent> <buffer> d :<C-U>call <SID>delete_op(visualmode(), 1)<CR>
      echo 'Delete the lines (d{motion}) to delete the corresponding directories.'
    endif
  endif
  4
  setlocal nomodifiable
endfun

fun! s:delete_op(...)
  call s:delete(a:0 ? [line("'<"), line("'>")] : line("'["), line("']")], 0)
endfun

function! s:delete(range, force)
  let [l1, l2] = a:range
  let force = a:force
  while l1 <= l2
    let line = getline(l1)
    if line =~ '^- ' && isdirectory(line[2:])
      execute l1
      redraw!
      let answer = force ? 1 : scall#('autoload/plug.vim', 'ask', 'Delete '..line[2:]..'?', 1)
      let force = force || answer > 1
      if answer
        call s:rm_rf(line[2:])
        setlocal modifiable
        call setline(l1, '~'..line[1:])
        let s:clean_count += 1
        call setline(4, printf('Removed %d directories.', s:clean_count))
        setlocal nomodifiable
      endif
    endif
    let l1 += 1
  endwhile
endfunction

command! Clean call s:clean(v:false)
