#!/bin/bash
# the directory where the script is located
readonly SCRIPT_DIR="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
# shellcheck source=/dev/null
. "${SCRIPT_DIR}/../../install.sh"

# install package per platform (rpm-base or apt-base)
install_package() {
    local package="$1"
    if [ -x "$(command -v apt)" ]; then
        sudo apt install -y "$package"
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y "$package"
    else
        msg_fail "Unsupported platform"
        return 1
    fi
    return 0
}

# create a temporary directory
tmpdir="/tmp"
if has "mktemp"; then
  tmpdir="$(mktemp -d)"
  # remove the temporary directory when the script exits
  trap 'rm -rf -- "${tmpdir}"' EXIT
fi
software="$1"
{
  cd "$tmpdir" || {
    msg_warn "$software: Failed to change directory"
    exit 1
  }
  # shellcheck source=/dev/null
  source "${SCRIPT_DIR}"/setup-"$software".sh
}
