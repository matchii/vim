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
	call MakeSetter(a:variable)
	call MakeGetter(a:variable)
endfunction

function! MakeGetter(variable)
	let var = a:variable
	let cvar = substitute(var, '^_', '', '')
	let cvar = toupper(cvar[0]).cvar[1:]
	let indent = "\t"
	let l = line('.')
	let text = [
		\ '',
		\ indent."public function get".cvar."()",
		\ indent."{",
		\ indent.indent."return $this->".var.";",
		\ indent."}",
	\ ]
	call append(line('$')-1, text)
endfunction

function! MakeSetter(variable)
	let var = a:variable
	let cvar = substitute(var, '^_', '', '')
	let uvar = toupper(cvar[0]).cvar[1:]
	let indent = "\t"
	let l = line('.')
	let text = [
		\ '',
		\ indent."public function set".uvar."($".cvar.")",
		\ indent."{",
		\ indent.indent."$this->".var." = $".cvar.";",
		\ indent.indent."return $this;",
		\ indent."}",
	\ ]
	call append(line('$')-1, text)
endfunction

function! OpenTagInNewTab(tag)
	execute "Te"
	execute "tjump ".a:tag
endfunction

function! SetProject()
	execute '!ctags -R --languages=PHP --exclude=lib/tag_links/symfony/lib/plugins -f tags *'
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

" formatuje listę np. numerów tak żeby pasowały do INa w zapytaniu
function! FormatForIn()
	execute "g/^$/d"
	execute "%s/$/,/"
	execute "$s/,$//"
	normal ggVGgq<CR><F5>
endfunction

function! Balonik()
	let g:context = getline(v:beval_lnum)
	if g:context =~ '\(::\|->\)[a-zA-Z_0-9]\+'
		let g:word = matchstr(g:context, '->\zs.*\ze(')
		redir => g:doc
		let g:command = '!grep -B 20 '. g:word . ' ' . expand('%:p')
		silent! execute g:command
		redir END
		let g:doc2 = g:doc
		let g:doc = substitute(g:doc[stridx(g:doc, '/**') : stridx(g:doc, '*/')+1], '\r', '', 'g')
		return g:doc
	endif
	return v:beval_lnum . ', ' . v:beval_col . ', ' . bufname(v:beval_bufnr)
endfunction
