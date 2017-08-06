USER_BIN="$HOME/bin"
SKEL_PROJECT_DIR="$HOME/.zsh/project-skel/"
# __GRE_REPOSITORY_DIR environment variable is defined on .profile.
export PS1="\W \$ "

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
  alias jshell='/Library/Java/JavaVirtualMachines/jdk-9.jdk/Contents/Home/bin/jshell'
  alias factor='gfactor'
  alias shuf='gshuf'
  export ECLIPSE_HOME="/Applications/Eclipse.app/Contents/Eclipse"

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
alias git-add-modified='git status | grep modified | awk '\''{print "git add "$NF}'\'
alias up="cd ..; ls"

alias psum='tr "\n" " " | perl -anle "print eval join \"+\", @F"'

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
__add_path "/usr/games" # For Ubuntu
# __add_path "/usr/local/opt/icu4c/bin"
# __add_path "/usr/local/opt/icu4c/sbin"

#--------------------
# Go
#--------------------
_target_path="$HOME/.go"
if [ -e "$_target_path" ]; then
  export GOPATH="$_target_path"
  export PATH=$GOPATH/bin:$PATH
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
alias jrepl="java -jar $USER_BIN/bin/javarepl-dev.build.jar"

export JAVA_HOME="$HOME/.sdkman/candidates/java/current/"
__add_path "$HOME/.sdkman/candidates/java/current/bin"
__add_path "$HOME/.sdkman/candidates/maven/current/bin"
__add_path "$HOME/.sdkman/candidates/ant/current/bin"
__add_path "$HOME/.sdkman/candidates/gradle/current/bin"

jex () {
  javac $1 && java ${1%.java}
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
    cat pom.xml | perl -anle 'print if /dependencies/../\/dependencies/' | grep -Po '<(groupId|artifactId|version)>\K.*(?=</\1>)' | xargs -n 3 | perl -anpe '$F[0]=~s|\.|/|g; $_="$F[0]/$F[1]/$F[2]/.*\\.jar\$\n"' | grep -Ef - <(find ~/.m2/g_repository)
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
if (grep -q Microsoft /proc/version 2> /dev/null ) ;then
  # alias docker="docker -H tcp://localhost:2375 --tlsverify --tlscacert /mnt/c/Users/$USER/.docker/machine/certs/ca.pem  --tlscert /mnt/c/Users/$USER/.docker/machine/certs/cert.pem --tlskey /mnt/c/Users/$USER/.docker/machine/certs/key.pem"
  alias docker="docker -H tcp://localhost:2375"
fi

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
  local _cmd='tmux -2'
  local _opts="-it greymd/dev"
  if [[ "$1" =~ v ]]; then
    # Mount current volume
    _opts="-v $(pwd):/work ${_opts}"
  fi
  if [[ "$1" =~ j ]]; then
    # Java mode
    _cmd='nohup Xvfb :1 -screen 0 1024x768x24 &> /dev/null & /home/docker/eclipse/eclimd -b &> /dev/null && tmux -2'
  fi
  docker run $_opts /bin/zsh -c "$_cmd"
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

recgrep2subl()
{
sed -r 's/\[K//g' | sed -nr '
1{
h
s/^\[35m(.+)\[m(\[36m[:-]\[m\[32m[0-9]+\[m\[36m[:-]\[m.*)$/\n\[35m \1 \[m:/
p
d
}
/^\[36m--\[m$/{
n
h
s/^\[35m(.+)\[m(\[36m[:-]\[m\[32m[0-9]+\[m\[36m[:-]\[m.*)$/\n\[35m \1 \[m:/
p
d
}
s/^\[35m.+\[m\[36m([:-])\[m\[32m([0-9]+)\[m\[36m([:-])\[m(.*)$/\[36m\1\[m\[33m\2\[m\[36m\3\[m\4/
p'
}

rgrep()
{
  echo "Searching files...\n"
  time grep -r -inHI -C2 --exclude-dir=".git" --exclude-dir=".svn" --exclude-dir=".hg" --exclude-dir=".bzr" --color=always $@ $(pwd) | recgrep2subl
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

# String to Unicode Escapse Sequence
str2ues () {
    nkf -w16B0 | od -tx1 -An | tr -dc '[:alnum:]' | fold -w 4 | sed 's/^/\\u/g' | tr -d '\n' | awk 1
}

usedportof()
{
  lsof -n -P -i :$1
}

holidays() {
  curl -Lso- goo.gl/Ynbsm9 | awk 1
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

hex2bin () {
    perl -nle 'print pack("H*", $_)'
}

bin2hex () {
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

adjust_md_refs () {
    local _tmp_file="/tmp/$$.adjust_md_refs"
    cat "$1" | grep -oP '\[\^[^\[]*?\](?!:)' | while read s; do echo "$s" | awk '{print "s/"$1"/[^'$(cat /dev/urandom| LANG=C tr -dc 'A-Za-z0-9' | fold -w 10 | head -n 1)']/g"}' ;done | perl -pe 's/[\[\]]/\\$&/g' | sed -f - "$1" > "$_tmp_file"
    cat "$_tmp_file" | grep -oP '\[\^[^\[]*?\](?!:)' | awk '{print "s/"$1"/[^"NR"]/g"}' | perl -pe 's/[\[\]]/\\$&/g' | sed -f - "$_tmp_file"
    rm "$_tmp_file"
}

# 2 -> 10
bin2dec() {
    BC_LINE_LENGTH=0 cat | sed 's/^/obase=10;ibase=2;/' | bc | while read i;do echo $i ;done
}

# 2 -> 16
bin2hex() {
    cat | sed 's/^/obase=16;ibase=2;/' | bc
}

# 10 -> 2
dec2bin () {
    # cat | sed 's/^/obase=2;ibase=10;/' | bc | while read i;do echo $i ;done
    BC_LINE_LENGTH=0 cat | sed 's/^/obase=2;ibase=10;/' | bc | while read i;do echo $i ;done
}

# 10 -> 16
dec2hex () {
    BC_LINE_LENGTH=0 cat | sed 's/^/obase=16;ibase=10;/' | bc | while read i;do echo $i ;done
}

# 16 -> 2
hex2bin () {
    BC_LINE_LENGTH=0 cat | sed 's/^/obase=2;ibase=16;/' | bc | while read i;do echo $i ;done
}

# 16 -> 10
hex2dec() {
    BC_LINE_LENGTH=0 cat | sed 's/^/obase=10;ibase=16;/' | bc | while read i;do echo $i ;done
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
