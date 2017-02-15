source "$HOME/.profile"

_target_path="$HOME/.zsh/completion"
if [ -e "$_target_path" ]; then
    fpath=("$_target_path" $fpath)
fi
