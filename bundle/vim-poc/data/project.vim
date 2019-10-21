" Copy this file to project's directory under the name .project.vim
"
" Available properties:
"
" let g:ctags_exclude {{{
" Directories which should be ignored by ctags. Default is none.
" See `ctags --help | grep -A 1 exclude` for syntax.
" Example: let g:ctags_exclude = '--exclude=cache --exclude=logs'
" }}}
"
" let g:code_style_standard {{{
" Code style name for PHP Code Sniffer. See `phpcs -i` for list. Default is PSR2.
" Example: let g:code_style_standard = 'Zend'
" }}}

" let g:syntastic_php_checkers {{{
" Checker run by Syntastic when php file is saved
" Example: let g:syntastic_php_checkers = ['php', 'phpmd']
" }}}

" let g:syntastic_php_phpcs_args {{{
" Arguments for phpcs when run by Syntastic (:SyntasticCheck phpcs)
" Example: let g:syntastic_php_phpcs_args='--standard=PSR2'
" }}}

" let g:grep_additional_args {{{
" Arguments for searching utility (for grep, basically).
" Example: let g:grep_additional_args='--exclude-dir=mongodata'
" }}}
