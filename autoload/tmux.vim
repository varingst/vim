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
  if !exists("$TMUX_PANE") && empty(v:servername)
    call remote_startserver("VIM"..$TMUX_PANE[1:])
  endif
endfun

