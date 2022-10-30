#!/bin/bash
# Background: This version of Python3 is required to run Neovim

install_build_environment

# Download python3.8.15
download_file "https://www.python.org/ftp/python/3.8.15/Python-3.8.15.tgz" "Python-3.8.15.tgz"
tar xzf "Python-3.8.15.tgz"
cd "Python-3.8.15" || {
  msg_fail "Failed to change directory to Python-3.8.15"
  exit 1
}

# Build and install python3.8.15 under ~/.local/
./configure --prefix="$HOME/.local"
make -j "$(nproc)"
make install
