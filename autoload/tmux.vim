if has('patch-8.1.1116')
  scriptversion 3
endif

fun! tmux#SetWindowTitle(...) abort " {{{2
  if !exists("$TMUX") || !exists('*FugitiveWorkTree')
    return
  endif
  if a:0 && a:1
    let title = a:1 fnamemodify($PWD, ':~')
  else
    let project_root = FugitiveWorkTree()
    let title = substitute(strlen(project_root)
          \                ? fnamemodify(project_root, ':~')
          \                : expand('%:~:.'),
          \                '^\~/\.sync/dotfiles/', '~/.', '')
  endif
  call system(printf("tmux rename-window '%s'",
        \            strlen(title) > 30
        \            ? pathshorten(title)
        \            : title))
endfun

fun! tmux#SetPaneServerName() abort
  if exists("$TMUX_PANE") && empty(v:servername)
    call remote_startserver("VIM"..$TMUX_PANE[1:])
  endif
endfun

let s:ls_sessions = "tmux list-sessions -F '#{session_name} #{session_attached}'"

fun! tmux#SetProjectionistTmuxSession() abort
  if !exists("$TMUX")
    return
  endif

  let sessions = sort(filter(map(systemlist(s:ls_sessions),
        \                        { _, line -> map(split(line), { i, v -> i == 1 ? str2nr(v) : v })}),
        \                    { _, item -> item[0] =~# 'left$' }),
        \             { a, b -> b[1] - a[1] })

  if len(sessions)
    let g:tmux_session = sessions[0][0]
  endif
endfun

fun! s:split_session(_, str)
  let parts = split(a:str)
  let parts[1] = str2nr(parts[1])
  return parts
endfun
