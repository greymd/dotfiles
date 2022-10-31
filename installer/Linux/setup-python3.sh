#!/bin/bash
# Background: This version of Python3 is required to run Neovim

install_build_environment

# Install openssl
{
  download_file "https://www.openssl.org/source/openssl-1.1.1g.tar.gz"
  tar -xzf openssl-1.1.1g.tar.gz
  cd "openssl-1.1.1g" || {
    msg_fail "Failed to cd into openssl-1.1.1g"
    exit 1
  }
  ./config --prefix="$LOCAL_DIR" --openssldir="$LOCAL_DIR"/openssl
  make -j "$(nproc)"
  make install
}

# Install Python3
{
  download_file "https://www.python.org/ftp/python/3.8.15/Python-3.8.15.tgz" "Python-3.8.15.tgz"
  tar xzf "Python-3.8.15.tgz"
  cd "Python-3.8.15" || {
    msg_fail "Failed to change directory to Python-3.8.15"
    exit 1
  }
  # Build and install python3.8.15 under ~/.local/
  ./configure --prefix="$LOCAL_DIR" --with-openssl="$LOCAL_DIR"/openssl
  make -j "$(nproc)"
  make install
}
