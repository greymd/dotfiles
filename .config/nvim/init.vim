" === Pulugins START ===
call plug#begin('~/.vim/plugged')
Plug 'ntpeters/vim-better-whitespace'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'tomasr/molokai'
Plug 'terryma/vim-multiple-cursors'
Plug 'lambdalisue/pastefix.vim' " Workaround of bug of clipboard
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'github/copilot.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'hashivim/vim-terraform'
call plug#end()
" === Pulugins END ===

" === Set for terraform syntax highlight ===
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'override' : {
  \         'spellbad':   ['#000000', '0'],
  \         'spellcap':   ['#000000', '0'],
  \       }
  \     }
  \   }
  \ }

" === Check OS ===
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

" === Common Configures START ===
let mapleader = "\<Space>"
noremap <leader>[ i[<ESC>ea]<ESC>
noremap <leader>` i`<ESC>ea`<ESC>
noremap <leader>( i(<ESC>ea)<ESC>
noremap <leader>" i"<ESC>ea"<ESC>
noremap <leader>' i'<ESC>ea'<ESC>
" ma で a にマーク設定、'a で戻る
noremap <leader>W mav?■■■■<cr>j0y'a:noh<cr>

set clipboard=unnamedplus
colorscheme molokai
set number
set relativenumber
set updatetime=300
set shortmess+=c
set signcolumn=yes

" Spaces & Tabs {{{
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set copyindent

" set indent and tabstop to 4 in C
autocmd FileType c setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
" set indent and tabstop to 4 in Java
autocmd FileType java setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
" }}} Spaces & Tabs

" Use OS clipboard as the register when yank something
" Set default file encoding utf-8
set encoding=utf-8
" Set proper encoding by tring multiple encoding continuously
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
" Newline type
set fileformats=unix,mac,dos
" Enable mouse
set mouse=a
" === Common Configures END ===

" === coc-snippets ====
" Use TAB for select elements under the pop up window
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<tab>'

" === coc.nvim ===
let g:coc_global_extensions = [ 'coc-rust-analyzer', 'coc-snippets', 'coc-diagnostic', 'coc-pyright', 'coc-java', 'coc-tsserver' ]
" :CocConfig to run shellcheck

" From: https://github.com/neoclide/coc.nvim
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
""!! gd goes to definition, C-o can go back.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

if os=="mac"
  " Workaround for opening browser since g:netrw_http_cmd does not work (see https://github.com/vim/vim/issues/4738 ) 
  noremap <silent> gx :execute 'silent! !open -a Google\ Chrome ' . shellescape(expand('<cWORD>'), 1)<cr>
  " noremap <silent> gx :execute 'silent! !open -a Firefox ' . shellescape(expand('<cWORD>'), 1)<cr>
  let g:python3_host_prog = expand('~/repos/greymd/dotfiles/venv/bin/python3')
endif

" Scroll popup window -- see :h coc#float#has_scroll()
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" === Go Settings ===
autocmd BufWritePre *.go :silent :call CocAction('runCommand', 'editor.action.organizeImport')

" === YAML indent Settings ===
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" === defx
autocmd FileType defx call s:defx_my_settings()

function! s:defx_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
   \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> c
  \ defx#do_action('copy')
  nnoremap <silent><buffer><expr> m
  \ defx#do_action('move')
  nnoremap <silent><buffer><expr> p
  \ defx#do_action('paste')
  nnoremap <silent><buffer><expr> l
  \ defx#do_action('drop')
  nnoremap <silent><buffer><expr> t
  \ defx#do_action('open','tabnew')
  nnoremap <silent><buffer><expr> E
  \ defx#do_action('drop', 'vsplit')
  nnoremap <silent><buffer><expr> P
  \ defx#do_action('drop', 'pedit')
  nnoremap <silent><buffer><expr> o
  \ defx#do_action('open_or_close_tree')
  nnoremap <silent><buffer><expr> O
  \ defx#do_action('open_tree_recursive')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> M
  \ defx#do_action('new_multiple_files')
  nnoremap <silent><buffer><expr> C
  \ defx#do_action('toggle_columns',
  \                'mark:indent:icon:filename:type:size:time')
  nnoremap <silent><buffer><expr> S
  \ defx#do_action('toggle_sort', 'time')
  nnoremap <silent><buffer><expr> d
  \ defx#do_action('remove')
  nnoremap <silent><buffer><expr> r
  \ defx#do_action('rename')
  nnoremap <silent><buffer><expr> !
  \ defx#do_action('execute_command')
  nnoremap <silent><buffer><expr> x
  \ defx#do_action('execute_system')
  nnoremap <silent><buffer><expr> yy
  \ defx#do_action('yank_path')
  nnoremap <silent><buffer><expr> .
  \ defx#do_action('toggle_ignored_files')
  nnoremap <silent><buffer><expr> ;
  \ defx#do_action('repeat')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> q
  \ defx#do_action('quit')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> *
  \ defx#do_action('toggle_select_all')
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
  nnoremap <silent><buffer><expr> <C-l>
  \ defx#do_action('redraw')
  nnoremap <silent><buffer><expr> <C-g>
  \ defx#do_action('print')
  nnoremap <silent><buffer><expr> cd
  \ defx#do_action('change_vim_cwd')
endfunction
call defx#custom#option('_', {
      \ 'winwidth': 40,
      \ 'split': 'vertical',
      \ 'direction': 'topleft',
      \ 'show_ignored_files': 1,
      \ 'buffer_name': 'exlorer',
      \ 'toggle': 1,
      \ 'resume': 1,
      \ })

" Copilot v:false = disable, v:true = enable
let g:copilot_filetypes = {
      \ '*': v:true,
      \ 'sh': v:true,
      \ 'c' : v:true,
      \ 'java' : v:true,
      \ 'rs' : v:true,
      \ 'py' : v:true,
      \ 'go' : v:true,
      \ 'cpp' : v:true,
      \ 'js' : v:true,
      \ }
