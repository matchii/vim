Plug 'itchyny/lightline.vim'

" To jest chyba niepotrzebne, bo jest włączone domyślnie, nie pamiętam
" dlaczego chciałem to włączyć.
" set noshowmode

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
