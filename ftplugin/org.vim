
fun! CalculatePercent()
  let line = getline('.')
  let words = split(getline('.'))
  for word in words
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

command! CalculatePercent :call CalculatePercent()
