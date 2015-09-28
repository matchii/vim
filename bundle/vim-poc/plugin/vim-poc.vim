""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" Menu
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Menu items {{{"
menu 100.300 PHP.Mess\ Detector<Tab><Leader>md  :call RunMessDetection()<CR>
menu 100.400 PHP.Code\ Sniffer                  :call RunCodeSniff()<CR>
menu 100.400 PHP.Code\ Duplication              :call RunDuplicationDetect()<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" Shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Runs PHP Mess Detector on current file
" See http://phpmd.org
noremap <Leader>md :call RunMessDetection()<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" RunMessDetection {{{
function! RunMessDetection()
    let l:file = 'mess_in_' . expand('%:t')
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
    let l:file = 'smell_in_' . expand('%:t')
    execute 'redir! > /tmp/' . l:file
    execute 'silent !phpcs --standard=PSR2 ' . @%
    execute 'redir END'
    execute 'split'
    execute 'e /tmp/' . l:file
endfunction
" }}}

" RunDuplicationDetect {{{
function! RunDuplicationDetect()
    let l:file = 'dupes_in_' . expand('%:t')
    execute 'redir! > /tmp/' . l:file
    execute 'silent !phpcpd ' . @%
    execute 'redir END'
    execute 'split'
    execute 'e /tmp/' . l:file
endfunction
" }}}

