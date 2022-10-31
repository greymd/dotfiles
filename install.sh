#!/bin/bash

# Install
# ```
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/greymd/dotfiles/master/install.sh)"
# ```
# inspired by https://github.com/kisqragi/dotfiles/blob/master/install.sh
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/greymd/dotfiles/07fb28498b5ad7420c6390cdda4e300ca026a266/install.sh)"


set -u
shopt -s globstar

readonly REPO_DIR="$HOME/repos"
DOT_DIR="$REPO_DIR/greymd/dotfiles"
readonly LOCAL_DIR="$HOME/.local/"
readonly BIN_DIR="$LOCAL_DIR/bin"

has() {
  for cmd in "$@"; do
    if ! type "${cmd}" > /dev/null 2>&1; then
      return 1
    fi
  done
  return 0
}

msg_info () {
  printf "\r\033[2K\033[0;32m[ \033[0;33m%s\033[0;32m ]\033[0;36m %s\033[0m\n" "INFO" "$1" >&2
}

msg_fail () {
  printf "\r\033[2K\033[0;32m[ \033[0;31m%s\033[0;32m ]\033[0;36m %s\033[0m\n" "ERROR" "$1" >&2
}

msg_warn () {
  printf "\r\033[2K\033[0;32m[ \033[0;33m%s\033[0;32m ]\033[0;36m %s\033[0m\n" "WARN" "$1" >&2
}

# access URL and download file by curl or wget
download_file() {
    local url="$1"
    local file="$2"
    if [ -x "$(command -v curl)" ]; then
        curl -L -o "$file" "$url"
    elif [ -x "$(command -v wget)" ]; then
        wget -O "$file" "$url"
    else
        msg_fail "curl or wget is required"
        return 1
    fi
    return 0
}

download_github_repo () {
    local user_slash_repo="$1"
    local github_repo=${user_slash_repo#*/}
    local dir="${2:-"$REPO_DIR/$user_slash_repo"}"
    local github_tags="${3:-main,master}"
    local github_archive_url=
    local git_success=0
    rm -rf "$dir" # reset to clean old dotfiles
    mkdir -p "$(dirname "$dir")" # ensure parent directory exists
    # if url contains github.com, try to use git command
    if has "git" ; then
      for protocol in https ssh; do
        if [ "$protocol" = "ssh" ]; then
          if ! has "ssh" ; then
            continue
          fi
        fi
        if [ "$protocol" = "https" ]; then
          if ! has "openssl" ; then
            continue
          fi
        fi
        if [ "$protocol" = "ssh" ]; then
          github_archive_url="git@github.com:$user_slash_repo.git"
        else
          github_archive_url="https://github.com/$user_slash_repo.git"
        fi
        for github_tag in $(tr "," " " <<< "$github_tags"); do
          git clone "$github_archive_url" -b "$github_tag" "$dir" && git_success=1 && break
        done
      done
    fi
    # if git command failed, try to use curl or wget
    if ! has "git" || [ "$git_success" -ne 1 ]; then
        for github_tag in $(tr "," " " <<< "$github_tags"); do
            github_archive_url="https://github.com/$user_slash_repo/archive/${github_tag}.tar.gz"
            download_file "$github_archive_url" "${github_tag}.tar.gz"
            if [[ -f "${github_tag}.tar.gz" ]]; then
                tar xf "${github_tag}.tar.gz" || {
                  # failed to extract tar.gz
                  rm -f "${github_tag}.tar.gz"
                  continue
                }
                mv "$github_repo-$github_tag" "$dir"
                rm -f "${github_tag}.tar.gz"
                break
            fi
        done
    fi
}

main() {
  # if this function is called from the file contains "_setup.sh", skip
  if [[ "$0" =~ _setup.sh ]]; then
    return 0
  fi

  msg_info "Create temporary directory"
  tmpdir="/tmp"
  if has "mktemp"; then
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
  fi
  cd "$tmpdir" || {
    msg_fail "Failed to change directory to $tmpdir"
    return 1
  }

  msg_info "Start installing dotfiles..."
  if [[ ! -d "${DOT_DIR}" ]]; then
    download_github_repo "greymd/dotfiles" "${DOT_DIR}"
  else
    msg_info "dotfiles is already installed"
    msg_info "Are you reinstall dotfiles? [y/N]"
    read -r answer
    if [[ "${answer}" != "y" ]]; then
      msg_info "Skip installing dotfiles"
      exit 0
    else
      msg_info "Reinstall dotfiles"
      download_github_repo "greymd/dotfiles" "${DOT_DIR}"
    fi
  fi

  cd "${DOT_DIR}" || {
    msg_fail "cd $DOT_DIR failed"
    exit 1
  }
  for f in .??*
  do
    [[ "$f" == ".DS_Store" ]] && continue
    [[ "$f" == ".git" ]] && continue
    ln -snf "$DOT_DIR"/"$f" "$HOME"/"$f"
    msg_info "Create symlink to $f"
  done

  if [[ ! -d "$BIN_DIR" ]]; then
    msg_info "Creating $BIN_DIR"
    mkdir -p "$BIN_DIR"
  else
    msg_info "$BIN_DIR is already exists"
  fi

  DOT_DIR="$DOT_DIR/installer/$(uname)"
  cd "${DOT_DIR}" || {
    msg_fail "cd $DOT_DIR failed, Unknown OS probably"
    exit 1
  }

  msg_info "Start installing softwares..."
  local all_install=0

  # solve dependency of each installer
  apps=() # app depends on other apps
  app_required=()
  for f in setup-*.sh;
  do
    app_name="${f#setup-}"
    app_name="${app_name%.sh}"
    # get required app_name
    # if the file contains "require:" line, get the app_name
    if grep -q "^# *require:" "$f"; then
      read -r -a requires <<<"$(grep -m 1 "^# *require:" "$f" | sed -e "s/^# *require: *//" | tr -s ' ' | tr ' ' '\n' | awk NF)"
      for rapp in "${requires[@]}"; do
        app_required=("${app_required[@]}" "$app_name $rapp")
      done
    else
      requires=()
      app_required=("${app_required[@]}" "$app_name __none__")
    fi
  done
  # print app_required as new line separated file
  while read -r line; do
    if [[ "$line" != "__none__" ]]; then
      apps=("$line" "${apps[@]}")
    fi
  done < <(for l in "${app_required[@]}";do echo "$l";done | tsort)

  for app_name in "${apps[@]}"
  do
    if [[ "$all_install" -eq 0 ]]; then
      msg_info "Do you install $app_name? [y = yes, n = no, a = all]"
      read -r answer
      if [[ "${answer}" == "n" ]]; then
        msg_info "Skip installing $app_name"
        continue
      elif [[ "${answer}" == "a" ]]; then
        msg_info "Install all apps"
        all_install=1
      fi
    fi
    msg_info "Job: $f"
    if bash -ue _setup.sh "$app_name"; then
      msg_info "Job: $f: OK"
    else
      msg_warn "Job: $f: Failed"
    fi
  done
  msg_info "Finish installing softwares, enjoy."
}

main ${1+"$@"}
