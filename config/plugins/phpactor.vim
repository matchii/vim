Plug 'phpactor/phpactor', { 'for': 'php', 'branch': 'master', 'do': 'composer install --no-dev -o' }

autocmd FileType php setlocal omnifunc=phpactor#Complete

augroup PhpactorMappings
    au!
    au FileType php nmap <buffer> <Leader>pi :PhpactorImportClass<CR>
    au FileType php nmap <buffer> <Leader>e :PhpactorClassExpand<CR>
    au FileType php nmap <buffer> <Leader>ua :PhpactorImportMissingClasses<CR>
    au FileType php nmap <buffer> <Leader>mm :PhpactorContextMenu<CR>
    au FileType php nmap <buffer> <Leader>nn :PhpactorNavigate<CR>
    au FileType php,cucumber nmap <buffer> <Leader>o :PhpactorGotoDefinition<CR>
    au FileType php,cucumber nmap <buffer> <Leader>Oh :PhpactorGotoDefinitionHsplit<CR>
    au FileType php,cucumber nmap <buffer> <Leader>Ov :PhpactorGotoDefinitionVsplit<CR>
    au FileType php,cucumber nmap <buffer> <Leader>Ot :PhpactorGotoDefinitionTab<CR>
    au FileType php nmap <buffer> <Leader>K :PhpactorHover<CR>
    au FileType php nmap <buffer> <Leader>pt :PhpactorTransform<CR>
    au FileType php nmap <buffer> <Leader>cc :PhpactorClassNew<CR>
    au FileType php nmap <buffer> <Leader>ci :PhpactorClassInflect<CR>
    au FileType php nmap <buffer> <Leader>fr :PhpactorFindReferences<CR>
    au FileType php nmap <buffer> <Leader>mf :PhpactorMoveFile<CR>
    au FileType php nmap <buffer> <Leader>cf :PhpactorCopyFile<CR>
    au FileType php nmap <buffer> <silent> <Leader>ee :PhpactorExtractExpression<CR>
    au FileType php vmap <buffer> <silent> <Leader>ee :<C-u>PhpactorExtractExpression<CR>
    au FileType php vmap <buffer> <silent> <Leader>em :<C-u>PhpactorExtractMethod<CR>
    au FileType php nmap <buffer> <silent> <Leader>ec :<C-u>PhpactorExtractConstant<CR>
augroup END
