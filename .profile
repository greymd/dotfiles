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

[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

__add_path () {
  local _target_path="$1"
  if [ -e "$_target_path" ]; then
    export PATH="$PATH:$_target_path"
  fi
}
# if [ -e $ECLIPSE_HOME/eclimd ] && [ $(ps alx | grep 'eclimd$' | grep -c .) -eq 0 ]; then
#   nohup $ECLIPSE_HOME/eclimd &
# fi

if [ -e $ECLIPSE_HOME/eclimd ]; then
  ECLIMPS="org.eclim.applicatio[n]"
  alias eclim-start="$ECLIPSE_HOME/eclimd -b &> /dev/null"
  alias eclim-stop="$ECLIPSE_HOME/eclim -command shutdown"
  alias eclim-status='ps alx | grep -qE "'$ECLIMPS'" && echo "eclim is running ("$(ps alx | grep -E "'$ECLIMPS'" | cut -d" " -f2)")" || echo "eclim is not unning"'
fi

if (type fasd &> /dev/null) ;then
  eval "$(fasd --init auto)"
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

_target_path="$HOME/.rbenv"
if [ -e "$_target_path" ]; then
  export PATH="$PATH:$_target_path"
  eval "$(rbenv init - zsh)"
fi

__add_path "$HOME/bin"
__add_path "/usr/games/bin"
__add_path "$HOME/.embulk/bin"
__add_path "$HOME/.cabal/bin"
__add_path "$HOME/.rbenv/bin"
__add_path "$HOME/.composer/vendor/bin"
__add_path "$HOME/.egison/bin"
# __add_path "/usr/local/opt/icu4c/bin"
# __add_path "/usr/local/opt/icu4c/sbin"
__add_path "/usr/local/Cellar/node/8.1.3/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && [ -n "$BASH_VERSION" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
