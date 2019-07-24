if exists('g:did_load_filetypes')
  finish
endif

augroup filetypedetect
  au! BufRead,BufNewFile make.conf.* setfiletype gentoo-make-conf
augroup END
