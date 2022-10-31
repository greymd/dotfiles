#!/bin/bash

# Background: This version of Node is required for Copilot
download_github_repo "nvm-sh/nvm" "$HOME/.nvm" || {
  msg_fail "Failed to download nvm-sh/nvm"
  exit 1
}
bash -c 'source $HOME/.nvm/nvm.sh && nvm install v14.18.0'

"$BIN_DIR"/npm i -g bash-language-server
