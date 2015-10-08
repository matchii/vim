""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" MENU
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Menu items {{{"
noremenu 100.200 PHP.Check\ Syntax<Tab><Leader>mm     :call RunSyntaxCheck()<CR>
noremenu 100.300 PHP.Mess\ Detector<Tab><Leader>md    :call RunMessDetection()<CR>
noremenu 100.400 PHP.Code\ Sniffer<Tab><Leader>mf     :call RunCodeSniff()<CR>
noremenu 100.500 PHP.Code\ Duplication<Tab><Leader>mp :call RunCopyPasteDetection()<CR>
nnoremenu 100.600 PHP.Find\ occurences<Tab><Leader>ff :call FindOccurences(expand('<cword>'))<CR>
vnoremenu 100.650 PHP.Find\ occurences<Tab><Leader>ff :call FindOccurences(getline(".")[col("'<")-1:col("'>")-1])<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" SHORTCUTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Runs PHP syntax check on the current file or directory.
noremap <Leader>mm :execute 'make %'<CR>
" Runs PHP Mess Detector on the current file or directory.
" See http://phpmd.org
noremap <Leader>md :call RunMessDetection()<CR>
" Runs PHP Code Sniffer on the current file or directory.
" See https://github.com/squizlabs/PHP_CodeSniffer
noremap <Leader>mf :call RunCodeSniff()<CR>
" Runs PHP Copy/Paste Detector on the current file or directory.
" See https://github.com/sebastianbergmann/phpcpd
noremap <Leader>mp :call RunCopyPasteDetection()<CR>
" Shows occurences of word under cursor
nnoremap <Leader>ff :call FindOccurences(expand('<cword>'))<CR>
" Shows occurences of visually selected text
vnoremap <Leader>ff :call FindOccurences(getline(".")[col("'<")-1:col("'>")-1])<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" FUNCTIONS
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

" RunCopyPasteDetection {{{
function! RunCopyPasteDetection()
    let l:file = 'dupes_in_' . expand('%:t')
    execute 'redir! > /tmp/' . l:file
    execute 'silent !phpcpd ' . @%
    execute 'redir END'
    execute 'split'
    execute 'e /tmp/' . l:file
endfunction
" }}}

" FindOccurences {{{
function! FindOccurences(string)
    let l:file = substitute(a:string, '\s\+', '_', 'g')[0:64].'.occur'
    execute 'redir! > /tmp/' . l:file
    execute 'silent !szukaj "' . a:string . '"'
    execute 'redir END'
    execute 'split'
    execute 'e /tmp/' . l:file
    execute 'silent %s/:\s\+/:/'
    execute 'w'

    execute 'syn clear'
    execute 'hi searched   gui=bold guifg=#FD4F6A'
    execute 'hi linenumber gui=none guifg=green'
    execute 'syn match   searched   "' . a:string . '"'
    execute 'syn match   linenumber ":\d\+:"'
endfunction
" }}}
