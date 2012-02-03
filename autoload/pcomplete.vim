function! pcomplete#CompletePHP(findstart, base)

	if a:findstart == 1 " pierwsze wywołanie, szukamy początku ciągu, który będziemy uzupełniać

		if pcomplete#isBetweenTags() == 1 " jesteśmy wewnątrz tagów php
			"b:lineContext - wszystko przed kursorem
			let b:lineContext = getline('.')[0:col(".")]
			if match(b:lineContext, '\(::\|->\)$') != -1
				let b:startOfCompl = col(".")
				"let b:iii = 'if'
			else
				let tmp = searchpos('\<', 'bn', line(".")) " położenie początku wyrazu
				let b:startOfCompl = tmp[1] - 1
				"let b:iii = 'else'
			endif
			return b:startOfCompl
		else " nie jesteśmy wewnątrz tagów php
			return -1
		endif

	elseif a:findstart == 0 " drugie wywołanie, szukamy listy uzupełnień

		" pliki tagów
		let g:fnames = join(map(tagfiles(), 'escape(v:val, " \\#%")'))
		if g:fnames == ''
			return []
		endif
		let b:base = a:base

		if b:lineContext =~ '::[a-zA-Z_0-9]*$'
			if b:lineContext =~ 'self::[a-zA-Z_0-9]*$' " szukamy w tej klasie i jej rodzicach
				let b:thisClassName = pcomplete#GetClassNameFromFileContext()
				" let b:i_className = 'if'
			elseif b:lineContext =~ 'parent::[a-zA-Z_0-9]*$'
				let b:thisClassName = pcomplete#GetParentClass(pcomplete#GetClassNameFromFileContext())
				" let b:i_className = 'elseif'
			else
				let b:thisClassName = pcomplete#GetClassNameFromLineContext()
				" let b:i_className = 'else'
			endif
			let b:location = pcomplete#GetClassLocation(b:thisClassName)
			if b:location == ''
				return []
			endif
			call pcomplete#SetClassesData(b:thisClassName)
			let b:static_methods = pcomplete#GetClassMethods(b:thisClassName, 'static')
			let b:constants = pcomplete#GetClassConstants(b:thisClassName)
			return b:static_methods+b:constants
		endif

		if b:lineContext =~ '->[a-zA-Z_0-9]*$'
			let b:var = matchstr(b:lineContext, '\$\zs[a-zA-Z_0-9]\+\ze')
			if b:var == 'this'
				let b:thisClassName = pcomplete#GetClassNameFromFileContext()
			else
				if b:defaultClass != ''
					let b:thisClassName = b:defaultClass
				endif
"				let class = pcomplete#GetClassNameFromObject(var)
			endif
			call pcomplete#SetClassesData(b:thisClassName)
			let b:methods = pcomplete#GetClassMethods(b:thisClassName, 'all')
			let b:fields = pcomplete#GetClassFields(b:thisClassName, 'all')
			return b:methods+b:fields
		endif

" na razie rezygnujemy z podpowiadania funkcji języka, więc podpowiadamy nazwę
" klasy w każdym przypadku
"		if b:lineContext =~ '\(new\|extends\)\s\+[a-zA-Z_0-9]*$' ||
"					\ b:lineContext =~ 'function\s\+[a-zA-Z_0-9]\+\s*(.*$' " TODO: nazwa pliku z klasą
			let classes = []
			exe 'silent! vimgrep /^'.a:base.'.*\tc\(\t\|$\)/j '.g:fnames
				let qflist = getqflist()
				if len(qflist) > 0
					for field in qflist
						let item = matchstr(field['text'], '^[^[:space:]]\+')
						let classes += [{'word':item, 'kind':'c'}]
					endfor
				endif
			return classes
"		endif

	endif

endfunction

" zwraca 1 jeśli aktualna pozycja kursora jest pomiędzy tagami php, 0 w innym
" wypadku
function! pcomplete#isBetweenTags()
	let phpbegin = searchpairpos('<?', '', '?>', 'bWn',
			\ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\|comment"')
	let phpend   = searchpairpos('<?', '', '?>', 'Wn',
			\ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\|comment"')
	if phpbegin == [0,0] && phpend == [0,0] " nie jesteśmy
		return 0
	endif
	return 1
endfunction

" zwraca nazwę klasy w aktualnym pliku
function! pcomplete#GetClassNameFromFileContext()
	return matchstr(getline(search('^\(abstract\)\?\s*class\s', 'bnW')), 'class\s*\zs[a-zA-Z0-9_]*\ze')
endfunction

" zwraca nazwę klasy w aktualnej linii
function! pcomplete#GetClassNameFromLineContext()
	return matchstr(b:lineContext, '\zs[a-zA-Z_0-9\x7f-\xff]\+\ze::[a-zA-Z_0-9]*$')
endfunction

" zwraca ścieżkę do klasy, pobraną z pliku tagów
function! pcomplete#GetClassLocation(class)
	for fname in tagfiles()
		exe 'silent! vimgrep /^'.a:class.'.*\tc\(\t\|$\)/j '.fname
		let qflist = getqflist()
		if len(qflist) > 0
			let classLocation = matchstr(qflist[0]['text'], '\t\zs\f\+\ze\t')
		else
			return ''
		endif
		return classLocation
	endfor
endfunction

" zwraca nazwę klasy kryjącej się za zmienną na której wywołujemy metodę
function! pcomplete#GetClassNameFromObject(var)
	let class = ''
	if a:var != ''
		" szukamy przypisania wartości tej zmiennej
		let tmp = matchstr(b:rev_func_context, a:var.'\s*=\s*new\s\+[a-zA-Z_0-9]*')
		let class = matchstr(tmp, 'new\s\+\zs[a-zA-Z_0-9]*\ze')
	endif
	if class != ''
		return class
	else
		let tmp = matchstr(b:rev_func_context, '.*function.*'.a:var)
		let class = matchstr(tmp, '\zs[a-zA-Z_0-9]*\ze\s\+\$'.a:var)
	endif
	if class != ''
		return class
	endif
endfunction

function! pcomplete#SetClassesData(className)
	let b:classList = [a:className]
	let b:classList += pcomplete#GetParentClassList(a:className)
endfunction

" zwraca tablicę metod klasy, wyekstrachowaną z pliku tagów
function! pcomplete#GetClassMethods(className, type)
	let methods = []
	for class in b:classList
		let class_location = escape(pcomplete#GetClassLocation(class), " ./")
		let g:type = a:type
		if a:type == 'all'
			let pattern = 'silent! vimgrep /^'.b:base.'.*\t'.class_location.'.*\tf/j '.g:fnames
		elseif a:type == 'static'
			let pattern = 'silent! vimgrep /^'.b:base.'.*\t'.class_location.'.*static.*\tf/j '.g:fnames
		endif
		if g:fnames != ''
			exe pattern
			let qflist = getqflist()
			if len(qflist) > 0
				for field in qflist
					" File name
					let item = matchstr(field['text'], '^[^[:space:]]\+')
					let fname = matchstr(field['text'], '\t\zs\f\+\ze')
					let prototype = matchstr(field['text'], '\/\^\s*\zs.*)\ze')
					let classFile = matchstr(field['text'], '\/\zs\w*\ze\.php')
					let methods += [{'word':item, 'kind':'f', 'menu':classFile, 'info':prototype }]
				endfor
			endif
		endif
	endfor
	return methods
endfunction

" zwraca tablicę pól klasy, wyekstrachowaną z pliku tagów
function! pcomplete#GetClassFields(className, type)
	let fields = []
	for class in b:classList
		let class_location = escape(pcomplete#GetClassLocation(class), " ./")
		let g:type = a:type
		if a:type == 'all'
			let pattern = 'silent! vimgrep /^'.b:base.'.*\t'.class_location.'.*\tp/j '.g:fnames
		elseif a:type == 'static'
			let pattern = 'silent! vimgrep /^'.b:base.'.*\t'.class_location.'.*static.*\tp/j '.g:fnames
		endif
		if g:fnames != ''
			exe pattern
			let qflist = getqflist()
			if len(qflist) > 0
				for field in qflist
					" File name
					let item = matchstr(field['text'], '^[^[:space:]]\+')
					let fname = matchstr(field['text'], '\t\zs\f\+\ze')
					let prototype = matchstr(field['text'], '\/\^\s*\zs.*;\ze\$')
					let classFile = matchstr(field['text'], '\/\zs\w*\ze\.php')
					let fields += [{'word':item, 'kind':'p', 'menu':classFile, 'info':prototype }]
				endfor
			endif
		endif
	endfor
	return fields
endfunction

" zwraca tablicę stałych klasy, wyekstrachowaną z pliku tagów
function! pcomplete#GetClassConstants(className)
	let constants = []
	for class in b:classList
		let class_location = escape(pcomplete#GetClassLocation(a:className), " ./")
		if g:fnames != ''
			exe 'silent! vimgrep /^'.b:base.'.*\t'.class_location.'.*\tn/j '.g:fnames
			let qflist = getqflist()
				let g:qflist = qflist
			if len(qflist) > 0
				for field in qflist
					" File name
					let item = matchstr(field['text'], '^[^[:space:]]\+')
					let fname = matchstr(field['text'], '\t\zs\f\+\ze')
					let prototype = matchstr(field['text'], '\zsconst.*\ze\;\$\/')
					let classFile = matchstr(field['text'], '\/\zs\w*\ze\.class\.php')
					let constants += [{'word':item, 'kind':'n', 'menu':classFile, 'info':prototype }]
				endfor
			endif
		endif
	endfor
	return constants
endfunction

function! pcomplete#GetParentClassList(className)
	let b:parentClasses = []
	let return_class = a:className
	while return_class != ''
		let return_class = pcomplete#GetParentClass(return_class)
		if return_class != ''
			call add(b:parentClasses, return_class)
		endif
	endwhile
	return b:parentClasses
endfunction

function! pcomplete#GetParentClass(class)
	let parentClass = ''
	if a:class != ''
		exe 'silent! vimgrep /^'.a:class.'\t.*\s\+extends\s\+[a-zA-Z_0-9]\+.*/j '.g:fnames
		let b:parent_qflist = getqflist()
		if len(b:parent_qflist) > 0
			for field in b:parent_qflist
				let parentClass = matchstr(field['text'], 'extends\s\+\zs[a-zA-Z_0-9]\+\ze')
			endfor
		endif
	endif
	return parentClass
endfunction
