unamestr=$(uname | grep -oiE '(Darwin|CYGWIN|Linux)')

if [[ $unamestr == 'Darwin' ]]; then
  #nvm
  ##source $(brew --prefix nvm)/nvm.sh
  ##nvm use v0.10.35 > /dev/null
  export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
  export ECLIPSE_HOME="/Applications/Eclipse.app/Contents/Eclipse"
elif [[ $unamestr == 'CYGWIN' ]]; then
  # Do nothing for now
  echo "" > /dev/null
elif [[ $unamestr == 'Linux' ]]; then
  # Do nothing for now
  echo "" > /dev/null
  export ECLIPSE_HOME="$HOME/eclipse"
fi

##
## Common Settings
##

# Set default editor as vim not vi. This is used to edit commit message of git.
export EDITOR=vi
if (type vim &> /dev/null) ;then
  export EDITOR=vim
fi

# if [ -e $ECLIPSE_HOME/eclimd ] && [ $(ps alx | grep 'eclimd$' | grep -c .) -eq 0 ]; then
#   nohup $ECLIPSE_HOME/eclimd &
# fi

if [ -e $ECLIPSE_HOME/eclimd ]; then
  alias eclim-start="$ECLIPSE_HOME/eclimd -b &> /dev/null"
  alias eclim-stop="$ECLIPSE_HOME/eclim -command shutdown"
  alias eclim-status='ps alx | grep -q "eclimd$" && echo "eclim is running ("$(ps alx | grep "eclimd$" | cut -d" " -f2)")" || echo "eclim is not unning"'
fi

if (type fasd &> /dev/null) ;then
  eval "$(fasd --init auto)"
fi

_target_path="$HOME/bin"
if [ -e "$_target_path" ]; then
  export PATH="$_target_path:$PATH"
fi

# Activate tmuxvm
[ -e "$HOME/.config/tmuxvm/bin" ] && export PATH="$HOME/.config/tmuxvm/bin:$PATH"

_target_path="$HOME/.config"
if [ -e "$_target_path" ]; then
  # XDG Base Directory for nvim aand so on
  export XDG_CONFIG_HOME="$HOME/.config"
fi

_target_path="$HOME/.go"
if [ -e "$_target_path" ]; then
  export GOPATH="$_target_path"
  export PATH=$GOPATH/bin:$PATH
fi

_target_path="$HOME/.embulk/bin"
if [ -e "$_target_path" ]; then
    export PATH="$PATH:$_target_path"
fi

_target_path="$HOME/.cabal/bin"
if [ -e "$_target_path" ]; then
  export PATH="$PATH:$_target_path"
fi

_target_path="$HOME/.rbenv/bin"
if [ -e "$_target_path" ]; then
  export PATH="$PATH:$_target_path"
fi

_target_path="$HOME/.composer/vendor/bin"
if [ -e "$_target_path" ]; then
  export PATH="$PATH:$_target_path"
fi

_target_path="$HOME/.rbenv"
if [ -e "$_target_path" ]; then
  export PATH="$PATH:$_target_path"
  eval "$(rbenv init - zsh)"
fi

_target_path="$HOME/.egison/bin"
if [ -e "$_target_path" ]; then
  export PATH="$PATH:$_target_path"
fi

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

# _target_path="$HOME/.bluemix/kubeconfig.sh"
# if [ -e "$_target_path" ]; then
#     source "$_target_path"
# fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && [ -n "$BASH_VERSION" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
