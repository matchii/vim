colorscheme moor

" dolny przewijacz
set guioptions+=b
" usunięcie paska narzędzi
set guioptions-=T
" usunięcie paska menu
set guioptions-=m
" nie używaj wyskakującego okienka
set guioptions+=c

" If host specific gui configuration is needed, create unversioned file gconfig.vim
" You may use config.vim.example as a template
if filereadable(expand($HOME."/.vim/gconfig.vim"))
    source ~/.vim/gconfig.vim
endif
" Nothing should go below this line.
