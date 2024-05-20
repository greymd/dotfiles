#!/bin/bash
if ! has "tmux" ; then
  if ! install_package "tmux"; then
    msg_fail "Failed to install tmux"
    exit 1
  fi
else
  msg_info "tmux is already installed"
fi

TPM_DIR="${HOME}/.tmux/plugins/tpm"
if [[ ! -d "${TPM_DIR}" ]]; then
  download_github_repo "tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"
else
  msg_info "tpm already installed"
fi
