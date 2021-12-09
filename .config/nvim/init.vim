" === Pulugins START ===
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'tomasr/molokai'
Plug 'terryma/vim-multiple-cursors'
Plug 'lambdalisue/pastefix.vim' " Workaround of bug of clipboard
call plug#end()
" === Pulugins END ===
"
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

set clipboard=unnamedplus
colorscheme molokai
set number
set relativenumber
set updatetime=300
set shortmess+=c
set signcolumn=yes

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
let g:coc_global_extensions = [ 'coc-rust-analyzer', 'coc-snippets', 'coc-diagnostic', 'coc-pyright' ]
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
  " noremap <silent> gx :execute 'silent! !open -a Google\ Chrome ' . shellescape(expand('<cWORD>'), 1)<cr>
  noremap <silent> gx :execute 'silent! !open -a Firefox ' . shellescape(expand('<cWORD>'), 1)<cr>
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
