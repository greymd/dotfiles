#!/bin/bash
# if the architecture is not x86_64, then exit
if [[ "$(uname -i)" != "x86_64" ]]; then
    msg_info "This script is only for x86_64 architecture"
    exit 0
fi
download_file "https://github.com/monochromegane/the_platinum_searcher/releases/download/v2.1.5/pt_linux_amd64.tar.gz" pt_linux_amd64.tar.gz
tar zxvf pt_linux_amd64.tar.gz
cp pt_linux_amd64/pt "$BIN_DIR/pt"
rm -rf pt_linux_amd64.tar.gz pt_linux_amd64
