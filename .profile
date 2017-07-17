export __GRE_REPOSITORY_DIR="$HOME/reps"

# --------------------
# Bash completion
# --------------------
if [ -f "${__GRE_REPOSITORY_DIR}/scop/bash-completion/bash_completion" ] && [ -n "$BASH_VERSION" ]; then
  . ${__GRE_REPOSITORY_DIR}/scop/bash-completion/bash_completion
fi
