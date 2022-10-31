#!/bin/bash
# require: rsync
# if the architecture is not x86_64, then exit
if [[ "$(uname -i)" != "x86_64" ]]; then
    msg_info "teip is only for x86_64 architecture"
    exit 0
fi
if has "teip"; then
  msg_info "teip already installed"
  exit 0
fi

install_package rsync

# download the latest version of teip
download_file "https://github.com/greymd/teip/releases/download/v2.0.0/teip-2.0.0.x86_64-unknown-linux-musl.tar.gz" "teip-2.0.0.x86_64-unknown-linux-musl.tar.gz"
tar -xvf teip-2.0.0.x86_64-unknown-linux-musl.tar.gz
rsync -av ./bin "$LOCAL_DIR/bin"
mkdir -p "$LOCAL_DIR/share/man/man1"
rsync -av ./man "$LOCAL_DIR/share/man/man1"
rsync -av ./completion "$DOT_DIR/.zsh/completion"
rm teip-2.0.0.x86_64-unknown-linux-musl.tar.gz
