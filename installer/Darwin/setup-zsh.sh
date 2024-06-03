#!/bin/bash
# require: git
# to use zsh plugin managers, git is mandatory
if ! has "zsh"; then
  if ! install_package "zsh"; then
      msg_fail "Failed to install zsh"
      exit 1
  fi
else
  msg_info "zsh is already installed"
fi