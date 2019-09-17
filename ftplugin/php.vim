" zawijanie klas i metod
let php_folding=1
" sprawdzanie składni
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l
set omnifunc=vimpoc#CompletePHP
set relativenumber

noremap K :call GetPHPDocumentation(expand("<cword>"))<CR><CR>
noremap  <Leader>io :call SetComment(line('.'), line('.'), '/*', ' */')<CR>
vnoremap <Leader>io :<C-U>call SetComment(line("."), line("'>"), '/*', ' */')<CR>
noremap  <Leader>ih :call SetComment(line("."), line("."), '<!--', ' -->')<CR>
vnoremap <Leader>ih :<C-U>call SetComment(line("."), line("'>"), '<!--', ' -->')<CR>

noremap <Leader>msg :call MakeSetterAndGetter(expand("<cword>"))<CR>
noremap <Leader>ms :call MakeSetter(expand("<cword>"))<CR>
noremap <Leader>mg :call MakeGetter(expand("<cword>"))<CR>
" ustawianie słowa pod kursorem jako domyślnej klasy do omni
noremap <Leader>k :let b:defaultClass = expand("<cword>")<CR>
vnoremap <Leader>k :<C-U>let b:defaultClass = getline(".")[col("'<")-1:col("'>")-1]<CR>

" tworzy szablon klasy na podstawie nazwy pliku
noremap <Leader>mc :execute MakeClass()<CR>

inoremap <Leader>ip <ESC>:call PhpDocSingle()<CR>i
nnoremap <Leader>ip :call PhpDocSingle()<CR>
vnoremap <Leader>ip :call Ph(pRa)nge()<CR>

iab rr return $result;
iab rs return $this;
iab ie <?php if (): ?><CR><?php endif ?><ESC>kF(a
iab fe foreach () <C-V>{<CR>}<ESC>kf(
iab fd <?php foreach (): ?><CR><?php endforeach ?><ESC>kF(a
iab vd var_dump($);<ESC>2h
iab vi var_dump($);die;<ESC>6h
iab pe <?=  ?><ESC>2h
iab pp <?php  ?><ESC>2h
iab t> $this-
