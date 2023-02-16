let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

command! -buffer ReadDisks read !for dev in /dev/sd[a-z]; do
      \ echo "\# $(lsblk --noheadings --output=SERIAL $dev) $(udevadm info --query=path "$dev")";
      \ done | column -t 2>/dev/null

command! -buffer -nargs=1 ReadUdevInfo
      \   exe  'read !udevadm info --path=$(udevadm info --query=path '..<q-args>..')'
      \ | exe "'[,']normal! I\# \<ESC>"

let &cpo = s:save_cpo
