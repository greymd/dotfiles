#!/bin/bash
# the directory where the script is located
readonly SCRIPT_DIR="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
# shellcheck source=/dev/null
. "${SCRIPT_DIR}/../../install.sh"
# create a temporary directory
readonly TMP_DIR="$(mktemp -d)"
software="$1"
# remove the temporary directory when the script exits
trap 'rm -rf -- "${TMP_DIR}"' EXIT
{
  cd "$TMP_DIR" || {
    msg_warn "$software: Failed to change directory"
    exit 1
  }
  # shellcheck source=/dev/null
  source "${SCRIPT_DIR}"/setup-"$software".sh
}
