#!/bin/bash
# require: git
# to use antigen, git is mandatory
if ! has "zsh"; then
  if ! install_package "zsh"; then
      msg_fail "Failed to install zsh"
      exit 1
  fi
else
  msg_info "zsh is already installed"
fi

# if [[ ! -d "$REPO_DIR"/zsh-users/antigen ]]; then
#   msg_info "Cloning antigen"
#   download_github_repo "zsh-users/antigen"
# else
#   msg_info "Antigen already cloned"
# fi

## if .zshrc exists
if [[ -f "$HOME"/.zshrc ]]; then
    msg_info "Found .zshrc, install antigen"
    zsh --rcs "$HOME"/.zshrc -c 'antigen-update'
fi
