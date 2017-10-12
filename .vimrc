" ###############################
" ########## Check OS ###########
" ###############################
function! GetRunningOS()
  if has("win32")
    return "win"
  endif
  if has("unix")
    if system('uname')=~'Darwin'
      return "mac"
    else
      return "linux"
    endif
  endif
endfunction
let os=GetRunningOS()

function! IsBoW()
  " win32yank.exe is required (https://github.com/equalsraf/win32yank).
  let executeCmd="grep -q Microsoft /proc/version 2> /dev/null && which win32yank.exe &> /dev/null"
  echo system(executeCmd)
  return v:shell_error=="0" ? 1 : 0
endfunction

if IsBoW() && os=="linux"
    " This is bash on windows.
    " Share clipboard with windows native env.
    vmap <C-c> :w !win32yank.exe -i<CR><CR>
endif

" ###############################
" ########## dein.vim ###########
" ###############################
if &compatible
  set nocompatible
endif

if os=="win"
  set runtimepath+=~\.cache\dein\repos\github.com\Shougo\dein.vim
  call dein#begin(expand('~\.cache\dein'))
else
  set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
  call dein#begin(expand('~/.cache/dein'))
endif


call dein#add('Shougo/dein.vim')
call dein#add('Shougo/neocomplete.vim',{
            \ 'lazy': 1})

" Please refer to http://rcmdnk.github.io/blog/2015/01/12/computer-vim/
call dein#add("Shougo/neocomplcache.vim")
call dein#add("Shougo/neosnippet")
call dein#add("Shougo/neosnippet-snippets")
call dein#add("honza/vim-snippets")
call dein#add("rcmdnk/vim-octopress-snippets")

" Color schemas
call dein#add("nanotech/jellybeans.vim")
call dein#add("tomasr/molokai")

call dein#add("Shougo/unite.vim")
call dein#add("Shougo/unite-outline")
call dein#add('Shougo/vimfiler')
call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
call dein#add('t9md/vim-choosewin')
call dein#add('soh335/vim-symfony')
call dein#add('petdance/vim-perl')
call dein#add('hotchpotch/perldoc-vim')
call dein#add('thinca/vim-quickrun')
call dein#add('AndrewRadev/switch.vim')
call dein#add('tpope/vim-endwise')
call dein#add('vimtaku/hl_matchit.vim.git')
call dein#add('deris/vim-shot-f')
call dein#add('kamichidu/vim-edit-properties')
call dein#add('kien/ctrlp.vim')
call dein#add('powerman/vim-plugin-AnsiEsc')
call dein#add('bling/vim-airline')
call dein#add('rking/ag.vim')
call dein#add('alpicola/vim-egison')
call dein#add('CORDEA/vim-glue')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('greymd/oscyank.vim')


" MultiCursors
call dein#add('terryma/vim-multiple-cursors')

" For CSV file
call dein#add('chrisbra/csv.vim')
" http://qiita.com/rbtnn/items/3830c1ca7d65725046ed
call dein#add('rbtnn/rabbit-ui.vim')
call dein#add('rbtnn/rabbit-ui-collection.vim')

if os=="win" || os=="linux"
  call dein#add('drmikehenry/vim-fontsize')
endif

call dein#add('Lokaltog/vim-easymotion')

" for /Tabular
call dein#add('godlygeek/tabular')

" Related to Markdown (http://qiita.com/uedatakeshi/items/31761b87ba8ecbaf2c1e)
call dein#add('plasticboy/vim-markdown')
call dein#add('kannokanno/previm')
call dein#add('tyru/open-browser.vim',{
            \ 'lazy': 1})
call dein#add('dhruvasagar/vim-table-mode')
let g:table_mode_corner='|'

" Node.js Express environment (http://qiita.com/ko2ic/items/daaef529c1dfdb94adbb#vim)
call dein#add('heavenshell/vim-jsdoc' , {
            \ 'autoload': {'filetypes': ['javascript']},
            \ 'lazy': 1})

call dein#add('moll/vim-node')

call dein#add('mattn/jscomplete-vim')
:setl omnifunc=jscomplete#CompleteJS

call dein#add('myhere/vim-nodejs-complete')
:setl omnifunc=jscomplete#CompleteJS
if !exists('g:neocomplcache_omni_functions')
	let g:neocomplcache_omni_functions = {}
endif
let g:neocomplcache_omni_functions.javascript = 'nodejscomplete#CompleteJS'
let g:node_usejscomplete = 1

call dein#add('pangloss/vim-javascript')
call dein#add('scrooloose/syntastic')
let g:syntastic_check_on_open=0 "Disable syntach check when a file is just opened.
let g:syntastic_check_on_save=1 "Check when saving.
let g:syntastic_enable_tex_checker=0 "Disable syntax check for TeX
let g:syntastic_check_on_wq = 0 " :wq command does not cause syntax check
let g:syntastic_auto_loc_list=1 " Automatically open location list in case of error.
let g:syntastic_loc_list_height=6 "Height of error message window.
set statusline+=%#warningmsg# "Format of error message.
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_javascript_checkers = ['eslint'] "Use ESLint

let g:syntastic_mode_map = {
      \ 'mode': 'active',
      \ 'active_filetypes': ['javascript','ruby', 'php'],
      \ 'passive_filetypes': ['tex']
      \ }

" Requred: $ gem i rubocop
let g:syntastic_ruby_checkers = ['rubocop']

" Requred: composer global require "squizlabs/php_codesniffer=*"
let g:syntastic_php_checkers = ['phpcs']
let g:syntastic_php_phpcs_args="--standard=psr2"

" Earthquake detection
" call dein#add('haya14busa/eew.vim')

" vim-abolish
call dein#add('tpope/vim-abolish')

" Rails settings from https://gist.github.com/alpaca-tc/6695766
call dein#add('tpope/vim-rails', { 'autoload' : {
      \ 'filetypes' : ['haml', 'ruby', 'eruby'] }})

call dein#add('basyura/unite-rails', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \   'unite_sources' : [
      \     'rails/bundle', 'rails/bundled_gem', 'rails/config',
      \     'rails/controller', 'rails/db', 'rails/destroy', 'rails/features',
      \     'rails/gem', 'rails/gemfile', 'rails/generate', 'rails/git', 'rails/helper',
      \     'rails/heroku', 'rails/initializer', 'rails/javascript', 'rails/lib', 'rails/log',
      \     'rails/mailer', 'rails/model', 'rails/rake', 'rails/route', 'rails/schema', 'rails/spec',
      \     'rails/stylesheet', 'rails/view'
      \  ]},
      \ 'lazy': 1})

" PlantUML syntax
call dein#add('aklt/plantuml-syntax')

" Neo4j syntax
call dein#add('neo4j-contrib/cypher-vim-syntax')

" nginx syntax
call dein#add('evanmiller/nginx-vim-syntax')

" e-mail header syntax
call dein#add('greymd/headers.vim')

" gradle syntax
call dein#add('tfnico/vim-gradle')

" groovy
call dein#add('greymd/gre-vim-snippets')
" egison
call dein#add('greymd/vim-egison-snippets')

" json
call dein#add('elzr/vim-json')
" In json, do not hide quotation (http://yuzuemon.hatenablog.com/entry/2015/01/15/035759)
let g:vim_json_syntax_conceal = 0

" For Java IDE
" Ref: http://www.lucianofiandesio.com/vim-configuration-for-happy-java-coding
" if os=="mac" || os=="linux" " In case of windows, layout gets broken...
call dein#add('Yggdroot/indentLine')
  " vertical line indentation
  let g:indentLine_color_term = 239
  let g:indentLine_color_gui = '#09AA08'
  " let g:indentLine_char = '│'
  let g:indentLine_char = '|'
" endif

" To use Eclim comfortably... with :BD
call dein#add('qpkorr/vim-bufkill')


" Sushibar
" call dein#add('pocke/sushibar.vim')

call dein#end()

syntax enable
filetype plugin indent on     " required!
filetype indent on
syntax on

" ####################################
" ######### Basic settings ###########
" ####################################

" ******************** Settings for files automatically created ********************
" collect all the swap files to one place
set directory=~/.vim/swap/
" collect all the undo files to one place
set undodir=~/.vim/undo/
" collect all the backup files to one place
set backupdir=~/.vim/backup/

" Enable mouse dragging in the tmux
set mouse=a
set ttymouse=xterm2

" ******************** Basic settings ********************
" Use OS clipboard as the register when yank something
set clipboard+=unnamed
" Use 256 color mode to prevent losing color in tmux
set t_Co=256

" Set default file encoding utf-8
set encoding=utf-8
" Set proper encoding by tring multiple encoding continuously
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
" Newline type
set fileformats=unix,mac,dos

"appear line numbers
set number
set relativenumber

" Tab setting
set ts=4 sw=4 sts=0

" Disable automatical folding
set textwidth=0
set tw=0

" Use 4 space instead of a tab
set tabstop=4
set autoindent
" set noexpandtab
set expandtab
set shiftwidth=4

" In case of ruby, use 2 spaces
autocmd Filetype ruby,sh,html,c setlocal ts=2 sts=2 sw=2

"行末とtabを表示する
set list

" There is specific settings for particular language, adopt it.
" filetype plugin on

"# # #
"# # # !!DO NOT DELETE THE END OF WHITE SPACE!!
"# # #
set listchars=tab:^\ 

" 編集中のファイルと同じディレクトリにカレントディレクトリを移動
" if exists('+autochdir')
" 	set autochdir
" endif


" Let it use external grep.
set grepprg=grep\ -niIH
set cursorline

" Enable plugin runtime
filetype plugin on
if !exists('loaded_matchit')
    " jump between  `do` and `end`, or `<html> and </html>` with % key
    runtime macros/matchit.vim
endif

" set spece key as a Leader
let mapleader = "\<Space>"

" Original Macro
noremap <leader>[ i[<ESC>ea]<ESC>
noremap <leader>( i(<ESC>ea)<ESC>
noremap <leader>" i"<ESC>ea"<ESC>
noremap <leader>' i'<ESC>ea'<ESC>
noremap <leader>o :Unite outline -start-insert<cr>
noremap <leader>y :Oscyank<cr>

" #######################################
" ################ eclim ################
" #######################################
" from: http://qiita.com/youhei/items/09756fba4f969b075486
" <C-x><C-u> is trigger of auto completion.
" Space + i
autocmd FileType java nnoremap <silent> <buffer> <leader>i :JavaImport<cr>
autocmd FileType java nnoremap <silent> <buffer> <leader>I :JavaImportOrganize<cr>
" Space + d
autocmd FileType java nnoremap <silent> <buffer> <leader>d :JavaDocSearch -x declarations<cr>
autocmd FileType java nnoremap <silent> <buffer> <leader>sa :JavaSearch -i -x all<cr>
autocmd FileType java nnoremap <silent> <buffer> <leader>sd :JavaSearch -i -x declarations<cr>
autocmd FileType java nnoremap <silent> <buffer> <leader>si :JavaSearch -i -x implementors<cr>
autocmd FileType java nnoremap <silent> <buffer> <leader>sr :JavaSearch -i -x references<cr>
" :JavaSearch -t all -x references
" :JavaSearch -t all -x declarations
" CTRL-^ -- open previous buffer
" Space + Enter (back is :b#)
autocmd FileType java nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>
" Space + c
autocmd FileType java nnoremap <silent> <buffer> <leader>c :JavaCorrect<cr>
" Space + f -- reload .classpath
autocmd FileType java nnoremap <silent> <buffer> <leader>f :ProjectRefresh<cr>
autocmd FileType java let g:EclimJavaSearchSingleResult = 'edit'
" Memo: In the future, following commands will be registered.
" :JavaGet - Create a java bean getter method.
" :JavaSet - Create a java bean setter method.
" :JavaGetSet - Create both a java bean getter and setter method.
" :JavaConstructor - Creates class constructor, either empty or based on selected class fields.
" :JavaCallHierarchy [-s <scope>] - Display the call hierarchy for the method under the cursor.
" :JavaHierarchy - View the type hierarchy tree.
" :JavaImpl - View implementable / overridable methods from super classes and implemented interfaces.
" :JavaDelegate - View list of methods that delegate to the field under the cursor.
" :JUnit [testcase] - Allows you to execute junit test cases.
" :JUnitFindTest - Attempts to find the corresponding test for the current source file.
" :JUnitImpl - Similar to :JavaImpl, but creates test methods.
" :JUnitResult [testcase] - Allows you to view the results of a test case.
" :JavaImport - Import the class under the cursor.
" :JavaImportOrganize - Import undefined types, remove unused imports, sort and format imports.
" :JavaSearch [-p <pattern>] [-t <type>] [-x <context>] [-s <scope>] - Search for classes, methods, fields, etc. (With pattern supplied, searches for the element under the cursor).
" :JavaSearchContext - Perform a context sensitive search for the element under the cursor.
" :JavaCorrect - Suggest possible corrections for a source error.
" :JavaDocSearch - Search for javadocs. Same usage as :JavaSearch.
" :JavaDocComment - Adds or updates the comments for the element under the cursor.
" :JavaDocPreview - Display the javadoc of the element under the cursor in vim's preview window.
" :JavaRename [new_name] - Rename the element under the cursor.
" :JavaMove [new_package] - Move the current class/interface to another package.
" :Java - Executes the java using your project's main class.
" :JavaClasspath [-d <delim>] - Echos the project's classpath delimited by the system path separator or the supplied delimiter.
" :Javadoc [file, file, ...] - Executes the javadoc utility against all or just the supplied source files.
" :JavaListInstalls - List known JDK/JRE installs.
" :JavaFormat - Formats java source code.
" :Checkstyle - Invokes checkstyle on the current file.
" :Jps - Opens window with information about the currently running java processes.
" :Validate - Manually runs source code validation.


" ###############################################
" ########## vim-multiple-cursors.vim ###########
" ###############################################
" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction


" ####################################
" ########## choosewin.vim ###########
" ####################################
" '-' で呼び出し
nmap  -  <Plug>(choosewin)

" Use overlay
let g:choosewin_overlay_enable = 1

" Keep overlay fonts on the Multibyte buffer
let g:choosewin_overlay_clear_multibyte = 1

" Unify colors with tmux config
let g:choosewin_color_overlay = {
      \ 'gui': ['DodgerBlue3', 'DodgerBlue3' ],
      \ 'cterm': [ 25, 25 ]
      \ }
let g:choosewin_color_overlay_current = {
      \ 'gui': ['firebrick1', 'firebrick1' ],
      \ 'cterm': [ 124, 124 ]
      \ }

" Disable curor blink if when a window is focused.
let g:choosewin_blink_on_land      = 0
" Disable replacing status line.
let g:choosewin_statusline_replace = 0
" Disable replacing tabline.
let g:choosewin_tabline_replace    = 0

" #######################################
" ########## Syntax Highlight ###########
" #######################################
" Color setting
" colorscheme default
" colorscheme jellybeans
colorscheme molokai
let g:molokai_original=1

" Strengthen Java's syntax highlight
let java_highlight_all=1

" #################################
" ########## neosnippet ###########
" #################################
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() <Bar><bar> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Tell Neosnippet about the other snippets
if dein#tap("neosnippet")
    let g:neosnippet#enable_snipmate_compatibility = 1
    let g:neosnippet#disable_runtime_snippets = {'_' : 1}
    let g:neosnippet#snippets_directory = []
    if os=="win"
        if dein#tap("neosnippet-snippets")
            let g:neosnippet#snippets_directory += ['~\.cache\dein\repos\github.com\Shougo\neosnippet-snippets\neosnippets']
        endif
        if dein#tap("vim-octopress-snippets")
            let g:neosnippet#snippets_directory += ['~\.cache\dein\repos\github.com\rcmdnk\vim-octopress-snippets\neosnippets']
        endif
        if dein#tap("vim-snippets")
            let g:neosnippet#snippets_directory += ['~\.cache\dein\repos\github.com\honza\vim-snippets\snippets']
        endif
        if dein#tap('gre-vim-snippets')
            let g:neosnippet#snippets_directory += ['~\.cache\dein\repos\github.com\greymd\gre-vim-snippets\snippets']
        endif
        if dein#tap('vim-egison-snippets')
            let g:neosnippet#snippets_directory += ['~\.cache\dein\repos\github.com\greymd\vim-egison-snippets\snippets']
        endif
    else
        if dein#tap("neosnippet-snippets")
            let g:neosnippet#snippets_directory += ['~/.cache/dein/repos/github.com/Shougo/neosnippet-snippets/neosnippets']
        endif
        if dein#tap("vim-octopress-snippets")
            let g:neosnippet#snippets_directory += ['~/.cache/dein/repos/github.com/rcmdnk/vim-octopress-snippets/neosnippets']
        endif
        if dein#tap("vim-snippets")
            let g:neosnippet#snippets_directory += ['~/.cache/dein/repos/github.com/honza/vim-snippets/snippets']
        endif
        if dein#tap('gre-vim-snippets')
            let g:neosnippet#snippets_directory += ['~/.cache/dein/repos/github.com/greymd/gre-vim-snippets/snippets']
        endif
        if dein#tap('vim-egison-snippets')
            let g:neosnippet#snippets_directory += ['~/.cache/dein/repos/github.com/greymd/vim-egison-snippets/snippets']
        endif
    endif
endif

" #################################
" ######### neomplcache ###########
" #################################

" Disable another autocomplete plugin, ACP.
let g:acp_enableAtStartup=0
" Enable autocomplete plugin, neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:NeoComplCache_SmartCase = 1
" Use camel case completion.
let g:NeoComplCache_EnableCamelCaseCompletion = 1
" Use underbar completion.
let g:NeoComplCache_EnableUnderbarCompletion = 1
" Set minimum syntax keyword length.
let g:NeoComplCache_MinSyntaxLength = 3
" Set manual completion length.
let g:NeoComplCache_ManualCompletionStartLength = 0

if os=="win"
  let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default'    : '',
    \ 'perl'       : '~\.vim\dict\perl.dict'
    \ }
else
  let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default'    : '',
    \ 'perl'       : '~/.vim/dict/perl.dict'
    \ }
endif

" #################################
" ######### Project.vim ###########
" #################################
" Tabline enable
let g:airline#extensions#tabline#enabled = 1

" width setting
let g:proj_window_width = 30

" ###################################
" ########## quickrun.vim ###########
" ###################################
let g:quickrun_config={'*': {'split': 'vertical'}}
" Open result window below
set splitright

" #######################################
" ############ vim-airline ##############
" #######################################
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
" ###
" ### Mac OSX ONLY
" ###
if os=="mac"
  let g:airline_left_sep = '▷'
  let g:airline_right_sep = '◁'
endif

" ###
" ### Windows ONLY
" ###
if os=="win" || os=="linux"
  " let g:airline_left_sep = '▶'
  " let g:airline_right_sep = '◀'
  let g:airline_left_sep = '>'
  let g:airline_right_sep = '<'
endif

" ###
" ### Mac OSX ONLY
" ###
if os=="mac"
  let g:airline#extensions#tabline#left_sep = '▷'
  let g:airline#extensions#tabline#left_alt_sep = '◁'
endif

" ###
" ### Windows ONLY
" ###
if os=="win" || os=="linux"
  " let g:airline#extensions#tabline#left_sep = '▶'
  " let g:airline#extensions#tabline#left_alt_sep = '◀'
  let g:airline#extensions#tabline#left_sep = '|>'
  let g:airline#extensions#tabline#left_alt_sep = '<|'
endif

let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
" Show filename only
let g:airline#extensions#tabline#fnamemod = ':t'

" Configures for hl-matchit
let g:hl_matchit_enable_on_vim_startup = 1
let g:hl_matchit_hl_groupname = 'Title'
" !Attention! It may make vim's behavior slower.
let g:hl_matchit_allow_ft = 'html\|vim\|ruby'

" Vimfiler
" Automatically change current directory in accordance with Vimfiler
let g:vimfiler_enable_auto_cd = 1
let g:vimfiler_as_default_explorer = 1

" let g:vimfiler_edit_action="-split -simple -winwidth=35 -no-quit"
" call vimfiler#custom#profile('default', 'context', {
"       \ 'safe' : 0,
"       \ 'edit_action' : 'open',
"       \ })

"" From: http://spacevim.org/use-vim-as-a-java-ide/
call vimfiler#custom#profile('default', 'context', {
            \ 'explorer' : 1,
            \ 'winwidth' : 50,
            \ 'winminwidth' : 30,
            \ 'toggle' : 1,
            \ 'columns' : 'type',
            \ 'auto_expand': 1,
            \ 'direction' : 'leftbelow',
            \ 'parent': 0,
            \ 'explorer_columns' : 'type',
            \ 'status' : 1,
            \ 'safe' : 0,
            \ 'split' : 1,
            \ 'hidden': 1,
            \ 'no_quit' : 1,
            \ 'force_hide' : 0,
            \ })

" #######################################
" ########## Tab Improvement ############
" #######################################
"
" Basically `gF` key is used for tab.
nnoremap gf  <c-w>gF
" In case of <c-w>, do not open new tab.
nnoremap gF  <c-w>gf
nnoremap <c-w>gf gF
nnoremap <c-w>gF gf
" Create new tab with `gC`
map <silent> gC :tablast <bar> tabnew<CR>
" Close tab with `gX`
map <silent> gX :tabclose<CR>

" #######################################
" ######## Buffer Improvement ###########
" #######################################
" Ref: http://ivxi.hatenablog.com/entry/2013/05/23/163825
nnoremap <silent> gL :bprevious<CR>
nnoremap <silent> gl :bnext<CR>
" Use vim-bufkill
nnoremap <silent> gK :BD<CR>

" #######################################
" ############# unite.vim ###############
" #######################################
" insert modeで開始
let g:unite_enable_start_insert = 1

" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

" grep検索
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

" grep検索結果の再呼出
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>

" 手動での検索は Unite grep:.
" 検索した結果を再度開くには :UniteResume

" unite for native grep
" use external grep
"" let g:unite_source_grep_default_opts = '-inHI -C2 --exclude-dir=".git" --exclude-dir=".svn" --exclude-dir=".hg" --exclude-dir=".bzr"'

" if executable('ag')
"   let g:unite_source_grep_command = 'ag'
"   let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
"   let g:unite_source_grep_recursive_opt = ''
" endif

" Use Platinum Searcher
if executable('pt')
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor -i'
  let g:unite_source_grep_recursive_opt = ''
endif

" #######################################
" ####### vim-trailing-whitespace #######
" #######################################
let g:extra_whitespace_ignored_filetypes = ["unite", "mkd", "vimfiler"]

" #######################################
" ######### Original commands ###########
" #######################################
:command! Utex :Unite -vertical -winwidth=35 -no-quit outline
" :command! Ide  :VimFiler -split -simple -winwidth=35 -no-quit
:command! Ide :VimFiler -split -simple -winwidth=60 -no-quit
" Open with temporary file.
:command! Wtmp :w `=tempname()`
" Shortcut command to change file name[http://d.hatena.ne.jp/fuenor/20100115/1263551230]
command! -nargs=+ -bang -complete=file Rename let pbnr=fnamemodify(bufname('%'), ':p')|exec 'f '.escape(<q-args>, ' ')|w<bang>|call delete(pbnr)

" ###
" ### Mac OSX ONLY
" ###
if os=="mac"
  :command! Term :!open -a /Applications/iTerm.app/ %:h
endif

" ####################################
" ######## Markdown related ##########
" ####################################
au BufRead,BufNewFile *.md set filetype=markdown
if os=="mac"
  let g:previm_open_cmd = 'open -a Google\ Chrome'
endif

" Disable auto folding
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled=1

" ###
" ### Windows ONLY
" ###
if os=="win"
  set shell=C:/cygwin64/bin/zsh
  set shellcmdflag=--login\ -c
  set shellxquote=\"
endif

