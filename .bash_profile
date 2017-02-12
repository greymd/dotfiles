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
fi

##
## Common Settings
##

# Set default editor as vim not vi. This is used to edit commit message of git.
export EDITOR=vi
if (type vim &> /dev/null) ;then
  export EDITOR=vim
fi

if [ -e $ECLIPSE_HOME/eclimd ] && [ $(ps alx | grep 'eclimd$' | grep -c .) -eq 0 ]; then
  nohup $ECLIPSE_HOME/eclimd &
fi

if (type fasd &> /dev/null) ;then
  eval "$(fasd --init auto)"
fi

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

_target_path="$HOME/bin"
if [ -e "$_target_path" ]; then
  export PATH="$PATH:$_target_path"
fi

_target_path="$HOME/.rbenv"
if [ -e "$_target_path" ]; then
  export PATH="$PATH:$_target_path"
  eval "$(rbenv init -)"
fi

_target_path="$HOME/.egison/bin"
if [ -e "$_target_path" ]; then
  export PATH="$PATH:$_target_path"
fi

