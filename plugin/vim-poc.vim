""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" MENU
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Menu items {{{"
noremenu 100.150 PHP.Break\ Array<Tab><Leader>ba      :call BreakArray(line('.'))<CR>
noremenu 100.170 PHP.Break\ Params<Tab><Leader>bp     :call BreakParams(line('.'))<CR>
noremenu 100.150 PHP.Break\ Arrows<Tab><Leader>br     :call BreakArrows(line('.'))<CR>
noremenu 100.180 PHP.Enrow\ Arrows<Tab><Leader>ea     :call EnrowArrows(line("'<"), line("'>"))<CR>
nnoremenu 100.600 PHP.Toggle NERDTree<leader>nt      :NERDTreeToggle<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" SHORTCUTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" List of shortcuts {{{
" Toggle NERDTree window
" nnoremap <C-F2> :NERDTreeToggle<CR>
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
