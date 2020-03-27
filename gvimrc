colorscheme moor

" Load projects' configuration if vim-project is installed
if !empty(glob('~/.vim/bundle/vim-project/autoload/project.vim'))
    let g:project_use_nerdtree = 1
    set rtp+=~/.vim/bundle/vim-project/
    call project#rc("~/projects")

    Project  'pimcore-aptekagemini-docker/src'              , 'AptekaGemini'
    File     'pimcore-aptekagemini-docker/src/.git/index'   , 'AptekaGemini Git'
    Callback 'AptekaGemini'                                 , 'SetupAG'

    Project  'selena-pim'               , 'Selena'
    File     'selena-pim/.git/index'    , 'Selena Git'
    Callback 'Selena'                   , 'SetupSelena'

    Project  '~/.vim'                   , 'Vim'
    Callback 'Vim'                      , 'SetupVim'

    function! SetupAG(title)
        let g:phpactorInitialCwd = '/home/maciej/projects/pimcore-aptekagemini-docker/src'
        set tags = .git/tags
        set foldnestmax = 1
        let g:syntastic_php_checkers = ['php', 'phpmd']
    endfunction

    function! SetupSelena(title)
        let g:phpactorInitialCwd = '/home/maciej/projects/selena-pim'
        set tags = .git/tags
        set foldnestmax = 1
        let g:syntastic_php_checkers = ['php', 'phpmd']
    endfunction

    function! SetupVim(title)
        let g:phpactorInitialCwd = '/home/maciej/.vim'
    endfunction
endif
