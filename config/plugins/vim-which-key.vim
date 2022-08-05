Plug 'liuchengxu/vim-which-key'

nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>

autocmd VimEnter * call which_key#register('<Space>', "g:which_key_map")

let g:which_key_map = {}
let g:which_key_map['b'] = {
    \ 'name' : '+breaks',
    \ 'a' : 'Break array',
    \ 'p' : 'Break params',
    \ 'r' : 'Break arrows',
    \ }
let g:which_key_map['c'] = {
    \ 'name' : '+Coc',
    \ 'e' : 'list extensions',
    \ 'r' : 'restart',
    \ }
let g:which_key_map['g'] = {
    \ 'name' : '+Git',
    \ 'l' : 'Git log for this file',
    \ }
let g:which_key_map['n'] = {
    \ 'name' : '+NERDTree',
    \ 'f' : 'find',
    \ 't' : 'toggle',
    \ }
let g:which_key_map['s'] = {
    \ 'name' : '+Signify',
    \ 'd' : 'diff',
    \ 'u' : 'hunk undo',
    \ }
let g:which_key_map['w'] = {
    \ 'name' : '+Wiki',
    \ 't' : 'open new tab',
    \ 'w' : 'open',
    \ }
let g:which_key_map['x'] = {
    \ 'name' : '+Other',
    \ 'e' : 'edit snippets',
    \ }
