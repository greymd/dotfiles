#!/bin/bash
download_github_repo "nvm-sh/nvm" "$HOME/.nvm" || {
  msg_fail "Failed to download nvm-sh/nvm"
  exit 1
}
bash -c 'source $HOME/.nvm/nvm.sh && nvm install v14.18.0'
