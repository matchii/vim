""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" MENU
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Menu items {{{"
noremenu 100.200 PHP.Check\ Syntax<Tab><Leader>mm     :call RunSyntaxCheck()<CR>
noremenu 100.300 PHP.Mess\ Detector<Tab><Leader>md    :call RunMessDetection()<CR>
noremenu 100.400 PHP.Code\ Sniffer<Tab><Leader>mf     :call RunCodeSniff()<CR>
noremenu 100.500 PHP.Code\ Duplication<Tab><Leader>mp :call RunCopyPasteDetection()<CR>
nnoremenu 100.600 PHP.Find\ occurences<Tab><Leader>ff :call FindOccurences(expand('<cword>'))<CR>
vnoremenu 100.650 PHP.Find\ occurences<Tab><Leader>ff :call FindOccurences(getline(".")[col("'<")-1:col("'>")-1])<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" SHORTCUTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Runs PHP syntax check on the current file or directory.
noremap <Leader>mm :execute 'make %'<CR>
" Runs PHP Mess Detector on the current file or directory.
" See http://phpmd.org
noremap <Leader>md :call RunMessDetection()<CR>
" Runs PHP Code Sniffer on the current file or directory.
" See https://github.com/squizlabs/PHP_CodeSniffer
noremap <Leader>mf :call RunCodeSniff()<CR>
" Runs PHP Copy/Paste Detector on the current file or directory.
" See https://github.com/sebastianbergmann/phpcpd
noremap <Leader>mp :call RunCopyPasteDetection()<CR>
" Shows occurences of word under cursor
nnoremap <Leader>ff :call FindOccurences(expand('<cword>'))<CR>
" Shows occurences of visually selected text
vnoremap <Leader>ff :call FindOccurences(getline(".")[col("'<")-1:col("'>")-1])<CR>
" Creates condition block
noremap  <Leader>ii :call SetIfBlock(line('.'), line('.'))<CR>k0f(a
vnoremap  <Leader>ii :<C-U>call SetIfBlock(line("."), line("'>"))<CR>k0f(a

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" RunMessDetection {{{
function! RunMessDetection()
    let l:file = 'mess_in_' . expand('%:t') . '.mess'
    execute 'redir! > /tmp/' . l:file
    execute 'silent !phpmd ' . @% . ' text design,unusedcode,codesize | sed s/^.*:// -'
    execute 'redir END'
    execute 'split'
    " Hint: To open new buffer next to, instead of 'split' use 'Te'
    execute 'e /tmp/' . l:file
    "TODO: Now I want to implement the functionality that clicking on the line
    "number in md report moves cursor in the file buffer to that line.
endfunction
" }}}

" RunCodeSniff {{{
function! RunCodeSniff()
    let l:file = 'smell_in_' . expand('%:t') . '.sniff'
    let l:cs_standard = get(g:, 'code_style_standard', 'PSR2')
    execute 'redir! > /tmp/' . l:file
    execute 'silent !phpcs --standard=' . cs_standard . ' --report-width=120 ' . @%
    execute 'redir END'
    execute 'split'
    execute 'e /tmp/' . l:file
endfunction
" }}}

" RunCopyPasteDetection {{{
function! RunCopyPasteDetection()
    let l:file = 'dupes_in_' . expand('%:t')
    execute 'redir! > /tmp/' . l:file
    execute 'silent !phpcpd ' . @%
    execute 'redir END'
    execute 'split'
    execute 'e /tmp/' . l:file
endfunction
" }}}

" FindOccurences {{{
function! FindOccurences(string)
    let l:file = substitute(a:string, '\s\+', '_', 'g')[0:64].'.occur'
    execute 'redir! > /tmp/' . l:file
    execute 'silent !szukaj "' . a:string . '"'
    execute 'redir END'
    execute 'split'
    execute 'e /tmp/' . l:file
    execute 'silent %s/:\s\+/:/'
    execute 'w'

    execute 'syn match   searched   "' . a:string . '"'
endfunction
" }}}

" SetIfBlock obejmuje fragment pomiędzy liniami blokiem if i zwiększa wcięcie o 1 poziom {{{
function! SetIfBlock(first_line, last_line)
    if a:first_line > a:last_line
        return
    endif
    let prev_line = a:first_line - 1
    let indent = matchstr(getline(a:first_line), '^\zs\s*\ze')

    call append(a:last_line, indent."}")
    let cur_line = a:last_line
    while cur_line >= a:first_line
        call setline(cur_line, substitute(getline(cur_line), "^", "    ", ''))
        let cur_line -= 1
    endwhile
    call append(prev_line, indent."if () {")
endfunction
" }}}

" SetTryCatchBlock obejmuje fragment pomiędzy liniami blokiem try..catch i zwiększa wcięcie o 1 poziom {{{
function! SetTryCatchBlock(first_line, last_line)
    if a:first_line > a:last_line
        return
    endif
    let prev_line = a:first_line - 1
    let indent = matchstr(getline(a:first_line), '^\zs\s*\ze')

    call append(a:last_line, indent."}")
    call append(a:last_line, indent."} catch () {")
    let cur_line = a:last_line
    while cur_line >= a:first_line
        call setline(cur_line, substitute(getline(cur_line), "^", "    ", ''))
        let cur_line -= 1
    endwhile
    call append(prev_line, indent."try {")
endfunction
" }}}

" SetComment {{{
function! SetComment(first_line, last_line)
    if a:first_line > a:last_line
        return
    endif
    let prev_line = a:first_line - 1
    let indent = matchstr(getline(a:first_line), '^\zs\s*\ze')

    call append(a:last_line, ' */')
    let cur_line = a:last_line
    while cur_line >= a:first_line
        call setline(cur_line, substitute(getline(cur_line), "^", "", ''))
        let cur_line -= 1
    endwhile
    call append(prev_line, '/*')
endfunction
" }}}

" MakeSetterAndGetter {{{
function! MakeSetterAndGetter(variable)
    call MakeSetter(a:variable)
    call MakeGetter(a:variable)
endfunction
" }}}

" MakeGetter {{{
function! MakeGetter(variable)
    let var = a:variable
    let cvar = substitute(var, '^_', '', '')
    let cvar = toupper(cvar[0]).cvar[1:]
    let indent = "    "
    let l = line('.')
    let text = [
        \ '',
        \ indent."public function get".cvar."()",
        \ indent."{",
        \ indent.indent."return $this->".var.";",
        \ indent."}",
    \ ]
    call append(searchpair('{', '', '}', 'Wnr')-1, text)
endfunction
" }}}

" MakeSetter {{{
function! MakeSetter(variable)
    let var = a:variable
    let cvar = substitute(var, '^_', '', '')
    let uvar = toupper(cvar[0]).cvar[1:]
    let indent = "    "
    let l = line('.')
    let text = [
        \ "",
        \ indent."public function set".uvar."($".cvar.")",
        \ indent."{",
        \ indent.indent."$this->".var." = $".cvar.";",
        \ "",
        \ indent.indent."return $this;",
        \ indent."}",
    \ ]
    call append(searchpair('{', '', '}', 'Wnr')-1, text)
endfunction
" }}}

" MakeClass {{{
function! MakeClass()
    let text = [
        \ '<?php',
        \ '',
        \ "class " . matchstr(@%, '\zs[a-zA-Z_]\+\ze\.'),
        \ "{",
        \ "}"]
    call append(0, text)
endfunction
" }}}

" MakeMethod {{{
function! MakeMethod(name)
    execute ':d'
    let indent = "    "
    let text = [
                \ indent . 'public function ' . a:name . '()',
                \ indent . '{',
                \ indent . '}',
                \ ]
    call append(line('.')-1, text)
endfunction
" }}}

" MakeTestMethod {{{
function! MakeTestMethod(name)
    execute ':d'
    let indent = "    "
    let class = matchstr(@%, '\zs[a-zA-Z_]\+\zeTest\.')
    let text = [
                \ indent . '/**',
                \ indent . ' * @test',
                \ indent . ' * @covers ' . class . '::' . a:name,
                \ indent . ' */',
                \ indent . 'public function ' . a:name . '()',
                \ indent . '{',
                \ indent . indent . '/** @var $object Testing' . class . ' */',
                \ indent . indent . '$object = $this->getObject();',
                \ indent . indent . '$this->fail("TODO");',
                \ indent . '}',
                \ ]
    call append(line('.')-1, text)
endfunction
" }}}

" OpenTagInNewTab {{{
function! OpenTagInNewTab(tag)
    let l:tag = substitute(a:tag, "/", "_", "g")
    execute "Te"
    execute "tjump ".l:tag
endfunction
" }}}

" OpenFileInNewTab {{{
function! OpenFileInNewTab(filepath)
    let l:filepath = substitute(a:filepath, "\r", "", "g")
    execute "Te"
    execute "e ".l:filepath
endfunction
" }}}

" SetProject {{{
function! SetProject()
    normal! c
    if filereadable('.project.vim')
        execute 'source .project.vim'
    endif
endfunction
" }}}

" BuildTags {{{
function! BuildTags()
    execute '!ctags -R --languages=PHP '.g:ctags_exclude.' -f tags *'
endfunction
" }}}

" VarDump {{{
function! VarDump(var, value, line)
    execute "!echo linia ".a:line.":    ".a:var." = ".a:value." >> /home/maciej/vim_var_dump.txt"
endfunction
" }}}

" UnderscoreToDash {{{
function! UnderscoreToDash(content)
    return substitute(a:content, "_", "-", "g")
endfunction
" }}}

" GetPHPDocumentation {{{
function! GetPHPDocumentation(name)
    execute "!firefox www.php.net/manual/en/function." . UnderscoreToDash(a:name) . ".php"
endfunction
" }}}

" FormatForIn formatuje listę np. numerów tak żeby pasowały do INa w zapytaniu {{{
function! FormatForIn()
    execute "g/^$/d"
    execute "%s/$/,/"
    execute "$s/,$//"
    normal! ggVGgq<CR><F5>
endfunction
" }}}

" RunUnitTests wykonuje testy jednostkowe {{{
function! RunUnitTests()
    execute '!phpunit --bootstrap=' . g:unit_test_bootstrap . ' test/phpunit/unit/'
endfunction
" }}}

" RunThisUnitTest wykonuje testy z aktualnego pliku {{{
function! RunThisUnitTest()
    if @% =~ 'Test\.php$'
        execute '!phpunit --bootstrap=' . g:unit_test_bootstrap . ' %'
    else
        call RunTestForThisClass()
    endif
endfunction
" }}}

" RunTestForThisClass {{{
function! RunTestForThisClass()
    let testClassName = matchstr(@%, '\zs[a-zA-Z_]\+\ze\.')
    let cmd = 'find . -name ' . testClassName . 'Test.php'
    let testFile = glob("`" . cmd . "`")
    if len(testFile) > 0
        execute '!phpunit --bootstrap=' . g:unit_test_bootstrap . ' ' . testFile
    else
        echo 'Nie znaleziono testów dla tego pliku'
    endif
endfunction
" }}}

" GrepOperator {{{
function! s:GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[v`]y"
    else
        return
    endif
    silent execute "grep! -R " . shellescape(@@) . " ."
    copen
    let @@ = saved_unnamed_register
endfunction
" }}}

" ColorLog {{{
function! ColorLog()
    let keyName = "[a-zA-Z\-_]\+"
    execute 'syn clear'
    execute 'syn match key0 "^[a-zA-Z0-9\-_]\+:"'
    execute 'syn match key1 "^  [a-zA-Z0-9\-_]\+:"'
    execute 'syn match key2 "^    [a-zA-Z0-9\-_]\+:"'
    execute 'syn match time "^.* === new call ===$"'
    execute 'syn match url  "http[s]\?:.*$"'
    execute 'hi key0 guifg=#DDA0DD'
    execute 'hi key1 guifg=#63B8FF'
    execute 'hi key2 guifg=#8DEEEE'
    execute 'hi time guifg=#FF8247'
    execute 'hi url  guifg=#9ACD32'
endfunction
" }}}"
