#!/bin/bash
COMMIT_HASH="d2f3b51f56f004754d35fe61e4787c04e0a354da"
TARBALL="https://github.com/ShellShoccar-jpn/Parsrs/archive/$COMMIT_HASH.tar.gz"
download_file "${TARBALL}" "Parsrs-$COMMIT_HASH.tar.gz"
tar -zxvf "Parsrs-$COMMIT_HASH.tar.gz"
for f in "Parsrs-${COMMIT_HASH}"/*.sh;do
  cp "$f" "$BIN_DIR/$(basename "${f%.sh}")"
  msg_info "Installed $(basename "${f%.sh}")"
done
rm -rf "Parsrs-${COMMIT_HASH}"
rm "Parsrs-$COMMIT_HASH.tar.gz"
