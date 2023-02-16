let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

let s:note_dir = $HOME .. '/.notes'
let s:note_ext = '.md'

augroup notes
  au!
  exe printf('au BufNewFile %s/*%s call setline(1, "# "..expand("%%:t:r"))',
        \ s:note_dir, s:note_ext)
  exe printf('au BufReadPost %s/*%s call s:init_buffer()',
        \ s:note_dir, s:note_ext)
augroup END

fun! s:select_id(args, callback)
  call fzf#run({
        \ 'source': printf('%s/bin/note "%s" "%s" %s', $MYVIMHOME, s:note_dir, s:note_ext, a:args),
        \ 'options': printf('--with-nth=3.. --preview="cat %s/{2}%s"', s:note_dir, s:note_ext),
        \ 'sink': { s -> a:callback(split(s)[1]) },
        \})
endfun

fun! s:id2file(id)
  return printf('%s/%s%s', s:note_dir, a:id, s:note_ext)
endfun

fun! s:open(bang, file)
  return printf(empty(a:bang) ? "Split %s" : "edit %s", a:file)
endfun

fun! s:insert_id(id)
  call feedkeys('[['..a:id..']]', 'i')
endfun

fun! s:init_buffer()
  let &l:path = s:note_dir
  let &l:suffixesadd = s:note_ext
  command! -buffer -bang NoteNew exe s:open(<q-bang>, s:id2file(localtime()))
  command! -buffer -bang Note call s:select_id('title', { id -> execute(s:open(<q-bang>, s:id2file(id))) })
  inoremap <buffer> ,t <C-\><C-O>:call <SID>select_id('title', function("\<SID>insert_id"))<CR>
endfun

let &cpo = s:save_cpo
