noremap  <Leader>io :call SetComment(line("."), line("."), '<!--', ' -->')<CR>
vnoremap <Leader>io :<C-U>call SetComment(line("."), line("'>"), '<!--', ' -->')<CR>
