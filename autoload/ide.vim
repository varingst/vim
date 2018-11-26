" == YCM ==
"
" GoToInclude                       c, cpp, objc, objcpp, cuda
" GoToDeclaration                   *
" GoToDefinition                    *
" GoTo                              *
" GoToImprecise                     c, cpp, objc, objcpp, cuda
" GoToReferences                    java, javascript, python, typescript
" GoToImplementation                cs
" GoToImplementationElseDeclaration cs
" GoToType
"
" GetType
" GetTypeImprecise
" GetParentA                        c, cpp, objc, objcpp, cuda
" GetDoc                            *
" GetDocImprecise                   c, cpp, objc, objcpp, cuda
" FixIt                             c, cpp, objc, objcpp, cuda, cs, java,
"                                   javascript, typescript
" RefactorRename                    java, javascript, h
" Format                            java, javascript, typescript
" OrganizeImports                   java, javascript, typescript
"
" == LanguageClient# functions ==
" textDocument_hover() show type info and short doc
" textDocument_definition() goto definition under cursor
" textDocument_typeDefinition goto type definition under cursor
" textDocument_implementation() goto implementation under cursor
" textDocument_rename() rename identifier under cursor
" textDocument_documentSymbol  list of current buffer's symbol
" textDocument_references      list of references of identifier under cursor
" textDocument_formatting      format current document
" textDocument_rangeFormatting  format selected lines
" textDocument_documentHighlight  highlight usages of symbol under cursor
" textDocument_clearDocumentHighlight      clear ^
" textDocument_workspace_symbol   list symbols in a project
"
" au command LanguageClientDiagnosticsChanged
"
" == ALE ==
" ALEGoToDefinition
" ALEFindReferences
" ALEHover
" ALESymbolSearch

" TODO: add symbol search
let s:map = {
  \ 'Goto':
      \ ['Goto',               'definition',     'GotoDefinition', v:true],
  \ 'Definition':
      \ ['GotoDefinition',     'definition',     'GotoDefinition', v:true],
  \ 'Declaration':
      \ ['GotoDeclaration',    '',               '',               v:true],
  \ 'Implementation':
      \ ['GotoImplementation', 'implementation', '',               v:true],
  \ 'TypeDefinition':
      \ ['GoToType',           'typeDefinition', '',               v:true],
  \ 'References':
      \ ['GoToReferences',     'references',     'FindReferences', v:true],
  \ 'Include':
      \ ['GotoInclude',        '',               '',               v:true],
  \ 'Parent':
      \ ['GetParent',          '',               '',               v:false],
  \ 'Doc':
      \ ['GetDoc',             'hover',          'Hover',          v:false],
  \ 'Type':
      \ ['GetType',            'hover',          'Hover',          v:false],
      \}

fun! s:ft_in(dict)
  return has_key(get(g:, a:dict, {}), &filetype)
endfun


" TODO: opens
fun! s:lookup(key)
  let [ycm, lc, ale, opens] = get(s:map, a:key, ['', '', v:false])

  if opens
    " store current pos
  endif

  if !s:ft_in('ycm_filetype_blacklist') && strlen(ycm)
      exe "YcmCompleter ".ycm
    endif
  elseif s:ft_in('LanguageClient_serverCommands') && strlen(lc)
      call call('LanguageClient#textDocument_'.lc, [])
    endif
  elseif strlen(ale)
    exe 'ALE'.ale
  else
    return
  endif

  if opens
    " restore pos/open split, whatever
  endif
endfun

fun! s:ensure_abolish()
  if !has_key(s:, 'abolish')
    let s:abolish = filter(keys(get(g:, 'Abolish', {})),
                         \ 'v:val =~ "case"')
  endif
endfun

fun! s:rename(new_name)
  call s:ensure_abolish()
  let l:new_name =
        \ index(s:abolish, a:new_name) >= 0 && has_key(g:, 'Abolish') ?
        \ Abolish[a:new_name](expand('<cword>')) :
        \ l:new_name
  if !s:ft_in('ycm_filetype_blacklist')
    exe "YcmCompleter RefactorRename ".l:new_name
  elseif s:ft_in('LanguageClient_serverCommands')
    return strlen(l:new_name) ?
          \ LanguageClient#textDocument_rename({ 'newName': l:new_name })
          \ LanguageClient#textDocument_rename()
  endif
endfun

fun! s:rename_completion(...)
  call s:ensure_abolish()
  return join(s:abolish, "\n")
endfun

fun! s:lc_update()
  let s:n = get(s:, 'n', 0) + 1
  let g:airline_debug = 'LC: '.s:n.' updates!'
  let qf = getqflist()
  if len(qf)
    let bnr = winbufnr('.')
    call setqflist([], 'r')
    call ale#engine#HandleLoclist('LC', bnr, qf, 1)
  endif
endfun
" TODO: this does not work properly, does not clean out error from loclist
" properly
" augroup idebackend
  " autocmd!
  " au User LanguageClientDiagnosticsChanged call s:lc_update()
" augroup END
fun! ide#init()
  for key in keys(s:map)
    exe printf('nnoremap <Plug>%s :call s:lookup("%s")<CR>', key, key)
  endfor
endfun

command! -nargs=?
       \ -complete=custom,s:rename_completion
       \ Rename call s:rename(<q-args>)
