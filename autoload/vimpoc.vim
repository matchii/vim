function! vimpoc#CompletePHP(findstart, base)

	if a:findstart " pierwsze wywołanie, szukamy początku ciągu, który będziemy uzupełniać

		if vimpoc#isBetweenTags() == 1 " jesteśmy wewnątrz tagów php
			return vimpoc#FindAndSetContext()
		else " nie jesteśmy wewnątrz tagów php
			return -1
		endif

	else " drugie wywołanie, szukamy listy uzupełnień

		" pliki tagów
		let g:fnames = join(map(tagfiles(), 'escape(v:val, " \\#%")'))
		if g:fnames == ''
			return []
		endif
		if !exists('b:defaultClass')
			let b:defaultClass = ''
		endif
		let b:base = a:base
        let b:className = ''

		if b:lineContext =~ '::[a-zA-Z_0-9]*$'
			" kontekst statyczny, jesteśmy prawie pewni, że ustalimy nazwę klasy
			" zmienna b:className nie musi być b:, to tylko w celach diagnostycznych
			if b:lineContext =~ '\<self::[a-zA-Z_0-9]*$' " szukamy w tej klasie i jej rodzicach
				let b:className = vimpoc#GetClassNameFromFileContext()
				" let b:i_className = 'if'
			elseif b:lineContext =~ '\<parent::[a-zA-Z_0-9]*$'
				let b:className = vimpoc#GetParentClass(vimpoc#GetClassNameFromFileContext())
				" let b:i_className = 'elseif'
			else
				let b:className = vimpoc#GetClassNameFromLineContext(b:lineContext)
				" let b:i_className = 'else'
			endif
			let b:location = vimpoc#GetClassLocation(b:className)
			if b:location == '' " brak klasy w tagach, TODO wyświetlić komunikat
				return []
			endif
			call vimpoc#SetClassInheritanceTree(b:className)
			let b:static_methods = vimpoc#GetClassMethods(b:className, 'static')
			let b:constants = vimpoc#GetClassConstants(b:className)
			return b:static_methods+b:constants
		endif

		if b:lineContext =~ '->[a-zA-Z_0-9]*$'
			let b:var = matchstr(b:lineContext, '\$\zs[a-zA-Z_0-9]\+\ze->[a-zA-Z_0-9]*$')
            call vimpoc#Debug('zmienna: ' . b:var)
			if b:var == 'this'
				let b:className = vimpoc#GetClassNameFromFileContext()
				let b:defaultClass = ''
            endif
			if b:var != 'this' && b:var != ''
				let b:className = vimpoc#GetClassNameFromObject(b:var)
                if b:className != ''
                    let b:defaultClass = ''
                endif
            endif
			if b:className == ''
				let b:className = vimpoc#GetClassNameFromHint(b:var)
                if b:className != ''
                    let b:defaultClass = ''
                endif
			endif
			if b:className == ''
				if b:defaultClass != ''
					let b:className = b:defaultClass
				endif
			endif
			call vimpoc#SetClassInheritanceTree(b:className)
			let b:methods = vimpoc#GetClassMethods(b:className, 'all')
			let b:fields = vimpoc#GetClassFields(b:className, 'all')
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
						let classes += [{'word':item, 'kind': 'c'}]
					endfor
				endif
			return classes + vimpoc#GetBuiltInFunctions(a:base)
"		endif

	endif

endfunction

function! vimpoc#FindAndSetContext()
	"b:lineContext - wszystko przed kursorem
	let b:lineContext = getline('.')[0:col(".")-2]
	if match(b:lineContext, '\(::\|->\)$') != -1
		let b:startOfCompl = col(".")
		"let b:iii = 'if'
	else
		let tmp = searchpos('\<', 'bn', line(".")) " położenie początku wyrazu
		let b:startOfCompl = tmp[1] - 1
		"let b:iii = 'else'
	endif
    let b:funcLine = search('\<function\>\s\+[a-zA-Z_0-9]\+(', 'bn')
    if b:funcLine > 0
        let b:rev_func_context = getline(b:funcLine, '.')
    else
        let b:rev_func_context = []
    endif
	return b:startOfCompl
endfunction

" zwraca 1 jeśli aktualna pozycja kursora jest pomiędzy tagami php, 0 w innym wypadku
function! vimpoc#isBetweenTags()
	let phpbegin = searchpairpos('<?php', '', '?>', 'bWn',
			\ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\|comment"')
	let phpend   = searchpairpos('<?php', '', '?>', 'Wn',
			\ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string\|comment"')
	if phpbegin == [0,0] && phpend == [0,0] " nie jesteśmy
		return 0
	endif
	return 1
endfunction

" zwraca nazwę klasy w aktualnym pliku
function! vimpoc#GetClassNameFromFileContext()
	return matchstr(getline(search('^\(abstract\)\?\s*class\s', 'bnW')), 'class\s*\zs[a-zA-Z0-9_]*\ze')
endfunction

" zwraca nazwę klasy w aktualnej linii
function! vimpoc#GetClassNameFromLineContext(lineContext)
	return matchstr(a:lineContext, '\zs[a-zA-Z_0-9\x7f-\xff]\+\ze::[a-zA-Z_0-9]*$')
endfunction

" zwraca ścieżkę do klasy, pobraną z pliku tagów
function! vimpoc#GetClassLocation(class)
	let g:cotozaklasa = a:class
	call setqflist([])
	for fname in tagfiles()
		let g:patt = 'silent! vimgrep /^'.a:class.'.*\tc\(\t\|$\)/j '.fname
		let g:qf_before = deepcopy(getqflist())
		execute g:patt
		let g:qf_after = deepcopy(getqflist())
		let g:qf_after2 = deepcopy(getqflist())
		let qflist = deepcopy(getqflist())
		if len(qflist) > 0
			let classLocation = matchstr(qflist[0]['text'], '\t\zs\f\+\ze\t')
		else
			let classLocation = ''
		endif
		return classLocation
	endfor
endfunction

" zwraca nazwę klasy kryjącej się za zmienną na której wywołujemy metodę
function! vimpoc#GetClassNameFromObject(var)

	let class = ''
	if a:var != ''
		" szukamy przypisania wartości tej zmiennej
		let b:tmp = matchstr(b:rev_func_context, a:var.'\s*=\s*new\s\+[a-zA-Z_0-9]*')
		let class = matchstr(b:tmp, 'new\s\+\zs[a-zA-Z_0-9]*\ze')
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
    return ''
endfunction

" zwraca nazwę klasy z podpowiedzi w formie @var $zmienna Klasa w linii
" powyżej lub w kontekście klasy
function! vimpoc#GetClassNameFromHint(var)

    if a:var == ''
        return ''
    endif

    if line('.') == 1
        return ''
    endif

    let class = ''
    " jeśli istnieje kontekst funkcji, to go przeszukujemy
    if b:rev_func_context != []
        let b:tmp = matchstr(b:rev_func_context, '@var\s\+\$'.a:var.'\s\+[a-zA-Z_0-9]*')
        let class = matchstr(b:tmp, '\$[a-zA-Z_0-9]*\s\+\zs[a-zA-Z_0-9]*\ze')
        if class != ''
            return class
        endif
        return ''
    endif

    let b:rev_file_context = getline(1, '.')
    let b:tmp = matchstr(b:rev_file_context, '@var\s\+\$'.a:var.'\s\+[a-zA-Z_0-9]*')
    let class = matchstr(b:tmp, '\s\+\zs[a-zA-Z_0-9]*\ze\s\+')

    if class != ''
        return class
    endif
    return ''
endfunction

function! vimpoc#SetClassInheritanceTree(className)
	let b:classList = [a:className]
	let b:classList += vimpoc#GetParentClassList(a:className)
endfunction

" zwraca tablicę metod klasy, wyekstrachowaną z pliku tagów
function! vimpoc#GetClassMethods(className, type)
    let methods = []
    if a:className == ''
        return methods
    endif
    for class in b:classList
        let g:type = a:type
        let class_location = escape(vimpoc#GetClassLocation(class), " ./")
        if class_location == ''
            continue
        endif

        " zwykłe metody
        let pattern = vimpoc#GetSearchPattern(a:className, class, class_location, a:type, 'f')
        exe pattern
        let qflist = getqflist()
        if len(qflist) > 0
            for field in qflist
                " File name
                let item = matchstr(field['text'], '^[^[:space:]]\+')
                let prototype = matchstr(field['text'], '\/\^\s*\zs.*)\ze')
                let classFile = matchstr(field['text'], '\/\zs\w*\ze\.php')
                let methods += [{'word':item, 'kind':'f', 'menu':classFile, 'info':prototype }]
            endfor
        endif

        " metody wprowadzone poprzez znacznik @method
        let tm_pattern = 'silent! vimgrep /^'.b:base.'.*\t'.class_location.'.*@method\>/j ' . g:fnames
        exe tm_pattern
        let tm_qflist = getqflist()
        if len(tm_qflist) > 0
            for field in tm_qflist
                " File name
                let item = matchstr(field['text'], '^[^[:space:]]\+')
                let prototype = matchstr(field['text'], '\/\^\s*\zs.*\ze\$\/')
                let classFile = matchstr(field['text'], '\/\zs\w*\ze\.php')
                let methods += [{'word':item, 'kind':'f', 'menu':classFile, 'info':prototype }]
            endfor
        endif
    endfor
    return methods
endfunction

function! vimpoc#GetSearchPattern(className, class, class_location, type, resourceType)
    if a:type == 'all'
        let static = ''
        if b:var == 'this'
            if a:className == a:class
                let access = '.*\(public\|protected\|private\)'
            else
                let access = '.*\(public\|protected\)'
            endif
        else
            let access = '.*\(public\)'
        endif
    elseif a:type == 'static'
        let static = '.*static'
        " FIXME podpowiadamy wszystkie metody statycznie, niezależnie od
        " widoczności
        let access = '.*\(public\|protected\|private\)'
    endif
    let pattern = 'silent! vimgrep /^'.b:base.'.*\t'.a:class_location.access.static.'.*\t'.a:resourceType.'/j '.g:fnames
    return pattern
endfunction

" zwraca tablicę pól klasy, wyekstrachowaną z pliku tagów
function! vimpoc#GetClassFields(className, type)
	let fields = []
    if a:className == ''
        return fields
    endif
	for class in b:classList
		let class_location = escape(vimpoc#GetClassLocation(class), " ./")
        if class_location == ''
            continue
        endif
		let g:type = a:type

        let pattern = vimpoc#GetSearchPattern(a:className, class, class_location, a:type, 'p')

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
function! vimpoc#GetClassConstants(className)
	let constants = []
    if a:className == ''
        return constants
    endif
	for class in b:classList
		let class_location = escape(vimpoc#GetClassLocation(class), " ./")
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

function! vimpoc#GetParentClassList(className)
	let b:parentClasses = []
    if a:className == ''
        return b:parentClasses
    endif
	let return_class = a:className
	while return_class != ''
		let return_class = vimpoc#GetParentClass(return_class)
		if return_class != ''
			call add(b:parentClasses, return_class)
		endif
	endwhile
	return b:parentClasses
endfunction

function! vimpoc#GetParentClass(class)
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

function! vimpoc#IsClassKnown(class)
    exe 'silent! vimgrep /^\s*class\s\+'.a:class.'\>'.g:fnames
    let b:known_qflist = getqflist()
    if len(b:known_qflist) > 0
        return 1
    else
        return 0
    endif
endfunction

function! vimpoc#GetBuiltInFunctions(prefix)
    return values(filter(copy(g:funcs), 'v:key =~ "^'.a:prefix.'"'))
endfunction

function! vimpoc#Debug(text)
    echom 'vimpoc: ' . a:text
endfunction

source ~/.vim/autoload/funcs.vim
