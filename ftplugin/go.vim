autocmd!
" wcięcia tabulatorami
autocmd Filetype go set noexpandtab
" nie pokazuj tabulatorów
autocmd Filetype go set nolist
" usuń wszystkie zwinięcia (zaraz nałożymy je ponownie)
autocmd Filetype go :normal! zE
