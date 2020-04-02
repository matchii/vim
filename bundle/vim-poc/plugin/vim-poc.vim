""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" MENU
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Menu items {{{"
noremenu 100.150 PHP.Break\ Array<Tab><Leader>ba      :call BreakArray(line('.'))<CR>
noremenu 100.170 PHP.Break\ Params<Tab><Leader>bp     :call BreakParams(line('.'))<CR>
noremenu 100.150 PHP.Break\ Arrows<Tab><Leader>br     :call BreakArrows(line('.'))<CR>
noremenu 100.180 PHP.Enrow\ Arrows<Tab><Leader>ea     :call EnrowArrows(line("'<"), line("'>"))<CR>
nnoremenu 100.600 PHP.Toggle NERDTree<Tab><F2>        :NERDTreeToggle<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" SHORTCUTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" List of shortcuts {{{
" Toggle NERDTree window
nnoremap <F2> :NERDTreeToggle<CR>
" Creates condition block
noremap  <Leader>ii :call SetIfBlock(line('.'), line('.'))<CR>k0f(a
vnoremap  <Leader>ii :<C-U>call SetIfBlock(line("."), line("'>"))<CR>k0f(a
" Creates foreach block
noremap  <Leader>fe :call SetForeachBlock(line('.'), line('.'))<CR>k0f(a
vnoremap  <Leader>fe :<C-U>call SetForeachBlock(line("."), line("'>"))<CR>k0f(a
" Breaks array defined in one line
nnoremap <Leader>ba :call BreakArray(line('.'))<CR>
" Breaks function parameters defined in one line
nnoremap <Leader>bp :call BreakParams(line('.'))<CR>
" Breaks chained method calls
nnoremap <Leader>br :call BreakArrows(line('.'))<CR>
" Aligns double arrows (=>) in selected lines
vnoremap <Leader>ea :call EnrowArrows(line("'<"), line("'>"))<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" SetProject {{{
function! SetProject()
    normal! c
    if filereadable('.project.vim')
        execute 'source .project.vim'
    endif
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
    let inside = matchstr(this_line, '(\zs[^)].\+\ze)')
    let tokens = split(inside, ',')
    let start = match(this_line, "([^)]")
    if l:start == -1
        echo "No params list found"
        return
    endif
    execute "normal! 0".start."llci(\n"
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

" BreakArrows(line_number) {{{
function! BreakArrows(line_number)
    let this_line = getline(a:line_number)
    let indent = matchstr(this_line, '^\zs\s*\ze')
    let new_indent = indent.'    '
    execute 'silent! s/->/\r'.l:new_indent.'->/g'
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
