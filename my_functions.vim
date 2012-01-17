" obejmuje fragment pomiędzy liniami blokiem if i zwiększa wcięcie o 1 poziom
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

" obejmuje fragment pomiędzy liniami blokiem try..catch i zwiększa wcięcie o 1 poziom
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

function! MakeSetterAndGetter(variable)
	let var = a:variable
	let cvar = toupper(var[0]).var[1:]
	let indent = "\t"
	let l = line('.')
	call append(l, indent."}")
	call append(l, indent."\treturn $this->getValue('".var."');")
	call append(l, indent."{")
	call append(l, indent."public function get".cvar."()")
	call append(l, indent)
	call append(l, indent."}")
	call append(l, indent."\treturn $this;")
	call append(l, indent."\t$this->setValue('".var."', $".var.");")
	call append(l, indent."{")
	call append(l, indent."public function set".cvar."($".var.")")
	call append(l, indent)
endfunction

function! OpenTagInNewTab(tag)
	execute "Te"
	execute "tag ".a:tag
endfunction

function! SetProject()
	execute '!ctags -R --languages=PHP -f tags *'
endfunction

function! VarDump(var, value, line)
	execute "!echo linia ".a:line.":	".a:var." = ".a:value." >> /home/maciej/vim_var_dump.txt"
endfunction

"function! FormatCode()
"	execute "%s/[\s\t]\+$//"
"	execute "%s/^\(\s*\)\t\(.*\)/\1    \2/g"
"	execute "nohlsearch"
"endfunction

function! UnderscoreToDash(content)
	return substitute(a:content, "_", "-", "g")
endfunction

function! GetPHPDocumentation(name)
	execute "!firefox www.php.net/manual/en/function." . UnderscoreToDash(a:name)
endfunction
