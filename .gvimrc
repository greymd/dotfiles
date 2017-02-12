colorscheme molokai
syntax on

" ###
" ### Cygwin ONLY
" ###
if os=="win"
  " I hate ms fonts.
  set guifont=Ricty\ Diminished\ Discord:h13
  " If the encoding is utf-8, menu bar of gvim will be corrupted.
  " Following statements solve the problem.
  source $VIMRUNTIME/delmenu.vim
  set langmenu=ja_jp.utf-8
  source $VIMRUNTIME/menu.vim
endif

" Customize GUI window
" http://vim.wikia.com/wiki/Hide_toolbar_or_menus_to_see_more_text
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
" set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guioptions-=M
