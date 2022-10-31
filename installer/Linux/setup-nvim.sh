#!/bin/bash
if ! has nvim; then
    msg_info "nvim not found, installing"
    download_file "https://github.com/neovim/neovim/releases/download/v0.6.1/nvim-linux64.tar.gz" "nvim-linux64.tar.gz"
    tar -xzf nvim-linux64.tar.gz
    install_package rsync
    rsync -av nvim-linux64/ "$LOCAL_DIR"
else
    msg_info "nvim is already installed"
fi

install_package "git" # required for vim-plug
install_package "python3" # required for coc (:pyc)
pip3 install -U neovim

plugdir="$HOME/.local/share/nvim/site/autoload/"
if [[ ! -d "$plugdir" ]] || [[ ! -e "$plugdir/plug.vim" ]] ; then
  mkdir -p "$plugdir"
  download_file "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "$plugdir/plug.vim"
  "$BIN_DIR"/nvim -c ':PlugInstall | :q! | :q!'
fi
