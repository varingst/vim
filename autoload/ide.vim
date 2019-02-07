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
fun! s:plug(id, repo, ...)
  let extra = index(s:enabled, a:id) >= 0
          \ ? a:0 ? a:1 : {}
          \ : extend(a:0 ? a:1 : {}, { 'on': 'IDEEnable'.toupper(a:id) })
  if has_key(extra, 'local')
    PlugLocal a:repo, extra
  else
    Plug a:repo, extra
  endif
endfun

command! -nargs=+ IDEPlug call s:plug(<args>)

fun! ide#plug(...)
  let s:enabled = a:000

  IDEPlug 'ycm', 'Valloric/YouCompleteMe'
  IDEPlug 'ycm', 'rdnetto/YCM-Generator', { 'branch': 'stable' }

  IDEPlug 'ale', 'w0rp/ale'
  IDEPlug 'ale', 'varingst/ale-silence', { 'local': v:true }

  IDEPlug 'ncm', 'roxma/vim-hug-neovim-rpc'
  IDEPlug 'ncm', 'roxma/nvim-yarp'
  IDEPlug 'ncm', 'ncm2/ncm2'

  IDEPlug 'ncm', 'ncm2/ncm2-pyclang'
  " IDEPlug 'ncm', 'Shougo/neco-vim'
  Plug 'Shougo/neco-vim'
  IDEPlug 'ncm', 'ncm2/ncm2-vim'
  IDEPlug 'ncm', 'ncm2/ncm2-bufword'
  IDEPlug 'ncm', 'ncm2/ncm2-path'

  IDEPlug 'lc', 'autozimu/LanguageClient-neovim', {
                            \ 'branch': 'next',
                            \ 'do': 'language-client-install',
                            \}

  IDEPlug 'coc', 'neoclide/vim-node-rpc'
  IDEPlug 'coc', 'neoclide/coc.nvim', {
                            \ 'tag': '*',
                            \ 'do': { -> coc#util#install()}
                            \}
endfun



" -- ADAPTER -- {{{1

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

fun! ide#trigger_completion()
  return ncm2#manual_trigger()
endfun

fun! ide#trigger_alt_completion()
  return ncm2#force_trigger()
endfun

fun! ide#init() " {{{1
  inoremap <expr> <Plug>CompleteNext pumvisible() ? "\<C-N>" : "\<C-R>=ide#trigger_completion()\<CR>"
  inoremap <expr> <Plug>CompletePrev pumvisible() ? "\<C-P>" : "\<C-R>=ide#trigger_alt_completion()\<CR>"

  let reset_opt="au User Ncm2PopupClose set completeopt=".&completeopt

  augroup ncm2_completion_autocmd
    autocmd!
    au BufWinEnter * if has_key(g:ncm2_filetype_whitelist, &filetype)
                 \ |   call ncm2#enable_for_buffer()
                 \ | endif
    au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
    exe reset_opt
  augroup END

  for key in keys(s:map)
    exe printf('nnoremap <Plug>%s :call s:lookup("%s")<CR>', key, key)
  endfor

  command! -nargs=?
         \ -complete=custom,s:rename_completion
         \ Rename call s:rename(<q-args>)

  " -- Language Client ------------------------------------------------------ {{{3

  " leave diagnostics to ALE, for now
  let g:LanguageClient_diagnosticsEnable = 0

  let g:LanguageClient_serverCommands = {
      \ 'ruby': ['solargraph', 'stdio'],
      \ }

  if filereadable(expand('~/.jars/EmmyLua-LS-all.jar'))
    let g:LanguageClient_serverCommands['lua'] = [
          \ 'java',
          \ '-cp',
          \ expand('~/.jars/EmmyLua-LS-all.jar'),
          \ 'com.tang.vscode.MainKt' ]
  endif

  let g:LanguageClient_rootMarkers = {
      \ 'ruby': ['Gemfile']
      \ }

  let g:LanguageClient_diagnosticsList = 'Quickfix'

  if v:false " needs more haxx
    let tmp = tempname()
    let g:LanguageClient_loggingFile = tmp.'lc-client.log'
    let g:LanguageClient_serverStderr = tmp.'lc-server.log'
    command! LangClientLog exe "vsplit ".g:LanguageClient_loggingFile
    command! LangServerLog exe "vsplit ".g:LanguageClient_serverStderr
  endif

  let g:LanguageClient_diagnosticsDisplay = {
        \ 1: {
        \   'name': g:sym.error,
        \   'texthl': 'ALEError',
        \   'signText': g:sym.gutter_error,
        \   'signTexthl': 'ALEErrorSign',
        \ },
        \ 2: {
        \   'name': g:sym.warning,
        \   'texthl': 'ALEWarning',
        \   'signText': g:sym.gutter_warning,
        \   'signTexthl': 'ALEWarningSign',
        \ },
        \ 3: {
        \   'name': g:sym.info,
        \   'texthl': 'ALEInfo',
        \   'signText': g:sym.gutter_info,
        \   'signTexthl': 'ALEInfoSign',
        \ },
        \ 4: {
        \   'name': g:sym.info,
        \   'texthl': 'ALEInfo',
        \   'signText': g:sym.gutter_info,
        \   'signTexthl': 'ALEInfoSign',
        \ },
        \}


  " -- NCM2 ----------------------------------------------------------------- {{{3

  let g:ncm2_filetype_whitelist = extend({
        \ 'ruby': 1,
        \ 'vim': 1,
        \}, g:LanguageClient_serverCommands)

  let g:clang_path = '/usr/lib/llvm/6'
  let g:ncm2_pyclang#library_path = g:clang_path.'/lib64/libclang.so.6'
  let g:ncm2_pyclang#clang_path   = g:clang_path.'/bin/clang'
  let g:ncm2_pyclang#database_path = [ 'compile_commands.json' ]
  let g:ncm2_pyclang#args_file_path = [ '.clang_complete' ]

  " see :help Ncm2PopupOpen
  let g:normal_completeopt = &completeopt

  " interval in ms before starting to compute completions
  let g:ncm2#complete_delay = 0
  let g:ncm2#auto_popup = 0


  " -- YCM ------------------------------------------------------------------ {{{3

  let g:ycm_filetype_whitelist = { '*': 1 }
  let g:ycm_filetype_blacklist = extend({
        \ 'tagbar': 1,
        \ 'markdown': 1,
        \ 'vimwiki': 1,
        \}, g:ncm2_filetype_whitelist)

  " minimum chars to trigger identifier completion (2)
  let g:ycm_min_num_of_chars_for_completion = 2
  " minimum matching characters for candidate to be shown (0)
  let g:ycm_min_num_identifier_candidate_chars = 0
  " max number of indentifier suggestions in menu (10)
  let g:ycm_max_num_identifier_candidates = 50

  " max number of semantic suggestions in menu (50)
  let g:ycm_max_num_candidates = 100

  " completion menu auto popup (1)
  let g:ycm_auto_trigger = 1

  let g:ycm_complete_in_comments = 0
  let g:ycm_complete_in_strings = 1

  " filetypes for which to disable filepath completion
  let g:ycm_filepath_blacklist = {
        \ 'html': 1,
        \ 'jsx': 1,
        \ 'xml': 1,
        \ }
  " -- diagnostics -- {{{4
  "
  " Let ALE handle diagnostics

  " diagnostics for c, cpp, objc, objcpp, cuda
  let g:ycm_show_diagnostics_ui = 0

  " put icons in vim's gutter
  let g:ycm_enable_diagnostic_signs = 0
  let g:ycm_enable_diagnostic_highlighting = 0

  " echo diagnostic of current line
  let g:ycm_echo_current_diagnostic = 0

  " gutter symbols
  let g:ycm_error_symbol = g:sym.gutter_error
  let g:ycm_warning_symbol = g:sym.gutter_warning


  " filter
  " 'filetype: { 'regex': [ ... ], 'level': 'error',
  let g:ycm_filter_diagnostics = {}

  " populate location list on new data
  let g:ycm_always_populate_location_list = 0

  " auto open location list after :YcmDiags
  let g:ycm_open_loclist_on_ycm_diags = 0

  " --- }}}

  let g:ycm_use_ultisnips_completer = 0

  let g:ycm_add_preview_to_completeopt = 0


  "let g:ycm_filetype_specific_completion_to}
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax = 1

  let g:ycm_key_invoke_completion = get(g:, 'completion_key', "\<TAB>")
  let g:ycm_key_list_select_completion = ['<C-j>', '<Tab>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-k>', '<S-Tab>', '<Up>']


  let g:ycm_global_ycm_extra_conf = expand('$HOME').'/.vim/ycm.py'
  let g:ycm_extra_conf_vim_data = [
        \ '&filetype',
        \ 'g:gcc_flags',
        \]
  " let g:ycm_config_extra_conf = 0

  let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1

  let g:ycm_semantic_triggers = {
    \   'c'               : ['->', '.'],
    \   'objc'            : ['->', '.'],
    \   'ocaml'           : ['.', '#'],
    \   'cpp,objcpp'      : ['->', '.', '::'],
    \   'perl'            : ['->'],
    \   'php'             : ['->', '::'],
    \   join([
          \ 'cs',
          \ 'd',
          \ 'elixir',
          \ 'haskell',
          \ 'java',
          \ 'javascript',
          \ 'python',
          \ 'perl6',
          \ 'ruby',
          \ 'scala',
          \ 'vb',
          \ 'vim'
    \   ], ',')           : [ '.' ],
    \   'lua'             : ['.', ':'],
    \   'erlang'          : [':'],
    \ }
endfun

