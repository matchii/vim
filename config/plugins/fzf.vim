Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {'options': ['--exact']}, <bang>0)

nnoremap <leader>F :Files<CR>
nnoremap <leader>L :Lines<CR>
nnoremap <leader>R :Rg<CR>
nnoremap <leader>T :Tags<CR>
