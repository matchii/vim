function! pcomplete#CompletePHP(findstart, base)

	if a:findstart == 1 " pierwsze wywołanie, szukamy początku ciągu, który będziemy uzupełniać

		" czy jesteśmy wewnątrz tagów php
		let phpbegin = searchpairpos('<?', '', '?>', 'bWn',
				\ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\|comment"')
		let phpend   = searchpairpos('<?', '', '?>', 'Wn',
				\ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\|comment"')
		if phpbegin == [0,0] && phpend == [0,0] " nie jesteśmy
			return []
		else " jesteśmy
			let line = getline('.')
			let start = col('.') - 1
			let curline = line('.')
			let compl_begin = col('.') - 2
			while start >= 0 && line[start - 1] =~ '[a-zA-Z_0-9\x7f-\xff$]' "cofamy się do poprzedniego białego znaku
				let start -= 1
			endwhile
			let b:line_context = getline('.')[0:compl_begin]
				"b:line_context - wszystko przed kursorem, potrzebne do
				"ustalania, co próbujemy uzupełnić
			return start
		endif
	elseif a:findstart == 0 " drugie wywołanie, szukamy listy uzupełnień

		" linie od pierwszej do aktualnej (włącznie)
		let b:file_context = getline(1, line('.'))
		let tmp = copy(b:file_context)
		let b:rev_file_context = reverse(tmp)
		let tmp2 = match(b:rev_file_context, '.*function.*')
		let rfc_copy = copy(b:rev_file_context)
		let b:rev_func_context = remove(rfc_copy, 0, tmp2)
		" pliki tagów
		let g:fnames = join(map(tagfiles(), 'escape(v:val, " \\#%")'))
		let b:base = a:base

		if b:line_context =~ '::[a-zA-Z_0-9]*$'
			if b:line_context =~ 'self::[a-zA-Z_0-9]*$' " szukamy w tej klasie (TODO: i jej rodzicach)
				let class = pcomplete#GetClassNameFromFileContext()
			else
				let class = pcomplete#GetClassNameFromLineContext(b:line_context)
			endif
			let g:deb1 = class
			let static_methods = pcomplete#GetClassMethods(class, 'static')
			let constants = pcomplete#GetClassConstants(class)
			return static_methods+constants
		endif

		if b:line_context =~ '->[a-zA-Z_0-9]*$'
			let line = matchstr(b:rev_file_context, '^\s*\$\zs[a-zA-Z_0-9]\+\ze')
			let var = matchstr(line, '\$\zs[a-zA-Z_0-9]\+\ze')
			if var == 'this'
				let class = pcomplete#GetClassNameFromFileContext()
			else
				let class = pcomplete#GetClassNameFromObject(var)
			endif
			let methods = pcomplete#GetClassMethods(class, 'all')
			return methods
		endif

"		if b:line_context =~ '\(new\|extends\)\s\+[a-zA-Z_0-9]*$' ||
"					\ b:line_context =~ 'function\s\+[a-zA-Z_0-9]\+\s*(.*$' " TODO: nazwa pliku z klasą
			let classes = []
			if g:fnames != ''
				exe 'silent! vimgrep /^'.a:base.'.*\tc\(\t\|$\)/j '.g:fnames
				let qflist = getqflist()
				if len(qflist) > 0
					for field in qflist
						let item = matchstr(field['text'], '^[^[:space:]]\+')
						"let file = matchstr(field['text'], '^[a-zA-Z_0-9]\+\t\zs.\{-}\ze\t')
						"let prototype = matchstr(field['text'],
						"		\ 'function\s\+&\?[^[:space:]]\+\s*(\s*\zs.\{-}\ze\s*)\s*{\?')
						let classes += [{'word':item, 'kind':'c'}]
					endfor
				endif
			endif
			return classes
"		endif

"		let g:empty_list = ['x','y','z']
"		return g:empty_list

	endif

endfunction

" zwraca ścieżkę do klasy, pobraną z pliku tagów
function! pcomplete#GetClassLocation(class)
	for fname in tagfiles()
		exe 'silent! vimgrep /^'.a:class.'.*\tc\(\t\|$\)/j '.fname
		let qflist = getqflist()
		if len(qflist) > 0
			let class_location = matchstr(qflist[0]['text'], '\t\zs\f\+\ze\t')
		else
			return ''
		endif
		return class_location
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

" zwraca nazwę klasy zdefiniowanej w aktualnym pliku
function! pcomplete#GetClassNameFromFileContext()
	let class = ''
	exe 'silent! vimgrep /^\s*class\s\+/j %'
	let qflist = getqflist()
	if len(qflist) > 0
		for field in qflist
			let class = matchstr(field['text'], '^\s*class\s\+\zs[a-zA-Z_0-9]*\ze')
		endfor
	endif
	return class
endfunction

" zwraca nazwę klasy w aktualnej linii
function! pcomplete#GetClassNameFromLineContext(context)
	let class = matchstr(a:context, '\zs[a-zA-Z_0-9\x7f-\xff]\+\ze::[a-zA-Z_0-9]*$')
	return class
endfunction

" zwraca tablicę metod klasy, wyekstrachowaną z pliku tagów
function! pcomplete#GetClassMethods(class, type)
	let class_list = [a:class]
	let class_list += pcomplete#GetParentClassList(a:class)
	let methods = []
	for class in class_list
		let class_location = escape(pcomplete#GetClassLocation(class), " ./")
		if a:type == 'all'
			let pattern = 'silent! vimgrep /^'.b:base.'[a-zA-Z_0-9]*\t'.class_location.'.*\tf/j '.g:fnames
		elseif a:type == 'static'
			let pattern = 'silent! vimgrep /^'.b:base.'[a-zA-Z_0-9]*\t'.class_location.'.*static.*\tf/j '.g:fnames
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
					let methods += [{'word':item, 'kind':'f', 'info':prototype }]
				endfor
			endif
		endif
	endfor
	return methods
endfunction

" zwraca tablicę stałych klasy, wyekstrachowaną z pliku tagów
function! pcomplete#GetClassConstants(class)
	let class_location = escape(pcomplete#GetClassLocation(a:class), " ./")
	let constants = []
	if g:fnames != ''
		exe 'silent! vimgrep /^'.b:base.'[a-zA-Z_0-9]*\t'.class_location.'.*\tn/j '.g:fnames
		let qflist = getqflist()
		if len(qflist) > 0
			for field in qflist
				" File name
				let item = matchstr(field['text'], '^[^[:space:]]\+')
				let fname = matchstr(field['text'], '\t\zs\f\+\ze')
				let prototype = matchstr(field['text'], '\zsconst.*\ze\;\$\/')
				let constants += [{'word':item, 'kind':'n', 'info':prototype }]
			endfor
		endif
	endif
	return constants
endfunction

function! pcomplete#GetParentClassList(class)
	let class_list = []
	let return_class = a:class
	while return_class != ''
		let return_class = pcomplete#GetParentClass(return_class)
		call add(class_list, return_class)
	endwhile
	return class_list
endfunction

function! pcomplete#GetParentClass(class)
	let class = ''
	if a:class != ''
		exe 'silent! vimgrep /^'.a:class.'\t.*extends\s\+[a-zA-Z_0-9]\+\$/j '.g:fnames
		let qflist = getqflist()
		if len(qflist) > 0
			for field in qflist
				let class = matchstr(field['text'], 'extends\s\+\zs[a-zA-Z_0-9]\+\ze')
			endfor
		endif
	endif
	return class
endfunction
