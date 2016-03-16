" Vim syntax file
" Language: 
" Maintainer: Maciej Watras
" Latest Revision: 22 Oct 2015

if exists("b:current_syntax")
  finish
endif

syn match   linenumber ":\d\+:"

hi searched   gui=bold guifg=#FD4F6A
hi linenumber gui=none guifg=#49D339

let b:current_syntax = "occur"
