export __GRE_REPOSITORY_DIR="$HOME/repos"

# --------------------
# Bash completion
# --------------------
if [ -f "${__GRE_REPOSITORY_DIR}/scop/bash-completion/bash_completion" ] && [ -n "$BASH_VERSION" ]; then
  . ${__GRE_REPOSITORY_DIR}/scop/bash-completion/bash_completion
fi

export PATH="$HOME/.cargo/bin:$PATH"
export PS1="\W \$ "
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
