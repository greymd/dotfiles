#!/bin/bash
# the directory where the script is located
readonly SCRIPT_DIR="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
# shellcheck source=/dev/null
. "${SCRIPT_DIR}/../../install.sh"

# install package per platform (rpm-base or apt-base)
install_package() {
  if [ -x "$(command -v brew)" ]; then
    brew install "$@"
  else
    msg_fail "brew is not installed platform"
    return 1
  fi
  return 0
}

npm_global_install () {
  _node_version="$HOME/.nvm/alias/default"
  if [ -s "$_node_version" ];then
    local node_bindir=
    node_bindir="$HOME/.nvm/versions/node/$(cat "$_node_version")/bin"
    "$node_bindir"/node "$node_bindir"/npm install -g "$@"
  fi
}

# create a temporary directory
setup_tmpdir="/tmp"
if has "mktemp"; then
  setup_tmpdir="$(mktemp -d)"
  # remove the temporary directory when the script exits
  trap 'rm -rf -- "${setup_tmpdir}"' EXIT
fi
software="$1"
{
  cd "$setup_tmpdir" || {
    msg_warn "$software: Failed to change directory"
    exit 1
  }
  # shellcheck source=/dev/null
  source "${SCRIPT_DIR}"/setup-"$software".sh
}
