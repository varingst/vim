
fun! CalculatePercent()
  let line = getline('.')
  let words = split(getline('.'))
  " remove existing percent
  if words[-1] =~ '^\d\+\.\d%$'
    let line = line[0:match(line, ' *'.words[-1]) - 1]
    call remove(words, -1)
  endif
  for word in words
    " find fraction in line
    if word =~ '^\d\+\/\d\+$'
      let [num, denom] = split(word, '/')
      let d = str2float(denom)
      if d == 0
        continue
      endif
      let p = str2float(num) / d * 100
      call setline('.', line . " " . printf("%5.1f%%", p))
    endif
  endfor
endfun

" TODO: Implement range
command! CalculatePercent :call CalculatePercent()

nmap <localleader>z <S-Left>
nmap <localleader>x <S-Right>


" asd;lfj asdf a 34/48 adf asdf 
" adsf l;ajsd 99/99
