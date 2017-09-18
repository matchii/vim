""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" MENU
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Menu items {{{"
noremenu 100.130 PHP.Extract\ Code<Tab><Leader>ext    :call ExtractToNewFunction(line("."), line("'>"))<CR>
noremenu 100.150 PHP.Break\ Array<Tab><Leader>ba      :call BreakArray(line('.'))<CR>
noremenu 100.170 PHP.Break\ Params<Tab><Leader>bp     :call BreakParams(line('.'))<CR>
noremenu 100.180 PHP.Enrow\ Arrows<Tab><Leader>ea     :call EnrowArrows(line("'<"), line("'>"))<CR>
noremenu 100.300 PHP.Mess\ Detector<Tab><Leader>md    :call RunMessDetection()<CR>
noremenu 100.400 PHP.Code\ Sniffer<Tab><Leader>mf     :call RunCodeSniff()<CR>
noremenu 100.500 PHP.Code\ Duplication<Tab><Leader>mp :call RunCopyPasteDetection()<CR>
nnoremenu 100.600 PHP.Find\ occurences<Tab><Leader>ff :call FindOccurences(expand('<cword>'))<CR>
vnoremenu 100.650 PHP.Find\ occurences<Tab><Leader>ff :call FindOccurences(getline(".")[col("'<")-1:col("'>")-1])<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" SHORTCUTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" List of shortcuts {{{
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
" Creates foreach block
noremap  <Leader>fe :call SetForeachBlock(line('.'), line('.'))<CR>k0f(a
vnoremap  <Leader>fe :<C-U>call SetForeachBlock(line("."), line("'>"))<CR>k0f(a
" Extracts selected code to new method
vnoremap  <Leader>ext :<C-U>call ExtractToNewFunction(line("."), line("'>"))<CR>
" Breaks array defined in one line
nnoremap <Leader>ba :call BreakArray(line('.'))<CR>
" Breaks function parameters defined in one line
nnoremap <Leader>bp :call BreakParams(line('.'))<CR>
" Aligns double arrows (=>) in selected lines
vnoremap <Leader>ea :call EnrowArrows(line("'<"), line("'>"))<CR>
" }}}

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
    execute 'silent! %s/:\s\+/:/'
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

" SetForeachBlock obejmuje fragment pomiędzy liniami blokiem if i zwiększa wcięcie o 1 poziom {{{
function! SetForeachBlock(first_line, last_line)
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
    call append(prev_line, indent."foreach () {")
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

" ExtractToNewFunction {{{
" Wycina kod pomiędzy podanymi liniami (włącznie) i umieszcza go w nowej
" funkcji
" TODO zmienne stworzone przed wyciętym kodem powinny być parametrami nowej
" metody
function! ExtractToNewFunction(first_line, last_line)
    if a:first_line > a:last_line
        return
    endif
    let diff = a:last_line - a:first_line
    " wcięcie pierwszego wiersza przenoszonego tekstu
    let old_indent = matchstr(getline(a:first_line), '^\zs\s*\ze')
    " pozwalamy użytkownikowi podać nową nazwę
    call inputsave()
    let inputMethodName = input('Method name: ')
    call inputrestore()
    " jeśli nie podał, generujemy automatycznie
    if inputMethodName != ''
        let methodName = inputMethodName
    else
        let methodName = 'rows_from_'.a:first_line.'_to_'.a:last_line
    endif
    " ustawiamy wcięcie na szerokość dwóch tabulatorów
    let cur_line_number = a:first_line
    for line in getline(a:first_line, a:last_line)
        call setline(cur_line_number, substitute(line, "^".old_indent, "        ", ''))
        let cur_line_number = cur_line_number + 1
    endfor
    " wycinamy linie...
    execute "silent! normal ".a:first_line."Gd".l:diff."j"
    " ... i zastępujemy je wywołaniem nowej metody
    call append(a:first_line-1, old_indent.'$this->'.methodName.'();')

    " wstawiamy deklarację metody...
    let indent = "    "
    let text = [
                \ '',
                \ indent . 'private function '.methodName.'()',
                \ indent . '{',
                \ indent . '}',
                \ ]
    call append(search('^    }$'), text)
    " ... i wklejamy tekst do jej wnętrza
    execute "silent! normal 3jp2k0f(b"
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
        \ '/**',
        \ ' * TODO Write here a few words about what this class is supposed to do.',
        \ ' */',
        \ "class " . matchstr(@%, '\zs[a-zA-Z_]\+\ze\.'),
        \ "{",
        \ "}"]
    call append(0, text)
    execute ':$d'
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

" JumpToOccurence {{{
function! JumpToOccurence(line)
    let l:path = a:line[0:searchpos(":")[1]-2]
    let l:number = a:line[len(l:path)+1:searchpos(":", 'n')[1]-2]
    let l:filepath = substitute(l:path, "\r", "", "g")
    execute "Te"
    execute "e ".l:filepath
    execute "silent! normal ".l:number."Gzozz"
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

" BreakArray(line_number) {{{
function! BreakArray(line_number)
    let this_line = getline(a:line_number)
    let indent = matchstr(this_line, '^\zs\s*\ze')
    let new_indent = indent.'    '
    let inside = matchstr(this_line, '\[\zs.*\ze]')
    let tokens = split(inside, ',')
    execute "normal! 0f[lci[\n"
    for token in tokens
        call append(line('.')-1, new_indent.substitute(token, '^\s\+', '', '').',')
    endfor
endfunction
" }}}

" BreakParams(line_number) {{{
function! BreakParams(line_number)
    let this_line = getline(a:line_number)
    let indent = matchstr(this_line, '^\zs\s*\ze')
    let new_indent = indent.'    '
    let inside = matchstr(this_line, '(\zs.*\ze)')
    let tokens = split(inside, ',')
    execute "normal! 0f(lci(\n"
    let idx = 1
    let tokens_count = len(tokens)
    for token in tokens
        let line_to_append = new_indent.substitute(token, '^\s\+', '', '')
        if idx == tokens_count
            let separator = ''
        else
            let separator = ','
        endif
        call append(line('.')-1, line_to_append.separator)
        let idx = idx + 1
    endfor
endfunction
" }}}

" EnrowArrows(from_line_no, to_line_no) {{{
function! EnrowArrows(from_line_no, to_line_no)
    let pattern = "="
    if a:from_line_no > a:to_line_no
        return
    endif
    let offsets = {}
    let cur_line_no = a:from_line_no
    while cur_line_no <= a:to_line_no
        let offsets[cur_line_no] = match(getline(cur_line_no), pattern)
        let cur_line_no += 1
    endwhile
    let longest = max(offsets)
    let cur_line_no = a:from_line_no
    while cur_line_no <= a:to_line_no
        let diff = longest - offsets[cur_line_no]
        call setline(cur_line_no, substitute(getline(cur_line_no), pattern, repeat(" ", diff).pattern, ''))
        let cur_line_no += 1
    endwhile
endfunction
" }}}
