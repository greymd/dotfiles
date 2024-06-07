#!/bin/bash
install_package "tmux"

TPM_DIR="${HOME}/.tmux/plugins/tpm"
if [[ ! -d "${TPM_DIR}" ]]; then
  download_github_repo "tmux-plugins/tpm" "${HOME}/.tmux/plugins/tpm"
else
  msg_info "tpm already installed"
fi
