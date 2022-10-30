#!/bin/bash
if [[ ! -f "$BIN_DIR/xpanes" ]] && ! has "xpanes"; then
  download_file "https://raw.githubusercontent.com/greymd/tmux-xpanes/master/bin/xpanes" "$BIN_DIR/xpanes"
  chmod +x "$BIN_DIR/xpanes"
else
  msg_info "xpanes already installed"
fi
