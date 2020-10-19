try
  exe printf("colorscheme motoko_%d", &t_Co)
catch /E185/
  exe "colorscheme "..stylin#build('motoko', &t_Co)
endtry
