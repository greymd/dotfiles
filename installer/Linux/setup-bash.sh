#!/bin/bash
# require: node

_node_version="$HOME/.nvm/alias/default"
if [ -s "$_node_version" ];then
  "$HOME/.nvm/versions/node/$(cat "$_node_version")/bin"/npm i -g bash-language-server
fi

if [[ "$(uname -i)" != "x86_64" ]]; then
    msg_info "shellcheck is only for x86_64 architecture"
    exit 0
fi
download_file "https://github.com/koalaman/shellcheck/releases/download/v0.8.0/shellcheck-v0.8.0.linux.x86_64.tar.xz" shellcheck-v0.8.0.linux.x86_64.tar.xz
tar -xf shellcheck-v0.8.0.linux.x86_64.tar.xz
mv shellcheck-v0.8.0/shellcheck "$BIN_DIR"/shellcheck
