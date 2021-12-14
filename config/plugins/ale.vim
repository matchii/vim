Plug 'dense-analysis/ale'

let g:ale_linters_explicit = 1
" let g:ale_lint_on_text_changed = 'never'

let g:ale_lint_on_text_changed = 0
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
let g:ale_php_phpstan_configuration = 'phpstan.neon'
let g:ale_php_psalm_configuration = 'psalm.xml'
