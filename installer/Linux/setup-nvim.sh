#!/bin/bash
# require: python3 rsync git
#  - git required for vim-plug
#  - python3 python3-pip are required for coc (:pyc)
if ! has nvim; then
    msg_info "nvim not found, installing"
    download_file "https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz" "nvim-linux64.tar.gz"
    tar -xzf nvim-linux64.tar.gz
    rsync -av nvim-linux64/ "$LOCAL_DIR"
else
    msg_info "nvim is already installed"
fi

venv_home="${REPO_DIR}/greymd/dotfiles/venv"
python3 -m venv "$venv_home"
"$venv_home"/bin/pip3 install -U pyvim
"$venv_home"/bin/pip3 install -U neovim

pip3 install -U neovim

plugdir="$HOME/.local/share/nvim/site/autoload/"
if [[ ! -d "$plugdir" ]] || [[ ! -e "$plugdir/plug.vim" ]] ; then
  mkdir -p "$plugdir"
  download_file "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" "$plugdir/plug.vim"
  "$BIN_DIR"/nvim -c ':PlugInstall | :q! | :q!'
fi
