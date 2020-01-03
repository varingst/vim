let s:save_cpo = &cpo
set cpo&vim
if has('patch-8.1.1116')
  scriptversion 3
endif

fun! align#(...)
  return printf(":'<,'>g//call %s('%s')\<HOME>%s",
        \              s:sid('Align'),
        \              get(a:000, 0, ''),
        \              repeat("\<Right>", 7))
endfun

if get(g:, 'align_TESTING')
  fun! align#run(...)
    return call('s:Align', a:000)
  endfun
endif

fun! s:Align(...)
  if line('.') == line("'<")
    let pos = { 'lines': [], 'next': {} }
    let g:pos = pos

    fun! s:_collect() closure
      let [lnum, col] = [line('.'), col('.')]

      if !has_key(pos, lnum)
        let pos[lnum] = []
        call add(pos.lines, lnum)
        let pos.next[lnum] = 0
      endif

      call add(pos[lnum], col)

      return submatch(0)
    endfun

    fun! s:_align() closure
      if !has_key(pos, 'offsets')
        let pos.offsets = {'max': [0]}
        for lnum in pos.lines
          let pos.offsets[lnum] = [pos[lnum][0]]
          if pos.offsets[lnum][0] > pos.offsets.max[0]
            let pos.offsets.max[0] = pos.offsets[lnum][0]
          endif

          for i in range(1, len(pos[lnum]) - 1)
            if i >= len(pos.offsets.max)
              call add(pos.offsets.max, 0)
            endif

            let offset = pos[lnum][i] - pos[lnum][i-1]
            call add(pos.offsets[lnum], offset)
            if pos.offsets.max[i] < offset
              let pos.offsets.max[i] = offset
            endif
          endfor
        endfor
      endif

      let lnum = line('.')
      let idx = pos.next[lnum]
      let pos.next[lnum] += 1
      let offset = pos.offsets.max[idx] - pos.offsets[lnum][idx]

      return repeat(' ', offset)..submatch(0)
    endfun
  endif

  exe printf("s//\\=%s()/%s", s:sid('_collect'), get(a:000, 0, ''))

  if line('.') == line("'>")
    exe printf("'<,'>s//\\=%s()/%s", s:sid('_align'), get(a:000, 0, ''))
    call histdel('search', -1)
    let @/ = histget('search', -1)
  endif
endfun

fun! s:sid(func) "{{{2
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')..a:func
endfun

let &cpo = s:save_cpo
