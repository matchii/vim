""""""""""""""""""""""""""""""""""""""""
""""" opcje ogólne
""""""""""""""""""""""""""""""""""""""""

set comments+=b:\"

filetype on

" dolny przewijacz
set guioptions+=b
" usunięcie paska narzędzi
set guioptions-=T
" usunięcie paska menu
set guioptions-=m

" kodowanie znaków
set encoding=utf-8

" numeracja linii
set number

" ilość kolumn zwijania
set fdc=3

set incsearch

" podświetlanie wyszukiwania
set hlsearch

" przeszukiwanie case insensitive
" set ignorecase

" odstęp kursora od krawędzi poziomych
" set scrolloff=3

" kolorowanie składni
syntax on

" dolny pasek
set ruler
set showcmd

" długość tabulatora
set ts=4
set shiftwidth=4
set list
set listchars=tab:\|\ ,trail:·
set expandtab
set softtabstop=4

" tekst się nie zawija
set nowrap
set sidescroll=10
set laststatus=2

" podświetlanie wybranej kolumny
set colorcolumn=120
filetype plugin indent on

set wildmenu
set wildmode=list:longest,full

let mapleader = ","

let completeopt="menuone,longest,preview"

execute pathogen#infect()

autocmd BufReadPre *.wiki setlocal textwidth=100

""""""""""""""""""""""""""""""""""""""""
""""" mapowania ogólne
""""""""""""""""""""""""""""""""""""""""

" wybór zakładki
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt
" poprzednia / następna zakładka
nnoremap <A-[> gT
nnoremap <A-]> gt
nnoremap <A-'> <Esc>:q<CR>

" otaczanie blokiem try..catch
noremap  <Leader>it :call SetTryCatchBlock(line('.'), line('.'))<CR>j0f(a
vnoremap  <Leader>it :<C-U>call SetTryCatchBlock(line("."), line("'>"))<CR>/}\s*catch<CR>0f(a

noremap <Leader>fsp :call SetProject()<CR>
" objęcie słowa apostrofami/cudzysłowami/nawiasami
noremap <Leader>( <ESC>ciw(<C-R>")<ESC>
vnoremap <Leader>( "qc(<Esc>pa)<Esc>%
vnoremap <Leader>[ "qc[<Esc>pa]<Esc>
vnoremap <Leader>{ "qc{<Esc>pa}<Esc>
noremap <Leader>' <ESC>ciw'<C-R>"'<ESC>
vnoremap <Leader>' "qc'<Esc>pa'<Esc>
vnoremap <Leader>" "qc"<Esc>pa"<Esc>
noremap <Leader>` <ESC>ciw`<C-R>"`<ESC>
vnoremap <Leader>` "qc`<Esc>pa`<Esc>
vnoremap <Leader><Space> "qc<Space><Esc>pa<Space><Esc>

inoremap {<Space> {  }<Left><Left>
inoremap {<CR>     {<CR>}<Esc>O
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap <expr> "  strpart(getline('.'), col('.')-1, 1) == '"' ? "\<Right>" : '""<Left>'
inoremap <expr> '  strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" : "''<Left>"
inoremap <expr> `  strpart(getline('.'), col('.')-1, 1) == "`" ? "\<Right>" : "``<Left>"

" nowa karta z listą plików
noremap <C-n> <ESC>:silent Te<CR>

" wyłącza podświetlanie wyszukiwania
noremap <C-h> :nohlsearch<CR>

" nowy pusty bufor
noremap <F6> :enew<CR>

" zamyka dolny bufor
noremap <F7> <Esc><C-w>j:q<CR>

" zamyka górny bufor
noremap <F8> <Esc><C-w>k:q<CR>

" wywołanie omnikompletacji
inoremap <C-space> <C-X><C-O>

" wcięcie zaznaczonego tekstu
vnoremap <Tab> >
vnoremap <S-Tab> <

" spacja rozwija/zwija folding
nnoremap <space> za

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
augroup folds
    autocmd!
    autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
    autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif
augroup END

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup filetype_xt
    au BufNewFile,BufRead *.xt  setf xt
augroup END

""""""""""""""""""""""""""""""""""""""""
""""" Vdebug
""""""""""""""""""""""""""""""""""""""""
if (!exists('g:vdebug_options'))
    let g:vdebug_options = {}
endif
let g:vdebug_options['port'] = 9099
let g:vdebug_options['path_maps'] = {"/var/www": "/home/maciejwatras/theqar"}

""""""""""""""""""""""""""""""""""""""""
""""" skróty
""""""""""""""""""""""""""""""""""""""""

inoremap {3 {{{<CR><CR>}}}<Up>

iab tne throw new Exception("");<ESC>3h
iab psf public static function

"""" UltiSnips {{{
let g:UltiSnipsEditSplit='horizontal'
" }}}

""""" Syntastic {{{
let g:syntastic_php_phpmd_quiet_warnings = { "regex": "Avoid variables with short names like \$id." }

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
" }}}

""""" persistent undo {{{
" https://stackoverflow.com/questions/5700389/using-vims-persistent-undo/22676189
set undofile                " Save undos after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
" }}}

" If host specific configuration is needed, create unversioned file config.vim
" You may use config.vim.example as a template
if filereadable(expand($HOME."/.vim/config.vim"))
    source ~/.vim/config.vim
endif
" Nothing should go below this line.
