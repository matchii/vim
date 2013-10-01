"if has("gui_running")
"    execute 'cd ~/gitrepo'
"    execute 'silent e .'
"    " poniższe nie działa, bo gnome-shell nadpisuje to swoimi wartościami,
"    " a ja nie wiem gdzie je zmienić :(
"    execute 'set columns=130 lines=38'
"endif


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

colorscheme wombat

" dolny pasek
set ruler
set showcmd

" długość tabulatora
set ts=4
set shiftwidth=4
set list
set listchars=tab:+—,trail:·
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

let mapleader = "L"

let completeopt="menuone,longest,preview"

""""""""""""""""""""""""""""""""""""""""
""""" opcje dla PHP
""""""""""""""""""""""""""""""""""""""""

augroup php_options
    autocmd!
    " zawijanie klas i metod
    autocmd Filetype php let php_folding=1
    " sprawdzanie składni
    autocmd Filetype php set makeprg=php\ -l\ %
    autocmd Filetype php set errorformat=%m\ in\ %f\ on\ line\ %l
augroup END

""""""""""""""""""""""""""""""""""""""""
""""" własny kod
""""""""""""""""""""""""""""""""""""""""

source ~/.vim/my_functions.vim

augroup vimpoc
    autocmd!
    autocmd FileType php :set omnifunc=vimpoc#CompletePHP
augroup END


""""""""""""""""""""""""""""""""""""""""
""""" mapowania ogólne
""""""""""""""""""""""""""""""""""""""""

" grep
nnoremap <Leader>g :set operatorfunc=<SID>GrepOperator<CR>g@
vnoremap <Leader>g :<C-U>call <SID>GrepOperator(visualmode())<CR>

" kopiowanie całego bufora do schowka systemowego
nnoremap <Leader>j <ESC>ggVG"+y<C-O><C-O>

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

""""""""""""""""""""""""""""""""""""""""
""""" mapowania PHP
""""""""""""""""""""""""""""""""""""""""

augroup php
    autocmd!
    autocmd Filetype php noremap K :call GetPHPDocumentation(expand("<cword>"))<CR><CR>
augroup END


" otaczanie blokiem if
noremap  <Leader>ii :call SetIfBlock(line('.'), line('.'))<CR>kf(a
vnoremap  <Leader>ii :<C-U>call SetIfBlock(line("."), line("'>"))<CR>kf(a
" otaczanie blokiem try..catch
noremap  <Leader>it :call SetTryCatchBlock(line('.'), line('.'))<CR>j0f(a
vnoremap  <Leader>it :<C-U>call SetTryCatchBlock(line("."), line("'>"))<CR>/^\s*catch<CR>0f(a
" otaczanie komentarzem
noremap  <Leader>io :call SetComment(line('.'), line('.'))<CR>
vnoremap  <Leader>io :<C-U>call SetComment(line("."), line("'>"))<CR>
noremap <Leader>msg :call MakeSetterAndGetter(expand("<cword>"))<CR>
noremap <Leader>ms :call MakeSetter(expand("<cword>"))<CR>
noremap <Leader>mg :call MakeGetter(expand("<cword>"))<CR>
noremap <Leader>mf :call MakeMethod(expand("<cword>"))<CR>
noremap <Leader>mt :call MakeTestMethod(expand("<cword>"))<CR>k
" ustawianie słowa pod kursorem jako domyślnej klasy do omni
noremap <Leader>k :let b:defaultClass = expand("<cword>")<CR>
vnoremap <Leader>k :<C-U>let b:defaultClass = getline(".")[col("'<")-1:col("'>")-1]<CR>

noremap <Leader>mm :execute 'make %'<CR>

" tworzy szablon klasy na podstawie nazwy pliku
noremap <Leader>mc :execute MakeClass()<CR>

" wykonuje testy jednostkowe
" wszystkie
noremap <Leader>ua :call RunUnitTests()<CR>
" dla tego pliku; jeśli to jest plik *Test.php, to go wykonuje, inaczej szuka
" takiego pliku na podstawie nazwy obecnego
noremap <Leader>ui :call RunThisUnitTest()<CR>
" przepuszcza plik przez PHPMD
noremap <Leader>md :call RunMessDetection()<CR>

noremap <Leader>fsp :call SetProject()<CR>
noremap <Leader>bt :call BuildTags()<CR><CR>
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

inoremap <Leader>ip <ESC>:call PhpDocSingle()<CR>i
nnoremap <Leader>ip :call PhpDocSingle()<CR>
vnoremap <Leader>ip :call Ph(pRa)nge()<CR>


inoremap <? <? ?><Left><Left><Left>
inoremap {% {%  %}<Left><Left><Left>
inoremap {# {#  #}<Left><Left><Left>
inoremap {{ {{  }}<Left><Left><Left>
inoremap {<Space> {  }<Left><Left>
inoremap {<CR>     {<CR>}<Esc>O
inoremap        (  ()<Left>
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap        [  []<Left>
inoremap <expr> ]  strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap <expr> "  strpart(getline('.'), col('.')-1, 1) == '"' ? "\<Right>" : '""<Left>'
inoremap <expr> '  strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" : "''<Left>"
inoremap <expr> `  strpart(getline('.'), col('.')-1, 1) == "`" ? "\<Right>" : "``<Left>"

" wywołanie skryptu formatującego kod
noremap <F2> <ESC>:source ~/.vim/checkstyle<CR><CR>

" otwiera odnośnik do słowa pod kursorem w nowej karcie
noremap <F3> <ESC>:call OpenTagInNewTab(expand("<cword>"))<CR>
vnoremap <F3> <ESC>:call OpenTagInNewTab(getline(".")[col("'<")-1:col("'>")-1])<CR>

" nowa karta z listą plików
noremap <F4> <ESC>:silent Te<CR>

" wyłącza podświetlanie wyszukiwania
noremap <F5> :nohlsearch<CR>

" nowy pusty bufor
noremap <F6> :enew<CR>

" zamyka dolny bufor
noremap <F7> <Esc><C-w>j:q<CR>

" zamyka górny bufor
noremap <F8> <Esc><C-w>k:q<CR>

" powrót do aktualnego katalogu
noremap <F9> :silent e .<CR>

noremap <F11> :set foldmethod=manual<CR>
" nowa karta
" map <F3> :tabe<CR>
" map <F3> :tabNext<Enter> 

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

""""""""""""""""""""""""""""""""""""""""
""""" skróty
""""""""""""""""""""""""""""""""""""""""

"iab ii if () {<CR>}<ESC>k3l
"iab ee else<CR>{<CR>}<ESC>k
"iab ie if () {<CR>} else {<CR>}<ESC>2k3l
"iab fe foreach ()<Esc>a
"iab bb {<CR>}<Esc>k
iab vd var_dump($);<ESC>2h
iab vi var_dump($);die;<ESC>6h
"iab qp $query = Connection::getConnection()->prepare
"iab qb $query->bindValue
"iab rq $result = $query->fetch
"iab qe $query->execute();
"iab qq $query->closeCursor();
iab rr return $result;
iab rs return $this;
iab rt return true;
iab rf return false;
iab t> $this-
iab tne throw new Exception("");<ESC>3h
iab pf public function
"iab tf protected function ()<CR>{<CR>}<ESC>2k2e
iab psf public static function
"iab PS PDO::PARAM_STR
"iab PI PDO::PARAM_INT
iab tt <table><CR><thead><CR><tr><CR><th></th><CR></tr><CR></thead><CR><tbody><CR><tr><CR><td></td><CR></tr><CR></tbody><CR></table>
iab pp <?php  ?><ESC>2h
iab aa array()<ESC>h
