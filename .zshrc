# Use .bashrc settings as much as possible
source $HOME/.bashrc

if [ -s "$HOME/.local.zsh" ]; then
    source "$HOME/.local.zsh"
fi


#--------------------
# Incremental Search
# (This settings should be earlyer than antigen)
#--------------------
# Enable the incremental search during typing
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

#--------------------
# Command Line Stack
# (This settings should be earlyer than antigen)
#--------------------
# Ref: https://gist.github.com/yukirin/7067299
autoload -Uz add-zsh-hook

local p_buffer_stack=""
local -a buffer_stack_arr

function make_p_buffer_stack()
{
  if [[ ! $#buffer_stack_arr > 0 ]]; then
    p_buffer_stack=""
    return
  fi
  p_buffer_stack="%F{cyan}<stack:$buffer_stack_arr>%f"
}

function show_buffer_stack()
{
  local cmd_str_len=$#LBUFFER
  [[ cmd_str_len > 10 ]] && cmd_str_len=10
  buffer_stack_arr=("[$LBUFFER[1,${cmd_str_len}]]" $buffer_stack_arr)
  make_p_buffer_stack
  zle push-line-or-edit
  zle reset-prompt
}

function check_buffer_stack()
{
  [[ $#buffer_stack_arr > 0 ]] && shift buffer_stack_arr
  make_p_buffer_stack
}

zle -N show_buffer_stack
bindkey "^Q" show_buffer_stack
add-zsh-hook precmd check_buffer_stack

RPROMPT='${p_buffer_stack}'

#--------------------
# History
#--------------------
# History size
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

#ヒストリの一覧を読みやすい形に変更
HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "


#--------------------
# Key bindings
# (This settings should be earlyer than antigen)
#--------------------
## Use emacs key bindings
bindkey -e

#入力途中の履歴補完
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#インクリメンタルサーチの設定
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

#履歴のインクリメンタル検索でワイルドカード利用可能
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

# Ctrl + U has same behavior as bash.
bindkey \^U backward-kill-line

# C-^ で一つ上のディレクトリへ
function cdup() {
  echo
  cd ..
  zle reset-prompt
}

zle -N cdup
bindkey '^^' cdup

#--------------------
# antigen
# (because zplug does not work on docker)
# Ref: issue https://github.com/zplug/zplug/issues/272
#--------------------
source $HOME/repos/zsh-users/antigen/antigen.zsh
# Edit misc.zsh by following https://stackoverflow.com/questions/25614613/how-to-disable-zsh-substitution-autocomplete-with-url-and-backslashes
# Or, special characters will be automatically escaped.
# Disable oh-my-zsh to set ls's alias as expected

# antigen use oh-my-zsh

# Use oh-my-zsh plugins
antigen bundle heroku

antigen bundle "b4b4r07/enhancd"
antigen bundle "zsh-users/zsh-syntax-highlighting"
# antigen bundle "zsh-users/zsh-autosuggestions"
antigen bundle "zsh-users/zsh-completions"
antigen bundle "greymd/cureutils"
antigen bundle "greymd/docker-zsh-completion"
antigen bundle "nnao45/zsh-kubectl-completion"
antigen bundle "greymd/tmux-xpanes"
# antigen bundle "greymd/eclim-cli"
# antigen bundle "greymd/confl"
antigen bundle "greymd/awless-zsh-completion"
antigen bundle "nobeans/zsh-sdkman"
# antigen bundle "unkontributors/super_unko"
antigen apply

# ----------------------------------------------
# Configurations: zsh-users/zsh-autosuggestions
# From: https://github.com/zsh-users/zsh-autosuggestions/blob/master/src/config.zsh
# ----------------------------------------------
  # Color to use when highlighting suggestion
  # Provided by https://github.com/zsh-users/zsh-autosuggestions/issues/171
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'

  # Prefix to use when saving original versions of bound widgets
  ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX=autosuggest-orig-

  ZSH_AUTOSUGGEST_STRATEGY=default

  # Widgets that clear the suggestion
  ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
    history-search-forward
    history-search-backward
    history-beginning-search-forward
    history-beginning-search-backward
    history-substring-search-up
    history-substring-search-down
    up-line-or-history
    down-line-or-history
    accept-line
  )

  # Widgets that accept the entire suggestion
  ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
    forward-char
    end-of-line
    vi-forward-char
    vi-end-of-line
    vi-add-eol
  )

  # Widgets that accept the entire suggestion and execute it
  ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=(
  )

  # Widgets that accept the suggestion as far as the cursor moves
  ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
    forward-word
    vi-forward-word
    vi-forward-word-end
    vi-forward-blank-word
    vi-forward-blank-word-end
  )

  # Widgets that should be ignored (globbing supported but must be escaped)
  ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(
    orig-\*
    beep
    run-help
    set-local-history
    which-command
    yank
  )

#--------------------
# Completion
#--------------------
# Enable completion feature
autoload -U promptinit colors && colors

## Skip following procedures because compinit is already loaded by antigen
# autoload -U compinit
# compinit

zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*:default' menu select=1
# Upper and lower casee are recognized as same characters when completion.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完でカラーを使用する
autoload colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# kill の候補にも色付き表示
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# コマンドにsudoを付けても補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# zsh内蔵エディタを使う
autoload -U zcalc
autoload zed

#補完リストが多いときに尋ねない
LISTMAX=0

#"|,:"を単語の一部とみなさない
WORDCHARS="$WORDCHARS|:"

# # Use Vim like key bindings during completion.
# zmodload zsh/complist
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
#
#Apply zsh completion to alias
setopt NO_COMPLETE_ALIASES

#タブキーの連打で自動的にメニュー補完
setopt AUTO_MENU
#/foo/barでいきなりcd
setopt AUTO_CD
#"~$var" でディレクトリにアクセス
setopt AUTO_NAME_DIRS
#補完が/で終って、つぎが、語分割子か/かコマンドの後(;とか&)だったら、補完末尾の/を取る
unsetopt AUTO_REMOVE_SLASH
#曖昧な補完で、自動的に選択肢をリストアップ
setopt AUTO_LIST
#変数名を補完する
setopt AUTO_PARAM_KEYS
#プロンプト文字列で各種展開を行なう
setopt PROMPT_SUBST
# サスペンド中のプロセスと同じコマンド名を実行した場合はリジュームする
setopt AUTO_RESUME
#rm * などの際確認しない
setopt rm_star_silent
#ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt MARK_DIRS
#明確なドットの指定なしで.から始まるファイルをマッチ
#rm *で確認
unsetopt RM_STAR_WAIT
#行の末尾がバッククォートでも無視する
setopt SUN_KEYBOARD_HACK
#~hoge以外にマッチする機能を使う
setopt EXTENDED_GLOB
#補完対象のファイルの末尾に識別マークをつける
setopt LIST_TYPES
#BEEPを鳴らさない
setopt NO_BEEP
#補完候補など表示する時はその場に表示し、終了時に画面から消す
setopt ALWAYS_LAST_PROMPT
#cd kotaで/home/kotaに移動する
setopt CDABLE_VARS
#クォートされていない変数拡張が行われたあとで、フィールド分割
setopt SH_WORD_SPLIT
#定義された全ての変数は自動的にexportする!! Copy & Paste 時に Segmentationfault を起こすので無効化
# setopt ALL_EXPORT
#ディレクトリ名を補完すると、末尾がスラッシュになる。
setopt AUTO_PARAM_SLASH
#普通のcdでもスタックに入れる
setopt AUTO_PUSHD
#コマンドのスペルの訂正を使用する
setopt CORRECT
#aliasを展開して補完
unsetopt complete_aliases
#"*" にドットファイルをマッチ
unsetopt GLOB_DOTS
#補完候補を詰めて表示
setopt LIST_PACKED
#ディレクトリスタックに、同じディレクトリを入れない
setopt PUSHD_IGNORE_DUPS
#補完の時にベルを鳴らさない
setopt NO_LIST_BEEP
#^Dでログアウトしないようにする
unsetopt IGNORE_EOF
#ジョブの状態をただちに知らせる
setopt NOTIFY
#複数のリダイレクトやパイプに対応
setopt MULTIOS
#ファイル名を数値的にソート
setopt NUMERIC_GLOB_SORT
#リダイレクトで上書き禁止
unsetopt NOCLOBBER
#=以降でも補完できるようにする
setopt MAGIC_EQUAL_SUBST
#補完候補リストの日本語を正しく表示
setopt PRINT_EIGHT_BIT
#右プロンプトに入力がきたら消す
setopt TRANSIENT_RPROMPT
#戻り値が0以外の場合終了コードを表示
unsetopt PRINT_EXIT_VALUE
#echo {a-z}などを使えるようにする
setopt BRACE_CCL
#!!などを実行する前に確認する
setopt HISTVERIFY
#余分な空白は詰めて記録
setopt HIST_IGNORE_SPACE
#ヒストリファイルを上書きするのではなく、追加するようにする
setopt APPEND_HISTORY
#ジョブがあっても黙って終了する
setopt NO_CHECK_JOBS
#ヒストリに時刻情報もつける
setopt EXTENDED_HISTORY
#履歴がいっぱいの時は最も古いものを先ず削除
setopt HIST_EXPIRE_DUPS_FIRST
#履歴検索中、重複を飛ばす
setopt HIST_FIND_NO_DUPS
#ヒストリリストから関数定義を除く
setopt HIST_NO_FUNCTIONS
#前のコマンドと同じならヒストリに入れない
setopt HIST_IGNORE_DUPS
#重複するヒストリを持たない
setopt HIST_IGNORE_ALL_DUPS
#ヒストリを呼び出してから実行する間に一旦編集可能
unsetopt HIST_VERIFY
#履歴をインクリメンタルに追加
setopt INC_APPEND_HISTORY
#history コマンドをヒストリに入れない
setopt HIST_NO_STORE
#履歴から冗長な空白を除く
setopt HIST_REDUCE_BLANKS
#改行コードで終らない出力もちゃんと出力する
setopt NO_PROMPTCR
#loop の短縮形を許す
setopt SHORT_LOOPS
#コマンドラインがどのように展開され実行されたかを表示する
unsetopt XTRACE
#ディレクトリの最後のスラッシュを自動で削除
unsetopt AUTOREMOVESLASH
#シンボリックリンクは実体を追うようになる
unsetopt CHASE_LINKS
#履歴を共有
setopt SHARE_HISTORY
#$0 にスクリプト名/シェル関数名を格納
setopt FUNCTION_ARGZERO
#Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
setopt NO_FLOW_CONTROL
#コマンドラインでも # 以降をコメントと見なす
setopt INTERACTIVE_COMMENTS
#デフォルトの複数行コマンドライン編集ではなく、１行編集モードになる
unsetopt SINGLE_LINE_ZLE
#語の途中でもカーソル位置で補完
setopt COMPLETE_IN_WORD
#バックグラウンドジョブが終了したらすぐに知らせる。
setopt NO_TIFY
#改行が存在しない標準出力がある場合、自動的に特殊文字で改行する。
setopt prompt_cr prompt_sp

##################################
###### Git related Settings ######
##################################
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' max-exports 6 # formatに入る変数の最大数
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%b@%r' '%c' '%u'
zstyle ':vcs_info:git:*' actionformats '%b@%r|%a' '%c' '%u'
setopt prompt_subst
function vcs_echo {
  local st branch color
  STY= LANG=en_US.UTF-8 vcs_info
  st=`git status 2> /dev/null`
  if [[ -z "$st" ]]; then return; fi
  branch="$vcs_info_msg_0_"
  if   [[ -n "$vcs_info_msg_1_" ]]; then color=${fg[green]} #staged
  elif [[ -n "$vcs_info_msg_2_" ]]; then color=${fg[red]} #unstaged
  elif [[ -n `echo "$st" | grep "^Untracked"` ]]; then color=${fg[yellow]} # untracked
  else color=${fg[cyan]}
  fi
  echo "%{$color%}%F{5}[git:%f%{$branch%}%{$reset_color%}%F{5}]%f" | sed -e s/@/"%F{yellow}@%f%{$color%}"/
}

#  Disable as of 2017/05/08
#  ###################################
#  ####### Vi related Settings #######
#  ###################################
#  
#  function echo_red {
#  	echo -ne "\033[31m$1\033[0m"
#  }
#  
#  function echo_blue {
#  	echo -ne "\033[34m$1\033[0m"
#  }
#  
#  #enable Vi mode
#  bindkey -v
#  set editing-mode vi
#  set blink-matching-paren on
#  
#  # Please refer to man zshcontrib
#  autoload edit-command-line
#  zle -N edit-command-line
#  bindkey -M vicmd v edit-command-line
#  
#  function get_vim_state {
#    case $KEYMAP in
#      vicmd) echo "%F{5}[%f$(echo_red "N")%F{5}]%f" ;;
#      viins|main) echo "%F{5}[%f$(echo_blue "I")%F{5}]%f" ;;
#    esac
#  }
#  
#  function zle-line-init zle-keymap-select {
#    # RPS1=$(get_vim_state)
#    # RPS2=$RPS1
#      zle reset-prompt
#  }
#  zle -N zle-line-init
#  zle -N zle-keymap-select

#--------------------
# Zsh Appearance
#--------------------

function adjustcolor() {
  local _bgval_dec="$1"
  # 0-255 => 0-215
  _bgval_dec_clipped=$(( 215 * _bgval_dec / 255 ))
  # 0-215 => 16-231
  _bgval_dec=$(( _bgval_dec_clipped + 16))
  if (( ( _bgval_dec_clipped / 18 ) % 2 == 0 )) ;then
    _bgval_dec=$((_bgval_dec + 18))
  fi
  printf '%d\n' "$_bgval_dec"
}

function getfgcolor () {
  local _bgval_dec
  local _bgval_hex
  local _host=${HOST:-"$(hostname)"}
  local _hash_exec
  if type sha1sum &> /dev/null; then
    _hash_exec=sha1sum
  elif type shasum &> /dev/null; then
    _hash_exec=shasum
  fi
  _bgval_hex=$(printf "%s\\n" "$_host" | eval "$_hash_exec" | cut -c1-2)
  _bgval_dec=$(adjustcolor "$((16#$_bgval_hex))")
  printf "%s" "$_bgval_dec"
}

_UNIQ_FGCOLOR=$(getfgcolor)

# Prompot appearance
new_line='
'
# unamestr is defined in .bashrc
if [[ $unamestr == 'Darwin' ]]; then
  # If there is not a new line at the end of the output,
  # Shows emoji "END" at the end of the result.
  END_MARK=$'\xf0\x9f\x94\x9a'
  export PROMPT_EOL_MARK="%K{3}$END_MARK %K%{$reset_color%}"
  PROMPT='${new_line}%{$fg[green]%}%B%~%b $(vcs_echo)${new_line}%(!.%F{red}#%f.$)%b %{$reset_color%}'
  # RPROMPT="git:"
elif [[ $unamestr == 'CYGWIN' ]]; then
  # Simple one
  # Above prompt is too heavy for cygwin...
  PROMPT='%F{5}%f%{$fg[green]%}%B%~%b%F{5}%f%(!.%F{red}#%f.$)%b '
elif [[ $unamestr == 'Linux' ]]; then
  if grep -q Microsoft /proc/version 2> /dev/null ;then
    PROMPT='${new_line}%{$fg[green]%}%B%~%b $(vcs_echo)${new_line}%(!.%F{red}#%f.$)%b '
  else
    # Simple one
    PROMPT='${new_line}%F{${_UNIQ_FGCOLOR}}%B%~%b%f $(vcs_echo)${new_line}%(!.%F{red}#%f.$)%b '
  fi
fi

# From: http://qiita.com/mollifier/items/b72a108daab16a18d34a
# helper function to autoload
# Example 1 : zload ~/work/function/_f
# Example 2 : zload *
function zload {
    if [[ "${#}" -le 0 ]]; then
        echo "Usage: $0 PATH..."
        echo 'Load specified files as an autoloading function'
        return 1
    fi

    local file function_path function_name
    for file in "$@"; do
        if [[ -z "$file" ]]; then
            continue
        fi

        function_path="${file:h}"
        function_name="${file:t}"

        if (( $+functions[$function_name] )) ; then
            # "function_name" is defined
            unfunction "$function_name"
        fi
        FPATH="$function_path" autoload -Uz +X "$function_name"

        if [[ "$function_name" == _* ]]; then
            # "function_name" is a completion script

            # fpath requires absolute path
            # convert relative path to absolute path with :a modifier
            fpath=("${function_path:a}" $fpath) compinit
        fi
    done
}

# if (which zprof > /dev/null) ;then
#       zprof | less
# fi
