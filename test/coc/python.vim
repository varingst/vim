call WaitForExtension('coc-python')

normal! 5G
call assert_true(CocAction('jumpDefinition'), "didn't find definition")
call assert_equal(1, line('.'), 'cursor not moved to line 1')
