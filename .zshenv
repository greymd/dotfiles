# zmodload zsh/zprof && zprof

_target_path="$HOME/.zsh/completion"
if [ -e "$_target_path" ]; then
    fpath+="$_target_path"
fi

autoload -U compdef
source "$HOME/.profile"
# source "$HOME/.cargo/env"
