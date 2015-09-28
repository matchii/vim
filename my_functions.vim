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
	execute "Te"
	execute "tjump ".a:tag
endfunction
" }}}

" SetProject {{{
function! SetProject()
    if filereadable('.project.vim')
        execute 'source .project.vim'
    else
        let g:unit_test_bootstrap = 'test/bootstrap/unit.php'
        let g:ctags_exclude = '--exclude=vendor'
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
	execute "!echo linia ".a:line.":	".a:var." = ".a:value." >> /home/maciej/vim_var_dump.txt"
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

" RunMessDetection wykrywa bałagan w aktualnym pliku {{{
function! RunMessDetection()
    execute '!phpmd ' . @% . ' text design,unusedcode'
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
