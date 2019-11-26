call WaitForExtension('coc-tsserver')

sleep 2

normal! 5G
" Don't know waiting is needed here. Assumed that the backend was
" ready when extension state is 'activated'

call WaitFor({ -> CocAction('jumpDefinition')}, 5, "coc-tsserver on-line")
" call assert_true(CocAction('jumpDefinition'), "didn't find definition")
call assert_equal(1, line('.'), 'cursor not moved to line 1')
