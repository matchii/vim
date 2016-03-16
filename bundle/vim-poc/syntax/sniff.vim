" Vim syntax file
" Language: PHP Code Sniffer result (type 'full')
" Maintainer: Maciej Watras
" Latest Revision: 20 Oct 2015

if exists("b:current_syntax")
  finish
endif

syn match error   "\d* ERROR"
syn match warning "\d* WARNING"

hi error   guifg=#F92330 guibg=NONE
hi warning guifg=#FF8B1A guibg=NONE

let b:current_syntax = "sniff"
