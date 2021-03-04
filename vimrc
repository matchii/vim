"""" USTAWIENIA {{{

set comments+=b:\"

filetype on

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
" }}}

let mapleader = '\'

let completeopt="menuone,longest,preview"

"""" MAPOWANIA {{{

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

" otwiera listę buforów
noremap <F1> <ESC>:BufExplorer<CR>

" nowa karta z listą plików
noremap <C-n> <ESC>:silent Te<CR>

" wyłącza podświetlanie wyszukiwania
noremap <C-h> :nohlsearch<CR>

" nowy pusty bufor
noremap <C-F6> :enew<CR>

" zamyka dolny bufor
noremap <F7> <Esc><C-w>j:q<CR>

" zamyka górny bufor
noremap <F8> <Esc><C-w>k:q<CR>

noremap <C-F9> <Esc>:TagbarToggle<CR>

noremap <C-F11> <Esc>:Files<CR>

" wywołanie omnikompletacji
inoremap <C-space> <C-X><C-O>

" wcięcie zaznaczonego tekstu
vnoremap <Tab> >
vnoremap <S-Tab> <

" spacja rozwija/zwija folding
nnoremap <space> za

inoremap {3 {{{<CR><CR>}}}<Up>
" }}}

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

autocmd BufReadPre *.wiki setlocal textwidth=100

"""" VimPlug {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/bundle')

Plug 'matchii/vim-project', { 'branch': 'init_callback' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'phpactor/phpactor', { 'for': 'php', 'branch': 'master', 'do': 'composer install --no-dev -o' }
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vimwiki/vimwiki'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'majutsushi/tagbar', { 'for': 'php' }
Plug 'SirVer/ultisnips'
Plug 'mhinz/vim-signify'
Plug 'diepm/vim-rest-console', { 'for': 'rest' }
Plug 'mattn/emmet-vim'
Plug 'vim-vdebug/vdebug'

call plug#end()
" }}}

"""" WTYCZKI {{{

"""" Vdebug {{{
if (!exists('g:vdebug_options'))
    let g:vdebug_options = {}
endif
let g:vdebug_options['watch_window_style'] = 'compact'
let g:vdebug_keymap = {
\    "run" : "<F5>",
\    "run_to_cursor" : "<F9>",
\    "step_over" : "<F2>",
\    "step_into" : "<F3>",
\    "step_out" : "<F4>",
\    "close" : "<F6>",
\    "detach" : "<C-F7>",
\    "set_breakpoint" : "<C-F10>",
\    "get_context" : "<F11>",
\    "eval_under_cursor" : "<C-F12>",
\    "eval_visual" : "<Leader>e",
\}
" }}}

"""" signify {{{
let g:signify_sign_show_text = 0

highlight SignifySignAdd                  ctermbg=green                guibg=#68cc95
highlight SignifySignDelete ctermfg=black ctermbg=red    guifg=#ffffff guibg=#cc6893
highlight SignifySignChange ctermfg=black ctermbg=yellow guifg=#000000 guibg=#ccca68
" }}}

"""" UltiSnips {{{
let g:UltiSnipsEditSplit='horizontal'
" }}}

"""" ALE {{{
let g:ale_linters_explicit = 1
let g:ale_linters = {'php': ['php', 'phpmd']}

" let g:ale_lint_on_text_changed = 0
" let g:ale_lint_on_insert_leave = 0

" let g:ale_set_loclist = 1 " :lopen
" let g:ale_set_quickfix = 0
let g:ale_set_highlights = 1 " podkreślenia
let g:ale_set_signs = 1 " konflikt z Signify
" let g:ale_echo_cursor = 1
" let g:ale_virtualtext_cursor = 1
" let g:ale_cursor_detail = 0 " otwiera bufor na górze po najechaniu na wiersz
" let g:ale_set_balloons = 1

let g:ale_php_phpmd_ruleset = 'phpmd_auto.xml'
"}}}

"""" lightline {{{
set noshowmode

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

let g:lightline = {
\   'active': {
\       'left': [
\           [ 'mode', 'paste' ],
\           [ 'gitbranch', 'readonly', 'filename', 'modified' ]
\       ]
\   },
\   'component_function': {
\       'gitbranch': 'FugitiveHead',
\   }
\ }
" }}}

"""" tagbar {{{
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['▸', '▾']
let g:tagbar_zoomwidth = 0
" }}}

" }}}

"""" persistent undo {{{
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
