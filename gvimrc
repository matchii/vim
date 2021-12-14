colorscheme moor

" dolny przewijacz
set guioptions+=b
" usunięcie paska narzędzi
set guioptions-=T
" wyłącz odczepianie podmenu (tear-off)
set guioptions-=t
" usunięcie paska menu
set guioptions-=m
" nie używaj wyskakującego okienka
set guioptions+=c

set mousemodel=popup
unmenu PopUp.-SEP2-
unmenu PopUp.Select\ Blockwise
unmenu PopUp.Select\ Word
unmenu PopUp.Select\ &Sentence
unmenu PopUp.Select\ Pa&ragraph
unmenu PopUp.Select\ &Line
silent! unmenu PopUp.Select\ &Block
unmenu PopUp.Select\ &All

nnoremenu PopUp.-SEP3-  :
nnoremenu PopUp.Close   :x<CR>
nnoremenu PopUp.Buffers :BufExplorer<CR>
nnoremenu PopUp.Tagbar  :TagbarToggle<CR>

nnoremenu PopUp.-Phpactor- :
nnoremenu PopUp.GoTo<Tab><Leader>o              :PhpactorGotoDefinition<CR>
nnoremenu PopUp.Import<Tab><Leader>u            :PhpactorImportClass<CR>
nnoremenu PopUp.Find\ References<Tab><Leader>fr :PhpactorFindReferences<CR>
nnoremenu PopUp.Hover<Tab><Leader>K             :PhpactorHover<CR>
nnoremenu PopUp.Phpactor.Navigate<Tab><Leader>nn            :PhpactorNavigate<CR>
nnoremenu PopUp.Phpactor.Context<Tab><Leader>mm             :PhpactorContextMenu<CR>
nnoremenu PopUp.Phpactor.Transform<Tab><Leader>tt           :PhpactorTransform<CR>
nnoremenu PopUp.Phpactor.Import\ all<Tab><Leader>ua         :PhpactorImportMissingClasses<CR>
nnoremenu PopUp.Phpactor.Move\ file<Tab><Leader>mf          :PhpactorMoveFile<CR>
nnoremenu PopUp.Phpactor.Copy\ file<Tab><Leader>cf          :PhpactorCopyFile<CR>
nnoremenu PopUp.Phpactor.GoTo\ h-split<Tab><Leader>Oh       :PhpactorGotoDefinitionHsplit<CR>
nnoremenu PopUp.Phpactor.GoTo\ v-split<Tab><Leader>Ov       :PhpactorGotoDefinitionVsplit<CR>
nnoremenu PopUp.Phpactor.GoTo\ tab<Tab><Leader>Ot           :PhpactorGotoDefinitionTab<CR>
nnoremenu PopUp.Phpactor.Extract<Tab><Leader>ee             :PhpactorExtractExpression<CR>
vnoremenu PopUp.Phpactor.Extract<Tab><Leader>ee             :<C-u>PhpactorExtractExpression<CR>
vnoremenu PopUp.Phpactor.Extract\ method<Tab><Leader>em     :<C-u>PhpactorExtractMethod<CR>
nnoremenu PopUp.Phpactor.Extract\ constant<Tab><Leader>ec   :PhpactorExtractExpression<CR>
nnoremenu PopUp.Phpactor.Class\ inflect<Tab><Leader>ci      :PhpactorClassInflect<CR>
nnoremenu PopUp.Phpactor.Expand\ class<Tab><Leader>e        :PhpactorClassExpand<CR>

nnoremenu PopUp.-Signify- :
nnoremenu PopUp.Signify.Preview             :SignifyHunkPreview<CR>
nnoremenu PopUp.Signify.Undo                :SignifyHunkUndo<CR>
nnoremenu PopUp.Signify.Fold                :SignifyFold<CR>
nnoremenu PopUp.Signify.Diff                :SignifyDiff<CR>
nnoremenu PopUp.Signify.Toggle\ highlight   :SignifyToggleHighlight<CR>

" If host specific gui configuration is needed, create unversioned file gconfig.vim
" You may use config.vim.example as a template
if filereadable(expand($HOME."/.vim/gconfig.vim"))
    source ~/.vim/gconfig.vim
endif
" Nothing should go below this line.
