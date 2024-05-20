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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/yasyam/.conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/yasyam/.conda/etc/profile.d/conda.sh" ]; then
        . "/Users/yasyam/.conda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/yasyam/.conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export JAVA_TOOLS_OPTIONS="-DLog4j2.formatMsgNoLookups=true"
