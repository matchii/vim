"""" SETTINGS {{{

filetype plugin indent on
syntax on

set colorcolumn=120
set comments+=b:\"
set encoding=utf-8
set expandtab
set foldcolumn=3
set hidden
set hlsearch
" set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:\|\ ,trail:·
set nowrap
set number
set ruler
set scrolloff=5
set shiftwidth=4
set showcmd
set softtabstop=4
set ts=4
set sidescroll=10
set wildmenu
set wildmode=list:longest,full
" }}}

let completeopt="menuone,longest,preview"
let mapleader = '\'

"""" MAPPINGS {{{

nnoremap <silent> <leader> :WhichKey '\'<CR>

" tab select
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt
" previous tab
nnoremap <A-[> gT
" next tab
nnoremap <A-]> gt
" close tab
nnoremap <A-'> <Esc>:q<CR>

inoremap {<Space> {  }<Left><Left>
inoremap {<CR>     {<CR>}<Esc>O
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap <expr> "  strpart(getline('.'), col('.')-1, 1) == '"' ? "\<Right>" : '""<Left>'
inoremap <expr> '  strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" : "''<Left>"
inoremap <expr> `  strpart(getline('.'), col('.')-1, 1) == "`" ? "\<Right>" : "``<Left>"

noremap <F1> <ESC>:BufExplorer<CR>
" new tab
nnoremap <C-n> <ESC>:silent Texplore<CR>
" turn off highlight search
noremap <C-h> :nohlsearch<CR>
" new empty buffer
noremap <C-F6> :enew<CR>
" close lower buffer
noremap <F7> <Esc><C-w>j:q<CR>
" close upper buffer
noremap <F8> <Esc><C-w>k:q<CR>
noremap <C-F9> <Esc>:TagbarToggle<CR>

" toggle fold
nnoremap <space> za
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

"""" VimPlug {{{
" Installs VimPlug if not exists
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/bundle')

source ~/.vim/config/plugins/ale.vim
source ~/.vim/config/plugins/bufexplorer.vim
source ~/.vim/config/plugins/coc.vim
source ~/.vim/config/plugins/emmet-vim.vim
source ~/.vim/config/plugins/fzf.vim
source ~/.vim/config/plugins/lightline.vim
source ~/.vim/config/plugins/indentLine.vim
source ~/.vim/config/plugins/nerdtree.vim
source ~/.vim/config/plugins/nerdtree-git-plugin.vim
source ~/.vim/config/plugins/phpactor.vim
source ~/.vim/config/plugins/signify.vim
source ~/.vim/config/plugins/tagbar.vim
source ~/.vim/config/plugins/ultisnips.vim
source ~/.vim/config/plugins/vim-commentary.vim
source ~/.vim/config/plugins/vim-fugitive.vim
source ~/.vim/config/plugins/vim-project.vim
source ~/.vim/config/plugins/vim-unimpaired.vim
source ~/.vim/config/plugins/vdebug.vim
source ~/.vim/config/plugins/vim-rest-console.vim
source ~/.vim/config/plugins/vim-surround.vim
source ~/.vim/config/plugins/vim-test.vim
source ~/.vim/config/plugins/vim-which-key.vim
source ~/.vim/config/plugins/vimwiki.vim

call plug#end()
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
