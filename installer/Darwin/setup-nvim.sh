#!/bin/bash
# require: python3 rsync git
#  - git required for vim-plug
#  - python3 python3-pip are required for coc (:pyc)
if ! has nvim; then
    msg_info "nvim not found, installing"
    install_package nvim
else
    msg_info "nvim is already installed"
fi

pip3 install -U neovim

plugdir="$HOME/.local/share/nvim/site/autoload/"
if [[ ! -d "$plugdir" ]] || [[ ! -e "$plugdir/plug.vim" ]] ; then
  mkdir -p "$plugdir"
  download_file "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "$plugdir/plug.vim"
  "$BIN_DIR"/nvim -c ':PlugInstall | :q! | :q!'
fi
