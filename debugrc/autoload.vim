" set nocp

echo "function exists: ".exists('*test#foo')
source ~/.vim/autoload/test.vim
echo "function exists: ".exists('*test#foo')
echo test#foo()
