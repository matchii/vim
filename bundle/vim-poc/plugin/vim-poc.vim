""""""""""""""""""""""""""""""""""""""""""
""""" Menu
""""""""""""""""""""""""""""""""""""""""""

" Menu items {{{"
menu 100.300 PHP.MessDetector<Tab><Leader>md <Leader>md
" }}}

""""""""""""""""""""""""""""""""""""""""""
""""" Shortcuts
""""""""""""""""""""""""""""""""""""""""""

" Runs PHP Mess Detector on current file
" See http://phpmd.org
noremap <Leader>md :call RunMessDetection()<CR>

""""""""""""""""""""""""""""""""""""""""""
""""" Functions
""""""""""""""""""""""""""""""""""""""""""

" RunMessDetection {{{
function! RunMessDetection()
    let l:file = 'mess_in_' . expand('%:t')
    execute 'redir! > /tmp/' . l:file
    execute 'silent !phpmd ' . @% . ' text design,unusedcode | sed s/^.*:// -'
    execute 'redir END'
    execute 'split'
    " Hint: To open new buffer next to, instead of 'split' use 'Te'
    execute 'e /tmp/' . l:file
    "TODO: Now I want to implement the functionality that clicking on the line
    "number in md report moves cursor in the file buffer to that line.
endfunction
" }}}

