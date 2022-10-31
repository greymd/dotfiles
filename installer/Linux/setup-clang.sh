#!/bin/bash
# require: rsync unzip
install_package clang unzip rsync
download_file https://github.com/clangd/clangd/releases/download/15.0.3/clangd-linux-15.0.3.zip clangd-linux-15.0.3.zip
unzip clangd-linux-15.0.3.zip
rsync -av clangd_15.0.3/ "$LOCAL_DIR"
