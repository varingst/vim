set nocp
call plug#begin()
call plug#('~/.vim/proto/wrap')
source ~/.vim/proto/wrap/plugin/test.vim
call plug#end()

call wrap#('Foo')
call wrap#('Foo', test#s, SFunc('Foo'))
call wrap#('test#Foo')

call Foo()
call assert_equal('global', wrap#last().result)

call Foo()
call assert_equal('global', wrap#last().result)

call SFoo()
call assert_equal('script-local', wrap#last().result)

call test#Foo()
call assert_equal('autoload', wrap#last().result)

nmap <space> :source ~/.vim/debugrc/function_wrapper.vim<CR>

if len(v:errors)
  echo v:errors
endif
