USER_BIN="$HOME/bin"
SKEL_PROJECT_DIR="$HOME/.zsh/project-skel/"

export HISTSIZE=1000000
export HISTFILESIZE=1000000
export SAVEHIST=1000000
export TMUX_XPANES_PANE_BORDER_FORMAT="#[bg=green,fg=black] #T#{?pane_pipe,[Log],} #[default]"

# __GRE_REPOSITORY_DIR environment variable is defined on .profile.
export PS1="\W \$ "

if [ -s "$HOME/.local.bash" ]; then
    source "$HOME/.local.bash"
fi

###################################
#### Depending on the platform ####
###################################
unamestr=$(uname | grep -oiE '(Darwin|CYGWIN|Linux)')

if [[ $unamestr == 'Darwin' ]]; then
  VIMPATH="/Applications/MacVim.app/Contents/MacOS"
  alias ls='ls -G' #BSD version ls
  alias updatedb='sudo /usr/libexec/locate.updatedb'
  alias egison-euler="egison -l $__GRE_REPOSITORY_DIR/project-euler/lib/math/project-euler.egi -l $__GRE_REPOSITORY_DIR/prime-numbers/lib/math/prime-numbers.egi"
  alias p='pbcopy'
  alias factor='gfactor'
  alias shuf='gshuf'
  alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
  alias vscode="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
  alias vlc="/Applications/VLC.app/Contents/MacOS/VLC"
  export ECLIPSE_HOME="$HOME/eclipse"

  mplayx () {
    kill $(pgrep MPlayerX)
    /Applications/MPlayerX.app/Contents/MacOS/MPlayerX "$PWD/$1"
  }

  cdf () {
      target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
      if [ "$target" != "" ]
      then
          cd "$target"
          pwd
      else
          echo 'No Finder window found' >&2
      fi
  }

  mdrg()
  {
    mdfind -onlyin "$(pwd)" "$@" | gxargs -P0 -I '_PH_' grep -inH --color=always "$@" "_PH_"
  }

  mdpwd(){
    mdfind -onlyin $(pwd) "(kMDItemDisplayName == '*')"
  }

  alias nvim='TERM=xterm-256color nvim'

  gvim(){
    ${VIMPATH}/Vim -g "$@"
  }

  janken () {
    say -v Kyoko "じゃん！けん！" && echo emspect" ":{punch,v,wave}: | xargs -n 2 | gshuf | head -n 1 | awk '$0=$0" --format \"%C\""' | sh && say -v Kyoko "ぽん！"
  }

  attimuite () {
    num=${1:-1}
    say -v Kyoko "あっちむいて"
    for i in $(seq 1 $num) ; do
      emspect -n POINTING -n TYPE | grep -o '^.' | gshuf | head -n 1
      say -v Kyoko "ほい！"
    done
  }

  # Maven for specific settings
  gmvn(){
    mvn --settings $HOME/.m2/g_settings.xml "$@"
  }

  unix2time () {
    gdate -d "@$1" +%Y-%m-%d_%H:%M:%S
  }

  time2unix () {
    gdate -d $1 +%s
  }

elif [[ $unamestr == 'CYGWIN' ]]; then
  VIMPATH="/cygdrive/c/vim74-kaoriya-win64"
  alias ls='ls --color=auto' #GNU version ls
  gvim(){
    $VIMPATH/gvim.exe $(cygpath -aw $*) &
  }
elif [[ $unamestr == 'Linux' ]]; then
  alias ls='ls --color=auto' #GNU version ls
  export ECLIPSE_HOME="$HOME/eclipse"
fi

#--------------------
# Editor
#--------------------
# Set default editor as vim not vi. This is used to edit commit message of git.
export EDITOR=vi
if (type vim &> /dev/null) ;then
  export EDITOR=vim
fi

#--------------------
# Aliases
#--------------------
alias l='ls -CF'
alias ll='ls -al'
alias grep='grep --color=auto'
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias g='git'
alias gr='grep'
alias gm='git commit -m '

#remove control character
alias rmcc='perl -pe '"'"'s/\e([^\[\]]|\[.*?[a-zA-Z]|\].*?\a)//g'"'"' | col -b'
alias rmccal='ls *.log | while read f;do cat "$f" | rmcc > /tmp/tmpfile && cat /tmp/tmpfile > "$f" ;done && rm /tmp/tmpfile'

#git add modified files
alias git-add-modified='git ls-files -m | sed "s/^/git add /"'
alias up="cd ..; ls"

alias psum='tr "\n" " " | perl -anle "print eval join \"+\", @F"'
# alias psum="dc -f- -e'[+z1<r]srz1<rp"

# SSL dump alias
# usage $ ssl-client url:port
alias ssld-webcert='openssl s_client -showcerts -connect'
alias ssld-crt='openssl x509 -text -noout -in'
alias ssld-cer='openssl x509 -text -noout -in'
alias ssld-key='openssl rsa -text -noout -in'
alias ssld-csr='openssl req -text -noout -in'
# usage $ ssl-cacert-dump filename
alias ssld-cacert='keytool -v -list -storepass changeit -keystore'
alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
# alias pt='pt -i'

# Ref: http://qiita.com/greymd/items/ad18aa44d4159067a627
alias pict-format="column -s$'\t' -t | tee >(sed -n '1,1p') | sed '1,1d' | sort"
alias h2-cli='java -cp /Applications/h2/bin/h2-1.4.191.jar org.h2.tools.Shell -url jdbc:h2:./data -user sa'
alias 蒸着="sudo -s"
alias octave='octave --no-gui'

alias terminal-slack="node ${HOME}/repos/evanyeung/terminal-slack/main.js"

#--------------------
# Update PATH variable
#--------------------
__add_path () {
  if [ -e "$1" ]; then
    export PATH="$1:${PATH}"
  fi
}

_target_path="$HOME/.config"
if [ -e "$_target_path" ]; then
  # XDG Base Directory for nvim and so on
  export XDG_CONFIG_HOME="$HOME/.config"
fi

#--------------------
# Import various commands
#--------------------
__add_path "$HOME/bin"
__add_path "$HOME/.config/tmuxvm/bin" # Activate tmuxvm
__add_path "$HOME/.embulk/bin"
__add_path "$HOME/.cabal/bin"
__add_path "$HOME/.composer/vendor/bin"
__add_path "$HOME/.egison/bin"
__add_path "$HOME/.nodebrew/current/bin"
__add_path "/usr/games" # For Ubuntu
__add_path "/usr/local/sbin"
__add_path "/usr/local/opt/icu4c/bin"
__add_path "/usr/local/opt/icu4c/sbin"

# __add_path "/usr/local/opt/coreutils/libexec/gnubin"

#--------------------
# Go
#--------------------
_target_path="$HOME/.go"
if [ -e "$_target_path" ]; then
  export GOPATH="$_target_path"
  export GOBIN="$_target_path/bin"
  export PATH="$GOPATH/bin:$PATH"
else
  _target_path="$HOME/go"
  if [ -e "$_target_path" ]; then
    export GOPATH="$_target_path"
    export GOBIN="$_target_path/bin"
    export PATH="$GOPATH/bin:$PATH"
  fi
fi

#--------------------
# Python
#--------------------
export PYENV_ROOT="$HOME/.pyenv"
__add_path "$PYENV_ROOT/bin"

# pyenv lazy-load
pyenv () {
  unset -f pyenv
  eval "$(pyenv init -)"
  pyenv "$@"
}

#--------------------
# PHP
#--------------------
[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

#--------------------
# Ruby
#--------------------
__add_path "$HOME/.rbenv/bin"
__add_path "$HOME/.rbenv/shims"

# lazy load for rbenv
rbenv () {
  unset -f rbenv
  eval "$(rbenv init - $(basename $SHELL))"
  rbenv "$@"
}

#--------------------
# Node.js
#--------------------
_node_version="$HOME/.nvm/alias/default"
if [ -s "$_node_version" ];then
  __add_path "$HOME/.nvm/versions/node/$(cat $_node_version)/bin"
fi

# nvm command lasy-load
nvm() {
    unset -f nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && [ -n "$BASH_VERSION" ] && . "$NVM_DIR/bash_completion"
    nvm "$@"
}

#--------------------
# Java
#--------------------
alias jrepl="java -jar $HOME/bin/javarepl-dev.build.jar"

export JAVA_HOME="$HOME/.sdkman/candidates/java/current/"
__add_path "$HOME/.sdkman/candidates/java/current/bin"
__add_path "$HOME/.sdkman/candidates/maven/current/bin"
__add_path "$HOME/.sdkman/candidates/ant/current/bin"
__add_path "$HOME/.sdkman/candidates/gradle/current/bin"

jex () {
  javac $1 && java ${1%.java}
}

_jshell () {
  "$HOME/.sdkman/candidates/java/9.0.0-zulu/bin//jshell" "$@"
}

jshell () {
  local _opts=
  local _tmpfile="${TMPDIR:-/tmp}/imports"
  if [[ -s "${PWD}/.classpath" ]]; then
    # Load jar files.
    _opts="$_opts --class-path $(cat "${PWD}/.classpath" | grep -Po 'classpathentry sourcepath.* path="\K[^"]*(?=")' | sort | uniq | tr '\n' ':' | sed 's/:$//')"
  fi

# Load all the import statement under src directory.
# Behavior is unstable and it is temporarily disabled.
  if [[ -e "${PWD}/src" ]]; then
    find ${PWD}/src -type f | grep 'java$' | xargs cat | grep '^import .*;' | sort | uniq > "$_tmpfile"
    _opts="$_opts --startup $_tmpfile"
  fi

  if [[ -n "$_opts" ]];then
    _jshell $_opts "$@"
  else
    _jshell "$@"
  fi
}

jarls () {
  if [[ -s "${PWD}/.classpath" ]]; then
    cat "${PWD}/.classpath" | grep -Po 'classpathentry sourcepath.* path="\K[^"]*(?=")' | sort | uniq
  else
    echo ".class file does not exist." >&2
  fi
}

# lazy load for sdkman
SDKMAN_DIR="$HOME/.sdkman"
sdk () {
  unset -f sdk
  _target_path="$SDKMAN_DIR/bin/sdkman-init.sh"
  if [ -s "$_target_path" ];then
    source "$_target_path"
    sdk "$@"
  else
    echo 'sdkman is not found.' 1>&2
  fi
}

mvn-instant() {
  local _name=${1:-$(faker-cli --hacker noun | tr -d '[ "]')}
  local _artifactId=$(echo $_name | sed 's/^./\U&/')
  yes $'\n' | gmvn archetype:generate -DgroupId=com.$_name -DartifactId=$_artifactId
    cd $_artifactId
  # mkdir -p $_artifactId/src/resources
  # touch $_artifactId/src/resources/application.properties
  # Build: gmvn eclipse:eclipse && gmvn install
  # Run: java -cp target/CapacitorSample-1.0-SNAPSHOT.jar com.name.App
}

mvn-springboot() {
    local _name=${1:-$(faker-cli --hacker noun | tr -d '[ "]')}
    local _groupId=com.$_name
    local _artifactId=$(echo $_name | sed 's/^./\U&/')
    cp -r "$SKEL_PROJECT_DIR/java/spring-boot/maven-spring-boot-jersey" .
    mv ./maven-spring-boot-jersey ./$_name
    cd ./$_name
    mv "src/main/java/"{@@@NAME@@@,$_name}
    mv "src/test/java/"{@@@NAME@@@,$_name}
    find . -type f -print0 | xargs -0 -n1 -I{} sed -i "s/@@@NAME@@@/$_name/" {}
    find . -type f -print0 | xargs -0 -n1 -I{} sed -i "s/@@@GROUP_ID@@@/$_name/" {}
    find . -type f -print0 | xargs -0 -n1 -I{} sed -i "s/@@@ARTIFACT_ID@@@/$_artifactId/" {}
}

pom-jars () {
    cat pom.xml \
      | perl -anle 'print if /dependencies/../\/dependencies/' \
      | grep -Po '<(groupId|artifactId|version)>\K.*(?=</\1>)' \
      | xargs -n 3 \
      | perl -anpe '$F[0]=~s|\.|/|g; $_="$F[0]/$F[1]/$F[2]/.*\\.jar\$\n"' \
      | grep -Ef - <(find ${HOME}/.m2/g_repository)
}

mvn-exe() {
    java -Dfile.encoding=UTF-8 -cp $(find target | grep 'jar$'):$(pom-jars | xargs | tr ' ' ':') $(grep -r 'public static void main' * | awk -F: '$0=$1' | sed 's|/|.|g' | perl -anle '/^.*java\.\K.*(?=\.java)/ and print $&')
}

gradle-instant () {
    local _name=${1:-$(faker-cli --hacker noun | tr -d '[ "]')}
    local _artifactId=$(echo $_name | sed 's/^./\U&/')
    mkdir $_artifactId
    cd $_artifactId
    gradle init --type java-library
    echo "
apply plugin: 'eclipse'
apply plugin: 'idea'
task execute(type:JavaExec) {
    main = 'Library'
    classpath = sourceSets.main.runtimeClasspath
}

test {
    testLogging.showStandardStreams = true
}

jar {
  doFirst {
    from { configurations.compile.collect { it.isDirectory() ? it : zipTree(it) } }
  }
  exclude 'META-INF/*.RSA', 'META-INF/*.SF','META-INF/*.DSA'
  manifest {
    attributes 'Main-Class': 'Library'
  }
  from {
    configurations.compile.collect { it.isDirectory() ? it : zipTree(it) }
  }
}
" >> build.gradle
    sed -i 's/public class Library {/\0\n    public static void main(String args[]) {\n        System.out.println("Hello, World!");\n    }/' src/main/java/Library.java
    # After that, run
    # gradle eclipse
    # gradle execute or gradle -PmainClass=???
    gradle execute
}

gradle-springboot () {
    local _name=${1:-$(faker-cli --hacker noun | tr -d '[ "]')}
    local _groupId=com.$_name
    local _artifactId=$(echo $_name | sed 's/^./\U&/')
    cp -r "$SKEL_PROJECT_DIR/java/spring-boot/gradle-spring-boot-jersey" .
    mv ./gradle-spring-boot-jersey ./$_name
    cd ./$_name
    mv "src/main/java/"{@@@NAME@@@,$_name}
    mv "src/test/java/"{@@@NAME@@@,$_name}
    find . -type f -print0 | xargs -0 -n1 -I{} sed -i "s/@@@NAME@@@/$_name/" {}
    find . -type f -print0 | xargs -0 -n1 -I{} sed -i "s/@@@GROUP_ID@@@/$_name/" {}
    find . -type f -print0 | xargs -0 -n1 -I{} sed -i "s/@@@ARTIFACT_ID@@@/$_artifactId/" {}
    # Build: gradle build && gradle eclipse
    # Run: gradle bootRun
    # RunTest: gradle test
}

gradle-test () {
  local _case="${1}"
  if [ -z "$_case" ]; then
    gradle test --tests "*"
  else
    local _args=($(echo "$@" | xargs -n 1 | sed 's/^/--tests */'))
    gradle test "${_args[@]}"
  fi
}

javadoc-src () {
  javadoc -d "$(pwd)/html" -sourcepath "$(pwd)/src/main/java/" -subpackages .
}

#--------------------
# Eclipse
#--------------------
if [ -e $ECLIPSE_HOME/eclimd ]; then
  alias eclim-screen='if ( type Xvfb &> /dev/null ) && ! ( ps alx | grep -wq "[X]vfb" ) ;then nohup Xvfb :1 -screen 0 1024x768x24 &> /dev/null & fi'
fi

if (type fasd &> /dev/null) ;then
  eval "$(fasd --init auto)"
fi


#--------------------
# Docker
#--------------------
alias docker-cure="docker run -e LANG=ja_JP.UTF-8 -it --rm cureutils/ruby2.2.0 cure"
alias dockviz="docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz"

# For Bash on Windows
#  if (grep -q Microsoft /proc/version 2> /dev/null ) ;then
#    # alias docker="docker -H tcp://localhost:2375 --tlsverify --tlscacert /mnt/c/Users/$USER/.docker/machine/certs/ca.pem  --tlscert /mnt/c/Users/$USER/.docker/machine/certs/cert.pem --tlskey /mnt/c/Users/$USER/.docker/machine/certs/key.pem"
#    alias docker="docker -H tcp://localhost:2375"
#  fi

docker-clean () {
  docker ps -a -q | xargs docker rm
}

docker-rmnone() {
  docker images --filter "dangling=true" -q | xargs docker rmi
}

docker-killall () {
  docker ps -q | xargs docker kill
}

docker-ex () {
    docker exec -it "$1" sh
}

docker-dev () {
  local _cmd='/bin/zsh -c "tmux -2"'
  local _opts="-it greymd/dev"
  if [[ "$1" =~ b ]]; then
    ## bash mode
    _cmd='/bin/bash'
  fi
  if [[ "$1" =~ v ]]; then
    ## mounting volume
    # Mount current volume
    _opts="-v ${PWD}:/work ${_opts}"
  fi
  if [[ "$1" =~ j ]]; then
    # Java mode
    # _cmd='nohup Xvfb :1 -screen 0 1024x768x24 &> /dev/null & /home/docker/eclipse/eclimd -b &> /dev/null && tmux -2'
    _cmd='/bin/zsh -c "nohup Xvfb :1 -screen 0 1024x768x24 &> /dev/null & tmux -2"'
  fi
  if [[ "$1" =~ m ]]; then
    # import maven
    # Import Maven settings
    _opts="-v $HOME/.m2:/home/docker/.m2 ${_opts}"
  fi
  if [[ "$1" =~ s ]]; then
    # Import SSH settings
    _opts="-v $HOME/.ssh:/home/docker/.ssh ${_opts}"
  fi
  ## Allow to use strace
  _opts="--security-opt seccomp:unconfined ${_opts}"
  echo "command: docker run $_opts $_cmd"
  eval "docker run $_opts $_cmd"
}

docker-ubuntu () {
  docker run -it --rm ubuntu:16.04 /bin/bash
  # apt-get -y update && apt-get -y install curl
}

docker-php () {
  docker run -d -p 8080:80 -v "$(pwd)":/var/www/html php:7.0-apache
}

runche() {
  docker run -ti -e CHE_DOCKER_MACHINE_HOST=192.168.99.100 --net=host -v /var/run/docker.sock:/var/run/docker.sock -v /home/user/che/lib:/home/user/che/lib-copy -v /home/user/che/workspaces:/home/user/che/workspaces -v /home/user/che/tomcat/temp/local-storage:/home/user/che/tomcat/temp/local-storage codenvy/che
}

docker-mock () {
  docker run -it -p 80:80 centos5-base/httpd /bin/bash
}


#--------------------
# TeX settings
#--------------------
deltex(){
  rm -f ${1%.tex}.aux
  rm -f ${1%.tex}.log
  rm -f ${1%.tex}.out
  #rm ${1%.tex}.dvi
  rm -f ${1%.tex}.toc
}

tex2pdf(){
  platex ${1%.tex} && \
  platex ${1%.tex} && \
  dvipdfmx -d 5 ${1%.tex} && \
  deltex ${1%.tex} && \
  open ${1%.tex}.pdf
}

tex2dvi(){
  platex ${1%.tex} && \
  platex ${1%.tex} && \
  xdvi ${1%.tex}.dvi
}

#--------------------
# Original functions
#--------------------
yes () {
  echo "$@" | grep -qiE '^(precure|プリキュア)'
  if [ $? = 0 ]; then
    $HOME/.cabal/bin/yes "$@"
  else
    /usr/bin/yes "$@"
  fi
}

swap()
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

jj () {
    if [ $1 ]; then
        JUMPDIR=$(find . -type d -maxdepth 1 | grep $1 | tail -1)
        if [[ -d $JUMPDIR && -n $JUMPDIR ]]; then
            cd $JUMPDIR
        else
            echo "directory not found"
        fi
    fi
}

express-init() {
  express -e $1
}

ptt(){
  pt -i --color -C 2 "$@" $(pwd) | \
  sed -r 's/\[K//g' | \
  sed -E 's/:(\[1;33m.+\[0m)/:\n\1/g' | \
  sed -E 's/^--$//g' | \
  sed -E 's/^\[1;32m.+\[0m:$/\n\0/g' | \
  sed -n -E '/^$/{p;n;/^$/{d}};/^$/!{p}' | \
  sed -E 's/^(\[1;32m)(.+)(\[0m:)$/\1 \2 \3/'
}

pt-less(){
  ptt "$@" | less -R
}
pt-vim(){
  ptt "$@" | vim -c '%!nkf' -c ':AnsiEsc' -c ':w `=tempname()`' -
}
pt-gvim(){
  ptt "$@" | gvim -c '%!nkf' -c ':AnsiEsc' -c ':w `=tempname()`' -
}

# Open multiple files with vim from pt result.
pt-xpanes(){
  type xpanes &> /dev/null
  if [ $? -ne 0 ]; then
    echo "xpanes is required" >&2
    return 1
  fi
  awk -F: '{print $1,$2}' \
    | awk '{a[$1]=a[$1]" "$2}END{for(k in a){print k,a[k]}}' \
    | awk '{printf "vim"; for(i=2;i<=NF;i++){printf " -c \":norm G"$i"G\" "$1;} print "; exit"}' \
    | xpanes -e
}

rgrep-vis()
{
  ESC=$'\x1b'
  C_START="${ESC}\\[[0-9][0-9]m"
  C_END="${ESC}\\[m"
  PURPLE_START="${ESC}\\[35m"
  CYAN_START="${ESC}\\[36m"
  YELLOW_START="${ESC}\\[33m"
  GREP_RESULT="^${C_START}(.+)${C_END}${C_START}([:-])${C_END}${C_START}([0-9]+)${C_END}${C_START}([:-])${C_END}(.*)$"
  FORMAT_FILE_NAME="${PURPLE_START} \\1 ${C_END}:"
  FORMAT_MATCH="${CYAN_START}\\2${C_END}${YELLOW_START}\\3${C_END}${CYAN_START}\\4${C_END}\\5"
  sed -r "s/${ESC}\\[K//g" \
    | sed -nr "
      1s/${GREP_RESULT}/${FORMAT_FILE_NAME}/p
      /^${C_START}--${C_END}$/{n;s/^${GREP_RESULT}/\\n${FORMAT_FILE_NAME}/p}
      s/${GREP_RESULT}/${FORMAT_MATCH}/p
  "
}

rgrep()
{
  echo "Searching files...\n"
  time grep -r -nHI -C2 --exclude-dir=".git" --exclude-dir=".svn" --exclude-dir=".hg" --exclude-dir=".bzr" --color=always "$@" "${PWD}" | rgrep-vis
  echo "\n...finsihed"
}

rgrep-vim()
{
  rgrep "$@" | vim -c '%!nkf' -c ':AnsiEsc' -c ':w `=tempname()`' -
}

rgrep-gvim()
{
  rgrep "$@" | gvim -c '%!nkf' -c ':AnsiEsc' -c ':w `=tempname()`' -
}

26num2al()
{
sed 's/00/A/g;s/01/B/g;s/02/C/g;s/03/D/g;s/04/E/g;s/05/F/g;s/06/G/g;s/07/H/g;s/08/I/g;s/09/J/g;s/10/K/g;s/11/L/g;s/12/M/g;s/13/N/g;s/14/O/g;s/15/P/g;s/16/Q/g;s/17/R/g;s/18/S/g;s/19/T/g;s/20/U/g;s/21/V/g;s/22/W/g;s/23/X/g;s/24/Y/g;s/25/Z/g;'
}

luhn()
{
rev | grep -o . | xargs -n 2 | awk '{print $1,$2*2}' | grep -o . | xargs | tr ' ' '+' | bc | awk '{print $0%10}' | sed 's/0/OK/;s/[1-9]/NG/;'
}

heroku-instant(){
  local _remote=$(heroku create | grep '|' | awk '$0=$3')
  echo '{}' > composer.json
  git init
  git remote add heroku "$_remote" && git add -A && git commit -m "`date +%F-%H-%M-%S`" && git push heroku master && heroku open
}

egi-divisors() {
  local _n=${1:-$(cat)}
  egison -T -e '(unique (1#(map (1#[%1] $) (match-all %1 (multiset integer) [<join $a _> [(foldl * 1 a)]])) (p-f '$_n')))' | tr '\n' ' ' | sed 's/ $/\n/' | sed 's/^/'$_n': /'
}

egi-conv () {
  xargs -n 1 | \
  egison -T -F1s -s '(match-all-lambda (list string) [<join _ (loop $i [1 '$1'] <cons $a_i ...> _) > (map (1#a_%1 $) (between 1 '$1'))])' | \
  xargs -n $1
}

sed-conv () {
  local _NF=$1
  sed -n 'H;'$_NF',${g;s/\n/ /g;p};'$(($_NF-1))',${x;s/[^\n]*\n//;h}'
}

urlenc() {
  od -An -tx1 | awk 'NF{OFS="%";$1=$1;print "%"$0}' | tr '[:lower:]' '[:upper:]'
}

# Numeric character refernce to string
# echo '&#x78BA;&#x8A8D;' | ncr2str
ncrhex2str () {
  perl -MHTML::Entities -pe 'decode_entities($_);' 2>/dev/null
}

str2ncrhex () {
  iconv -f UTF-8 -t UTF-16BE | od -tx1 -An | tr -dc 'a-zA-Z0-9' | fold -w 4 | sed 's/^/\&#x/;s/$/;/' | tr -d \\n
}


# String to Unicode Escapse Sequence
str2ues () {
  nkf -w16B0 | od -tx1 -An | tr -dc '[:alnum:]' | fold -w 4 | sed 's/^/\\u/g' | tr -d '\n' | awk 1
  # nkf -w16B0
}

# Example
# printf "%s" '\u3046\u3093\u3053\u000a' | ues2str
# But just echo command supports UES. It might not be the necessary feature.
ues2str () {
  sed -r "s/\\\\u(....)/\&#x\1;/g" | ncrhex2str
}

# Ref: http://qiita.com/ryo0301/items/7c7b3571d71b934af3f8
camel2snake () {
  sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\L\2/g'
}

camel2pascal () {
  sed -r 's/(^|_)(.)/\U\2\E/g'
}

snake2camel () {
  sed -r 's/_(.)/\U\1\E/g'
}

snake2pascal () {
  sed -r 's/(^|_)(.)/\U\2\E/g'
}

pascal2camel () {
  sed -r -e 's/^([A-Z])/\L\1\E/'
}

pascal2snake () {
  sed -r -e 's/^([A-Z])/\L\1\E/' -e 's/([A-Z])/_\L\1\E/g'
}

is_camel () {
  grep -E '^[a-z]+([A-Z][a-z0-9]+)+'
}

is_snake () {
  grep -E '^[a-z]+(_[a-z0-9]+)+'
}

is_pascal () {
  grep -E '^([A-Z][a-z0-9]+)+'
}

# Generate regular expression for camel, snake and pascal cases.
# $ csp_cases "hogeHoge"
# (hoge_hoge|hogeHoge|HogeHoge)
csp_cases () {
  local _pat="$1"
  # convert all the petterns to snake case in any case.
  _pat=$(echo "$_pat" | camel2snake)
  _pat=$(echo "$_pat" | pascal2snake)
  local _snake="$_pat"
  local _camel="$(echo "$_pat" | snake2camel)"
  local _pascal="$(echo "$_pat" | snake2pascal)"
  echo "($_snake|$_camel|$_pascal)"
}

usedportof()
{
  lsof -n -P -i :$1
}

holidays() {
  local _cmd="$1" ;shift
  case "$_cmd" in
    until)
      local _until_date="$1"
      curl -Lso- goo.gl/Ynbsm9 | awk 1 | awk '/'"$(date +%F)"'/,/'"${_until_date}"'/'
      ;;
    *)
      curl -Lso- goo.gl/Ynbsm9 | awk 1
      ;;
  esac
}

today() {
    curl -Lso- goo.gl/Ynbsm9 | grep "$(date +%F)" -B 5 -A 25
}

melos () {
  curl -so- 'http://www.aozora.gr.jp/cards/000035/files/1567_14913.html' | xmllint --html --xpath '/html/body/div[3]' - 2>/dev/null | nkf -w -Lu | sed -r 's/<[^>]*>//g;s/（.*）//g;s/( 「|」|　)//g' | awk NF
}

nanbu-sen () {
  curl -so- https://gist.githubusercontent.com/greymd/20d51eacf12a0d06fe0c/raw/303adc7e53bb968de2be92281b827805fcf56d83/nanbu_line_rapid
}

yamanote-sen () {
  echo "品川 田町 浜松町 新橋 有楽町 東京 神田 秋葉原 御徒町 上野 鶯谷 日暮里 西日暮里 田端 駒込 巣鴨 大塚 池袋 目白 高田馬場 新大久保 新宿 代々木 原宿 渋谷 恵比寿 目黒 五反田 大崎" | tr ' ' '\n'
}

weather() {
  curl -4 wttr.in/tokyo
}

transfer() {
  curl --upload-file "$1" https://transfer.sh/"$1"
}

primes() {
  local _factor=""
  if ( type gfactor &> /dev/null ); then
      _factor="gfactor"
  else ( type factor &> /dev/null )
      _factor="factor"
  fi
  yes | awk '$0=NR+1' | $_factor | awk '$0*=!$3'
}

fizzbuzz() {
  yes | awk '{print NR}' | sed '0~3s/.*/Fizz/;0~5s/$/Buzz/' | sed 's/[0-9]*B/B/'
}

answer_is () {
  echo "越後製菓！"
}

# $ echo 'hoge,2014/03/01 01:11:19,huga' | pfsed , 2 's/./_/g'
# hoge,___________________,huga
pfsed() {
  perl -F$1 -ane '$F['$(($2 - 1))']=~'$3';print join("'$1'",@F)'
}

bapnd () {
  cat | sed 's/^/'"$1"'/'
}

eapnd () {
  cat | sed 's/$/'"$1"'/'
}

recrep () {
  pt "$1" | awk -F: '{print $1}' | sort | uniq | xargs sed "s/$1/$2/g"
}

recrep-i () {
  pt "$1" | awk -F: '{print $1}' | sort | uniq | xargs sed -i "s/$1/$2/g"
}

sazae-janken () {
  w3m -dump http://www.asahi-net.or.jp/~tk7m-ari/sazae_ichiran.html | awk 'NR>4{print $1,$2,$NF}' | awk NF
}

dolen () {
    curl -L -so- 'http://www.gaitameonline.com/rateaj/getrate' | jq '.quotes[] | select(.currencyPairCode == "USDJPY")'
}

mynumbers () {
  seq 0 9 | xargs -P10 -I@ sh -c 'gseq $([ @ -eq 0 ] && echo -w) @0000000000 @9999999999 | mawk '\''{c=($1*6+$2*5+$3*4+$4*3+$5*2+$6*7+$7*6+$8*5+$9*4+$10*3+$11*2)%11;d=c<=1?0:(11-c);print $0 d}'\'' FS='
}

access_log_clean () {
# There are three kinds of field's pattern in apache log
B='\(.*\)'
D='"\(.*\)"'
P='\[\(.*\)\]'

# Change this part depend's on the number of field.
STR='\1\x0\2\x0\3\x0\4\x0\5\x0\6\x0\7\x0\8\x0\9\x0\10\x0\11\x0'
sed 's;\\\\;%5C;g' < /dev/stdin |
sed 's;\\";%22;g' |

# Change this part depend's on the each pattern of field.
sed "s/^$B $B $B $P $D $B $B $D $D $B $B\$/$STR/" |
sed 's/_/\\_/g' |
sed 's/ /_/g' |
sed 's/\x0\x0/\x0_\x0/g' |
sed 's/\x0\x0/\x0_\x0/g' |
tr '\000' ' ' |
sed 's/ $//'
}

nginx_log_clean () {
        B='\(.*\)'
        D='"\(.*\)"'
        P='\[\(.*\)\]'
        STR='\1\x0\2\x0\3\x0\4\x0\5\x0\6\x0\7\x0\8\x0\9\x0\10\x0'
        sed 's;\\\\;%5C;g' < /dev/stdin | sed 's;\\";%22;g' | sed "s/^$B $B $B $P $D $B $B $D $D $D\$/$STR/" | sed 's/_/\\_/g' | sed 's/ /_/g' | sed 's/\x0\x0/\x0_\x0/g' | sed 's/\x0\x0/\x0_\x0/g' | tr '\000' ' ' | sed 's/ $//'
}

grayscale () {
  convert "$1" -type GrayScale "$2"
}

halfimg () {
  convert "$1" -resize 50% "$2"
}

base64sh() {
    local input=${1:-$(cat)}
    paste <(seq 0 63 | sed 's/^/obase=2;ibase=10;/' | bc | sed 's/^/00000/' | grep -oE '.{6}$') \
    <(echo {A..Z} {a..z} {0..9} + / | xargs -n 1) | \
    awk '{print "s|"$1"|"$2"|"}' | \
    sed -f - <(echo -n $input| perl -ne 'print unpack("B*", $_)."0000"' | \
    fold -w 6 | grep -oE '.{6}$') | tr -d '\n' | fold -w 4 | sed 's/$/===/' | grep -oE '^.{4}' | tr -d '\n' | awk 1
}

str2base64url () {
  cat | base64 | tr -d '=' | tr -- '+/' '-_'
}

base64url2base64 () {
    # Set padding
    fold -w 4 | sed 's/$/===/' | grep -oE '^.{4}' | tr -d '\n' | \
  tr -- '-_' '+/'
}

os2ip () {
    xxd -b -c 1 | awk '{print $2}' | tr -d '\n' | awk 1 | sed 's/^/obase=10;ibase=2;/' | bc | tr -d '\\ \n' | awk 1
}

i2osp () {
    local xLen=${1:-256}
    sed 's/^/obase=16;ibase=10;/' | bc | tr -d '\\ \n' |  perl -nle 'print "0" x (('$xLen'*2)-length($_)) . $_' | sed 's/.*/\L&/'
}

tensorflow-start () {
  source $HOME/tensorflow/bin/activate
}

hex2binary () {
    perl -nle 'print pack("H*", $_)'
}

binary2hex () {
    od -An -tx1 | tr -dc '[:alnum:]'
}

aes-enc () {
    cat | openssl enc -aes-128-ecb -K $( echo -n "$1" | bin2hex) | bin2hex | sed 's/$/\n/'
}

aes-dec () {
    cat | hex2bin | openssl enc -aes-128-ecb -K $( echo -n "$1" | bin2hex) -d 2> /dev/null
}

pokemons () {
    w3m -dump 'http://wiki.xn--rckteqa2e.com/wiki/%E3%83%9D%E3%82%B1%E3%83%A2%E3%83%B3%E3%81%AE%E5%A4%96%E5%9B%BD%E8%AA%9E%E5%90%8D%E4%B8%80%E8%A6%A7' | sed -n '/001  フシギダネ/,/151 ミュウ/p' | perl -anle '/^\d{3}/ and scalar(@F)==6 and print'
}

# 2 -> 10
bin2dec() {
    sed -e 's/^/2i /' -e 's/$/ p/' | dc
    # BC_LINE_LENGTH=0 cat | sed 's/^/obase=10;ibase=2;/' | bc | while read i;do echo $i ;done
}

# 2 -> 16
bin2hex() {
    sed -e 's/^/2i /' -e 's/$/ 16op/' | dc
    # cat | sed 's/^/obase=16;ibase=2;/' | bc
}

# 10 -> 2
dec2bin () {
    sed -e 's/^/10i /' -e 's/$/ 2op/' | dc
    # cat | sed 's/^/obase=2;ibase=10;/' | bc | while read i;do echo $i ;done
    # BC_LINE_LENGTH=0 cat | sed 's/^/obase=2;ibase=10;/' | bc | while read i;do echo $i ;done
}

# 10 -> 16
dec2hex () {
    sed -e 's/^/10i /' -e 's/$/ 16op/' | dc
    # BC_LINE_LENGTH=0 cat | sed 's/^/obase=16;ibase=10;/' | bc | while read i;do echo $i ;done
}

# 16 -> 2
hex2bin () {
    sed -e 's/^/16i /' -e 's/$/ 2op/' | dc
    # BC_LINE_LENGTH=0 cat | tr '[:lower:]' '[:upper:]' | sed 's/^/obase=2;ibase=16;/' | bc | while read i;do echo $i ;done
}

# 16 -> 10
hex2dec() {
    sed -e 's/^/16i /' -e 's/$/ p/' | dc
    # BC_LINE_LENGTH=0 cat | tr '[:lower:]' '[:upper:]' | sed 's/^/obase=10;ibase=16;/' | bc | while read i;do echo $i ;done
}

sslcert-gen() {
    local _domain=${1:-healthcheck.com}
    openssl genrsa -rand <(cat /dev/urandom | LANG=C tr -dc '[:alnum:]' | fold -w 10 | head -n 100) -out server.key 1024
    echo "JP\nTokyo\nMachida City\nMachida, Inc.\nTech\n$_domain\n\n\n\n" | openssl req -new -key server.key -out server.csr
    # Country Name (2 letter code) [XX]:JP
    # State or Province Name (full name) []:Tokyo
    # Locality Name (eg, city) [Default City]:Setagaya-ku
    # Organization Name (eg, company) [Default Company Ltd]:Machida, Inc.
    # Organizational Unit Name (eg, section) []:Tech
    # Common Name (eg, your name or your server's hostname) []:healthcheck.com
    # Email Address []:
    openssl x509 -req -days 65535 -in server.csr -signkey server.key -out server.crt
}

# Vim-Oneliner
# Usage example:
# $ seq 5 | vo +'g/^/m0'
# 5
# 4
# 3
# 2
# 1
vo () {
        vim -es <(cat) "$@" '+%p|q!'
}

tmux-clean () {
    tmux ls | grep -v attached | awk "\$0=\$1" | tr -d ":" | xargs -I@ echo tmux kill-session -t @ | sh
}

# From https://gist.github.com/gin135/f22a44b372d5b9e8b413d963aa68ae15
train-kanto () {
    curl -s http://traininfo.jreast.co.jp/train_info/kanto.aspx |
    nkf -Lu |
    grep -A 1 'text-tit-xlarge' |
    sed '/acess_i/s/.*alt="\([^"]*\)".*/\1/' |
    sed 's/<[^>]*>//g' |
    tr -d -- '- ' |
    awk NF=NF |
    xargs -n 2
}

ggrks () { echo $@ | tr \  + | awk '{print "http://www.google.co.jp/search?hl=ja&source=hp&q="$0}' | xargs open;};

slow-dos () {
  local _fqdn="$1"
  local _domain_port=$(awk -F'/' '{print $1}' <<<"$_fqdn")
  local _domain=$(awk -F':' '{print $1}' <<<"$_domain_port")
  local _port=$(awk -F':' '{print $2}' <<<"$_domain_port" | grep -oE '[0-9]*')
  local _request_path=$(grep -oE '/.*$' <<<"$_fqdn")
  local _clength=${2:-10}
  _request_path=${_request_path:-/}
  _port=${_port:-80}
  echo "_fqdn $_fqdn"
  echo "_domain $_domain"
  echo "_request_path ${_request_path}"
  echo "_port ${_port}"
  (sleep 1; echo -ne "POST $_request_path HTTP/1.1\nHost: $_domain\nContent-Length: $_clength\n\n"; yes 'printf a; sleep 1;' | sh ) | telnet "$_domain" "$_port"
}

nc-200 () {
  ( echo "HTTP/1.1 200 Ok"; echo; printf "$1" ) | nc -l 8080
}

hub-clone () {
  local _arg="$(echo "$1" | awk -F/ '{if(/github.com/){gsub(".git","",$NF);print $(NF-1)"/"$NF}else{print}}')"
  local _user="${_arg%/*}"
  local _repo="${_arg##*/}"
  local _repo_path="$HOME/repos"
  mkdir -p "$_repo_path/$_user"
  git clone "git@github.com:$_user/$_repo.git" "$_repo_path/$_user/$_repo"
  cd "$_repo_path/$_user/$_repo"
}

fnd () {
  find "$PWD" | grep "${1-}"
}

mail-sweeper () {
  local _mail_dir="$HOME/Mails/new"
  local _filter="$1" ;shift
  local _opt="${1-}" ;shift
  local _target_dir="$PWD"

  if [ -z "$_filter" ]; then
    echo "Error: filter '$_filter' is empty." >&2
    return 1
  fi

  if [[ "$_opt"  =~ ^--all$ ]];then
    getmail -v --all
  else
    getmail -v -n
  fi

  (
    cd "$_mail_dir"
    rename "s/\.[^\.]+$/.eml/" *
    find . -type f \
      | grep eml \
      | while read f;
        do
          printf "mv '$f' "
          echo '"'$_mail_dir/$(cat "$f" | nkf -w | perl -nle '/^Subject: \K.*/ and print $&')_$(basename $f)'"'
        done | tee | sh
    grep "$_filter" * | awk -F: '{print $1}' | sort | uniq | while read f;do mv "$f" "$_target_dir";done
  )
}

btc2jpy () {
  local _unit=${1:-1}
  local _rate
  _rate="$(curl https://api.bitflyer.jp/v1/getboard -G -d 'product_code=BTC_JPY' 2>/dev/null | jq '.mid_price')"
  echo "$_rate * $_unit" | bc -l
}

ytn2jpy () {
  local _unit=${1:-1}
  local _rate
  _rate=$(curl -so- 'https://www.coingecko.com/ja/%E7%9B%B8%E5%A0%B4%E3%83%81%E3%83%A3%E3%83%BC%E3%83%88/yenten/jpy' | sed -nr 's|今日のYENTEN の価格は.*<span>([0-9\.]+).?</span>.*$|\1|p')
  echo "$_rate * $_unit" | bc -l
}

aud2jpy () {
  local _unit=${1:-1}
  local _rate
  _rate=$(something-jpy "aud")
  echo "$_rate * $_unit" | bc -l
}

eur2jpy () {
  local _unit=${1:-1}
  local _rate
  _rate=$(something-jpy "eur")
  echo "$_rate * $_unit" | bc -l
}

usd2jpy () {
  local _unit=${1:-1}
  local _rate
  _rate=$(something-jpy "usd")
  echo "$_rate * $_unit" | bc -l
}

something-jpy () {
  local _cur="$1"
  curl -H 'User-Agent: Mozilla/5.0' https://jp.investing.com/currencies/${_cur}-jpy 2>/dev/null \
    | xmllint --format --html --xpath '//*[@id="last_last"]/text()' - 2>/dev/null
}

#
# Input:
# 2017-11-30 ScheduleA
# 2017-12-01 ScheduleA
# 2017-12-04 ScheduleA
# 2017-12-05 ScheduleA
# 2017-12-06 ScheduleA
# 2017-12-07 ScheduleA
# 2017-12-08 ScheduleB
# 2017-12-11 ScheduleC
# 2017-12-12 ScheduleC
#
# Output:
# 2017-11-30 - 12-07 ScheduleA
# 2017-12-08 ScheduleB
# 2017-12-11 - 12-12 ScheduleC
schedule_shrink () {
  awk '{print $1,$NF}' \
    | awk '{a[$NF]=a[$NF]" "$1} END{for(k in a){print a[k],k}}' \
    | sort -k1,1n \
    | awk 'NF>2{gsub(/^....-/,"",$(NF-1));print $1" - "$(NF-1),$NF} NF==2{print $1,$2}'
}


# -----------------------
# Markdown Utils
# -----------------------

md.tbl () {
  pandoc -f gfm -t gfm
}

md.tblsum () {
  local _from="$1" ;shift
  local _to="$1" ;shift
  awk '
  {
    for (i=from+offset; i<=to+offset; i++){
      s[i]=s[i]+$i
    };print
  }
  END{
    printf "%s",OFS"sum"
    for (i=from+offset; i<=to+offset; i++){
      printf OFS""s[i]
    }
    print OFS
  }' {FS,OFS,IFS}='|' offset=1 from="${_from}" to="${_to}" | pandoc -f gfm -t gfm
}

md.adjust_refs () {
    local _tmp_file="/tmp/$$.adjust_md_refs"
    cat "$1" | grep -oP '\[\^[^\[]*?\](?!:)' | while read s; do echo "$s" | awk '{print "s/"$1"/[^'$(cat /dev/urandom| LANG=C tr -dc 'A-Za-z0-9' | fold -w 10 | head -n 1)']/g"}' ;done | perl -pe 's/[\[\]]/\\$&/g' | sed -f - "$1" > "$_tmp_file"
    cat "$_tmp_file" | grep -oP '\[\^[^\[]*?\](?!:)' | awk '{print "s/"$1"/[^"NR"]/g"}' | perl -pe 's/[\[\]]/\\$&/g' | sed -f - "$_tmp_file"
    rm "$_tmp_file"
}

tellme () {
  local _input="$*"
  _input=$(printf "${_input}" | urlenc | tr -d \\n)
  curl -so- "http://api.wolframalpha.com/v2/query?input=${_input}&appid=${WOLFRAM_ID}" \
    | grep plaintext \
    | grep -v '</plaintext></plaintext>' \
    | sed -r 's|</?plaintext>||g'
}

heybot () {
  local _input="$*"
  curl -so- https://api.a3rt.recruit-tech.co.jp/talk/v1/smalltalk \
    -d "apikey=${TALK_API_KEY}" \
    -d "query=${_input}" | \
    jq -r '.results[].reply' | \
    sed 's/私/ぼく/g' | \
    sed 's/$/❗/'
    # jq .
}

logawk () {
  # Inspired by https://www.slideshare.net/HirofumiSaito/gnu-awk-gawk-apache
  awk -vFPAT="(\\[[^\\[\\]]+\\])|(\"[^\"]+\")|([^ ]+)" "$@"
}

__aws_ssh_key () {
  local _region="${1:-us-east-2}"
  echo "us-east-1 $HOME/.ssh/id_rsa_ant
  us-east-2 $HOME/.ssh/id_rsa_ohio
  ap-northeast-1 $HOME/.ssh/id_rsa_tokyo" | awk "/$_region/{print \$2}"
}

ec2-ls () {
  local _region="${1:-us-east-2}"
  aws ec2 describe-instances --region "$_region" --output json | jq -r '.Reservations[] | .Instances[] | select(.State.Code == 16)  | .PublicDnsName'
}

ec2-assh () {
  local _region="${1:-us-east-2}"
  local _key=
  _key=$(__aws_ssh_key "$_region")
  aws ec2 describe-instances --region "$_region" --output json | jq -r '.Reservations[] | .Instances[] | select(.State.Code == 16)  | .PublicDnsName' | xpanes --debug -sst -c "ssh -o StrictHostKeyChecking=no -i '$_key' ec2-user@{}"
}

# zen_to_i () {
#   sed -r 's/(万|億|兆)/\0\n/g' | perl -C -Mutf8 -pe '$n="一二三四五六七八九";eval "s/(".join("|", split("", $n)).")/+\$&/g";eval "tr/$n/1-9/";s/(\d)十/$1*10/g;s/(\d)百/$1*100/g;s/(\d)千/$1*1000/g;s/十/10/g;s/百/100/g;s/千/1000/g;' | perl -C -Mutf8 -pe 's/^\+//;s/([\d\*+]+)万/($1)*10000/;s/([\d\*+]+)億/($1)*100000000/g;s/([\d\*+]+)兆/($1)*100000000/;' | gpaste -sd'+' | bc
# }

date_utc2jst () {
  TZ=Asia/Tokyo  gdate -d "$* UTC" "+%FT%T.000Z"
}

date_jst2utc () {
  TZ=UTC  gdate -d "$* JST" "+%FT%T.000Z"
}

date_ist2jst () {
  TZ=Europe/Dublin gdate -d "$* JST" "+%FT%T.000Z"
}

timezones () {
  _datetime="$*"
  if [[ -z "${_datetime}" ]]; then
    _datetime="now"
  fi
  # IST(Indian Standard Time) => Irish Standard Time
  _datetime="${_datetime/IST/GMT+1}"

  for TZ in US/Pacific UTC Europe/Dublin Asia/Tokyo
  do
    TZ=$TZ gdate -d "${_datetime}" +"%Y/%m/%d %H:%M %Z  %FT%T.000Z" | grep -v GMT | awk '!/UTC/{$NF=""};4'
  done
}

somosomo () {
  grep -P '([\p{Han}\p{Hiragana}]+)\1'
}

zen_to_i () {
  sed -r 's/(万|億|兆)/\0\n/g' | perl -C -Mutf8 -pe '$n="一二三四五六七八九";eval "s/(".join("|", split("", $n)).")/+\$&/g";eval "tr/$n/1-9/";s/(\d)十/$1*10/g;s/(\d)百/$1*100/g;s/(\d)千/$1*1000/g;s/十/10/g;s/百/100/g;s/千/1000/g;' | perl -C -Mutf8 -pe 's/^\+//;s/([\d\*+]+)万/($1)*10000/;s/([\d\*+]+)億/($1)*100000000/g;s/([\d\*+]+)兆/($1)*100000000/;' | gpaste -sd'+' | bc
}

possible_exec () {
  for _cmd in "$@"; do
    if type "$_cmd" &> /dev/null ;then
      echo "$_cmd"
      return 0
    fi
  done
  return 1
}

byte-read () {
  local _exec
  if ! _exec="$(possible_exec numfmt gnumfmt)"; then
    echo "numfmt command is not found" >&2
    return 1
  fi
  ${_exec} --to=iec
}

tmux-title () {
    printf "\\033]2;%s\\033\\\\" "$1"
}
