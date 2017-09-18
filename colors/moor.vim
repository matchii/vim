" Supporting code -------------------------------------------------------------
" Preamble {{{

if !has("gui_running") && &t_Co != 88 && &t_Co != 256
    finish
endif

set background=dark

if exists("syntax_on")
    syntax reset
endif

let colors_name = "moor"

if !exists("g:badwolf_html_link_underline") " {{{
    let g:badwolf_html_link_underline = 1
endif " }}}

if !exists("g:badwolf_css_props_highlight") " {{{
    let g:badwolf_css_props_highlight = 0
endif " }}}

" }}}
" Palette {{{

let s:bwc = {}

" Normal text. (Change to e834dd - lovely purple.)
let s:bwc.plain       = ['eddfc7', 15] " jasny beżowy

" Pure and simple.
let s:bwc.snow        = ['ffffff', 15]  " biały
let s:bwc.coal        = ['000000', 16]  " czarny
let s:bwc.blood       = ['FF0000', 100] " czerwony

" Autumn colors
let s:bwc.cappuccino  = ['E1BF66', 20]  " tekst w apostrofach
let s:bwc.stone       = ['888888', 200] " ciemnoszary, komentarze
let s:bwc.lightstone  = ['D6D4CC', 200] " jasnoszary
let s:bwc.darkstone   = ['80643C', 200] " ciemny brąz, znaki specjalne
let s:bwc.soil        = ['251b16', 200] " prawie czarny
let s:bwc.darksoil    = ['140C07', 200] " jeszcze czarniejszy prawie czarny, tło numerów linii
let s:bwc.violet      = ['e811da', 100] " sparowany nawias
let s:bwc.moss        = ['80a970', 100] " szarozielony (ale bardziej zielony), statement
let s:bwc.olive       = ['A09320', 100] " słowa kluczowe
let s:bwc.lightolive  = ['D6C84A', 100] " typy
let s:bwc.fern        = ['ABF387', 100] " jasnozielony, operatory
let s:bwc.leaf        = ['A2AF58', 100] " nazwy zmiennych
let s:bwc.rust        = ['B6726C', 100] " stałe
let s:bwc.petal       = ['E834DD', 100] " szukany tekst
let s:bwc.rose        = ['ED382D', 100] " usunięta linia w diffie
let s:bwc.newleaf     = ['66E953', 100] " dodana linia w diffie
let s:bwc.nightsky    = ['5A00FF', 100] " kursor
let s:bwc.daysky      = ['00BFFF', 100] " kursor

" All of the Gravel colors are based on a brown from Clouds Midnight.
let s:bwc.brightgravel   = ['d9cec3', 252]
let s:bwc.lightgravel    = ['998f84', 245]
let s:bwc.gravel         = ['857f78', 243]
let s:bwc.deepgravel     = ['45413b', 238]
let s:bwc.deepergravel   = ['35322d', 236]
let s:bwc.darkgravel     = ['242321', 235]
let s:bwc.blackgravel    = ['1c1b1a', 233]
let s:bwc.blackestgravel = ['141413', 232]

" A color sampled from a highlight in a photo of a glass of Dale's Pale Ale on
" my desk.
let s:bwc.dalespale = ['fade3e', 221]

" A beautiful tan from Tomorrow Night.
let s:bwc.dirtyblonde = ['f4cf86', 222]

" Delicious, chewy red from Made of Code for the poppiest highlights.
let s:bwc.taffy = ['ff2c4b', 196]

" Another chewy accent, but use sparingly!
let s:bwc.saltwatertaffy = ['8cffba', 121]

" The star of the show comes straight from Made of Code.
let s:bwc.tardis = ['0a9dff', 39]

" This one's from Mustang, not Florida!
let s:bwc.orange = ['ffa724', 214]

" A limier green from Getafe.
let s:bwc.lime = ['aeee00', 154]

" Rose's dress in The Idiot's Lantern.
let s:bwc.dress = ['ff9eb8', 211]

" Another play on the brown from Clouds Midnight.  I love that color.
let s:bwc.toffee = ['b88853', 137]

" Also based on that Clouds Midnight brown.
let s:bwc.coffee    = ['c7915b', 173]
let s:bwc.darkroast = ['88633f', 95]

" }}}
" Highlighting Function {{{
function! s:HL(group, fg, ...)
    " Arguments: group, guifg, guibg, gui, guisp

    let histring = 'hi ' . a:group . ' '

    if strlen(a:fg)
        if a:fg == 'fg'
            let histring .= 'guifg=fg ctermfg=fg '
        else
            let c = get(s:bwc, a:fg)
            let histring .= 'guifg=#' . c[0] . ' ctermfg=' . c[1] . ' '
        endif
    endif

    if a:0 >= 1 && strlen(a:1)
        if a:1 == 'bg'
            let histring .= 'guibg=bg ctermbg=bg '
        else
            let c = get(s:bwc, a:1)
            let histring .= 'guibg=#' . c[0] . ' ctermbg=' . c[1] . ' '
        endif
    endif

    if a:0 >= 2 && strlen(a:2)
        let histring .= 'gui=' . a:2 . ' cterm=' . a:2 . ' '
    endif

    if a:0 >= 3 && strlen(a:3)
        let c = get(s:bwc, a:3)
        let histring .= 'guisp=#' . c[0] . ' '
    endif

    " echom histring

    execute histring
endfunction
" }}}
" Configuration Options {{{

if exists('g:badwolf_darkgutter') && g:badwolf_darkgutter
    let s:gutter = 'blackestgravel'
else
    let s:gutter = 'blackgravel'
endif

if exists('g:badwolf_tabline')
    if g:badwolf_tabline == 0
        let s:tabline = 'blackestgravel'
    elseif  g:badwolf_tabline == 1
        let s:tabline = 'blackgravel'
    elseif  g:badwolf_tabline == 2
        let s:tabline = 'darkgravel'
    elseif  g:badwolf_tabline == 3
        let s:tabline = 'deepgravel'
    else
        let s:tabline = 'blackestgravel'
    endif
else
    let s:tabline = 'blackgravel'
endif

" }}}

" Actual colorscheme ----------------------------------------------------------
" Vanilla Vim {{{

" General/UI {{{

call s:HL('Normal', 'plain', 'soil')

call s:HL('Folded', 'plain', 'bg', 'none')

call s:HL('VertSplit', 'snow', 'bg', 'none')

call s:HL('CursorLine',   '', 'coal', 'none')
call s:HL('CursorColumn', '', 'coal')
call s:HL('ColorColumn',  '', 'coal')

call s:HL('TabLine', 'snow', 'coal', 'none')
call s:HL('TabLineFill', 'snow', 'coal', 'none')
call s:HL('TabLineSel', 'snow', 'coal', 'none')

call s:HL('MatchParen', 'violet', 'bg', 'bold')

call s:HL('NonText',    'lightstone', 'bg')
call s:HL('SpecialKey', 'darkstone', 'bg')

call s:HL('Visual',    'daysky',  'coal')
call s:HL('VisualNOS', 'daysky',  'coal')

call s:HL('Search',    'coal', 'petal', 'bold')
call s:HL('IncSearch', 'coal', 'petal', 'bold')

call s:HL('Underlined', 'fg', '', 'underline')

call s:HL('StatusLine',   'plain', 'darksoil', 'italic')
call s:HL('StatusLineNC', 'plain', 'darksoil', 'none')

call s:HL('Directory', 'fg', 'bg', 'none')

call s:HL('Title', 'snow')

call s:HL('ErrorMsg',   'snow', 'bg', 'none')
call s:HL('MoreMsg',    'snow', '',   'none')
call s:HL('ModeMsg',    'snow', '',   'none')
call s:HL('Question',   'snow', '',   'none')
call s:HL('WarningMsg', 'snow', '',   'none')

" This is a ctags tag, not an HTML one.  'Something you can use c-] on'.
call s:HL('Tag', '', '', 'none')

" hi IndentGuides                  guibg=#373737
" hi WildMenu        guifg=#66D9EF guibg=#000000

" }}}
" Gutter {{{

call s:HL('LineNr',     'plain', 'darksoil')
call s:HL('SignColumn', 'plain', 'darksoil')
call s:HL('FoldColumn', 'plain', 'darksoil')

" }}}
" Cursor {{{

call s:HL('Cursor',  'coal', 'daysky', 'none')
call s:HL('vCursor', 'coal', 'snow', 'none')
call s:HL('iCursor', 'coal', 'snow', 'none')

" }}}
" Syntax highlighting {{{

" Start with a simple base.
call s:HL('Special', 'plain')

" Comments are slightly brighter than folds, to make 'headers' easier to see.
call s:HL('Comment',        'stone')
call s:HL('Todo',           'blood', 'bg', 'none')
call s:HL('SpecialComment', 'snow', 'bg', 'none')

" Strings are a nice, pale straw color.  Nothing too fancy.
call s:HL('String', 'fern')

" Control flow stuff is taffy.
call s:HL('Statement',   'rust', '', 'none')
call s:HL('Keyword',     'olive', '', 'none')
call s:HL('Conditional', 'rust', '', 'none')
call s:HL('Operator',    'cappuccino', '', 'none')
call s:HL('Label',       'rust', '', 'none')
call s:HL('Repeat',      'rust', '', 'none')

" Functions and variable declarations are orange, because plain looks weird.
call s:HL('Identifier', 'leaf', '', 'none')
call s:HL('Function',   'leaf', '', 'none')

" Preprocessor stuff is lime, to make it pop.
"
" This includes imports in any given language, because they should usually be
" grouped together at the beginning of a file.  If they're in the middle of some
" other code they should stand out, because something tricky is
" probably going on.
call s:HL('PreProc',   'olive', '', 'none')
call s:HL('Macro',     'snow', '', 'none')
call s:HL('Define',    'snow', '', 'none')
call s:HL('PreCondit', 'snow', '', 'none')

" Constants of all kinds are colored together.
" I'm not really happy with the color yet...
call s:HL('Constant',  'moss', '', 'none')
call s:HL('Character', 'moss', '', 'none')
call s:HL('Boolean',   'moss', '', 'none')

call s:HL('Number', 'snow', '', 'none')
call s:HL('Float',  'snow', '', 'none')

" Not sure what 'special character in a constant' means, but let's make it pop.
call s:HL('SpecialChar', 'snow', '', 'none')

call s:HL('Type', 'lightolive', '', 'none')
call s:HL('StorageClass', 'lightolive', '', 'none')
call s:HL('Structure', 'snow', '', 'none')
call s:HL('Typedef', 'snow', '', 'none')

" Make try/catch blocks stand out.
call s:HL('Exception', 'snow', '', 'none')

" Misc
call s:HL('Error',  'snow',   '', 'none')
call s:HL('Debug',  'snow',   '',      'none')
call s:HL('Ignore', 'snow', '',      '')

" }}}
" Completion Menu {{{

call s:HL('Pmenu', 'snow', 'coal')
call s:HL('PmenuSel', 'coal', 'snow', 'none')
call s:HL('PmenuSbar', '', 'deepergravel')
call s:HL('PmenuThumb', 'brightgravel')

" }}}
" Diffs {{{

call s:HL('DiffDelete', 'coal', 'coal')
call s:HL('DiffAdd',    '',     'deepergravel')
call s:HL('DiffChange', '',     'darkgravel')
call s:HL('DiffText',   'snow', 'deepergravel', 'none')

" }}}
" Spelling {{{

if has("spell")
    call s:HL('SpellCap', 'dalespale', 'bg', 'undercurl,none', 'dalespale')
    call s:HL('SpellBad', '', 'bg', 'undercurl', 'dalespale')
    call s:HL('SpellLocal', '', '', 'undercurl', 'dalespale')
    call s:HL('SpellRare', '', '', 'undercurl', 'dalespale')
endif

" }}}

" }}}
" Filetype-specific {{{

" CSS {{{

if g:badwolf_css_props_highlight
    call s:HL('cssColorProp', 'dirtyblonde', '', 'none')
    call s:HL('cssBoxProp', 'dirtyblonde', '', 'none')
    call s:HL('cssTextProp', 'dirtyblonde', '', 'none')
    call s:HL('cssRenderProp', 'dirtyblonde', '', 'none')
    call s:HL('cssGeneratedContentProp', 'dirtyblonde', '', 'none')
else
    call s:HL('cssColorProp', 'fg', '', 'none')
    call s:HL('cssBoxProp', 'fg', '', 'none')
    call s:HL('cssTextProp', 'fg', '', 'none')
    call s:HL('cssRenderProp', 'fg', '', 'none')
    call s:HL('cssGeneratedContentProp', 'fg', '', 'none')
end

call s:HL('cssValueLength', 'toffee', '', 'none')
call s:HL('cssColor', 'toffee', '', 'none')
call s:HL('cssBraces', 'lightgravel', '', 'none')
call s:HL('cssIdentifier', 'orange', '', 'none')
call s:HL('cssClassName', 'orange', '', 'none')

" }}}
" Diff {{{

call s:HL('gitDiff', 'snow', '',)

call s:HL('diffRemoved', 'rose', '',)
call s:HL('diffAdded', 'newleaf', '',)
call s:HL('diffFile', 'rust', 'coal', 'none')
call s:HL('diffNewFile', 'rust', 'coal', 'none')

call s:HL('diffLine', 'cappuccino', 'coal', 'none')
call s:HL('diffSubname', 'snow', '', 'none')

" }}}
" Django Templates {{{

call s:HL('djangoArgument', 'dirtyblonde', '',)
call s:HL('djangoTagBlock', 'orange', '')
call s:HL('djangoVarBlock', 'orange', '')
" hi djangoStatement guifg=#ff3853 gui=none
" hi djangoVarBlock guifg=#f4cf86

" }}}
" HTML {{{

" Punctuation
call s:HL('htmlTag',    'snow', 'bg', 'none')
call s:HL('htmlEndTag', 'snow', 'bg', 'none')

" Tag names
call s:HL('htmlTagName',        'snow', '', 'none')
call s:HL('htmlSpecialTagName', 'snow', '', 'none')
call s:HL('htmlSpecialChar',    'snow',   '', 'none')

" Attributes
call s:HL('htmlArg', 'snow', '', 'none')

" Stuff inside an <a> tag

if g:badwolf_html_link_underline
    call s:HL('htmlLink', 'snow', '', 'underline')
else
    call s:HL('htmlLink', 'snow', '', 'none')
endif

" }}}
" Markdown {{{

call s:HL('markdownHeadingRule', 'lightgravel', '', 'none')
call s:HL('markdownHeadingDelimiter', 'lightgravel', '', 'none')
call s:HL('markdownOrderedListMarker', 'lightgravel', '', 'none')
call s:HL('markdownListMarker', 'lightgravel', '', 'none')
call s:HL('markdownItalic', 'snow', '', 'none')
call s:HL('markdownBold', 'snow', '', 'none')
call s:HL('markdownH1', 'orange', '', 'none')
call s:HL('markdownH2', 'lime', '', 'none')
call s:HL('markdownH3', 'lime', '', 'none')
call s:HL('markdownH4', 'lime', '', 'none')
call s:HL('markdownH5', 'lime', '', 'none')
call s:HL('markdownH6', 'lime', '', 'none')
call s:HL('markdownLinkText', 'toffee', '', 'underline')
call s:HL('markdownIdDeclaration', 'toffee')
call s:HL('markdownAutomaticLink', 'toffee', '', 'none')
call s:HL('markdownUrl', 'toffee', '', 'none')
call s:HL('markdownUrldelimiter', 'lightgravel', '', 'none')
call s:HL('markdownLinkDelimiter', 'lightgravel', '', 'none')
call s:HL('markdownLinkTextDelimiter', 'lightgravel', '', 'none')
call s:HL('markdownCodeDelimiter', 'dirtyblonde', '', 'none')
call s:HL('markdownCode', 'dirtyblonde', '', 'none')
call s:HL('markdownCodeBlock', 'dirtyblonde', '', 'none')

" }}}
" MySQL {{{

call s:HL('mysqlSpecial', 'dress', '', 'none')

" }}}
" Python {{{

hi def link pythonOperator Operator
call s:HL('pythonBuiltin',     'dress')
call s:HL('pythonBuiltinObj',  'dress')
call s:HL('pythonBuiltinFunc', 'dress')
call s:HL('pythonEscape',      'dress')
call s:HL('pythonException',   'lime', '', 'none')
call s:HL('pythonExceptions',  'lime', '', 'none')
call s:HL('pythonPrecondit',   'lime', '', 'none')
call s:HL('pythonDecorator',   'taffy', '', 'none')
call s:HL('pythonRun',         'gravel', '', 'none')
call s:HL('pythonCoding',      'gravel', '', 'none')

" }}}
" Vim {{{

call s:HL('VimCommentTitle', 'snow', '', 'none')

call s:HL('VimMapMod',    'snow', '', 'none')
call s:HL('VimMapModKey', 'snow', '', 'none')
call s:HL('VimNotation', 'snow', '', 'none')
call s:HL('VimBracket', 'snow', '', 'none')

" }}}

" }}}
