#!/bin/bash
# the directory where the script is located
readonly SCRIPT_DIR="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
# shellcheck source=/dev/null
. "${SCRIPT_DIR}/../../install.sh"

# install package per platform (rpm-base or apt-base)
install_package() {
  if [ -x "$(command -v apt)" ]; then
    sudo apt install -y "$@"
  elif [ -x "$(command -v yum)" ]; then
    sudo yum install -y "$@"
  else
    msg_fail "Unsupported platform"
    return 1
  fi
  return 0
}

# install packages necessary for build enviornmnent (zlib is required for building python3)
install_build_environment() {
  if [ -x "$(command -v apt)" ]; then
    install_package build-essential zlib1g-dev
  elif [ -x "$(command -v yum)" ]; then
    install_package gcc gcc-c++ make zlib-devel
  else
    msg_fail "Unsupported platform"
    return 1
  fi
  return 0
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
