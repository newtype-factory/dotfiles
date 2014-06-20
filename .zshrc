# zshrc setting

# 日本語環境
export LANG=ja_JP.UTF-8
# ターミナル256色設定
export TERM='xterm-256color'

# oh-my-zshの設定
export ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"
plugins=(git ruby rails bundler)
source $ZSH/oh-my-zsh.sh

# viキーバインド
bindkey -v
bindkey "" history-incremental-search-backward

# prompt設定
setopt prompt_subst
setopt prompt_percent
source $HOME/dotfiles/lib/git.zsh
function get_space() {
  local USER_NAME='' HOME_DIR='' STR='' LENGTH=0 WIDTH=0 SPACES=''
  STR=$(echo $1$2 | sed -e 's/%[KF]{[0-9]\+}//g' | sed -e 's/%[kfBb]//g')
  if [ $(echo $STR | grep -c '%m') ]; then
    HOST_NAME=$(hostname -s)
    STR=$(echo $STR | sed -e "s/%m/${HOST_NAME}/g")
  fi
  if [ $(echo $STR | grep -c '%n') ]; then
    USER_NAME=$(whoami)
    STR=$(echo $STR | sed -e "s/%n/${USER_NAME}/g")
  fi
  if [ $(echo $STR | grep -c '%~') ]; then
    HOME_DIR=$(cd && pwd)
    STR=$(echo $STR | sed -e 's/%~//g')$(pwd | sed -e "s#${HOME_DIR}#~#" | sed -e "s#~/.oh-my-zsh#~ZSH#")
  fi
  (( LENGTH = $COLUMNS - $#STR - 1 ))
  if [ $LENGTH -gt 0 ]; then
    for i in {0..$LENGTH}
    do
      SPACES="${SPACES} "
    done
    echo $SPACES
    return 0
  else
    return 1
  fi
}
function update_prompt() {
  local MODE=0 MODE_STR='' PROMPT_STR='' RPROMPT_STR='' HDD='' MEMORY_INFO='' MEMORY='' STATUS='' GIT_STR='' SPACE=''
  local BRANCH_BG_COLOR=256 BRANCH_TXT_COLOR=256 # default(透過色)
  if [ $# -eq 1 ]; then
    MODE=$1
  fi
  if [ $MODE -eq 1 ]; then
    MODE_STR="%K{164}%F{241}${ARROW_MARK}%k%f%K{164}%F{15} NORMAL %k%f%F{164}${ARROW_MARK}%f"
  else
    MODE_STR="%K{33}%F{241}${ARROW_MARK}%k%f%K{33}%F{15} INSERT %k%f%F{33}${ARROW_MARK}%f"
  fi
  PROMPT_STR="%K{202}%F{190} %m%f%F{1}@%f%F{190}%n %k%f%K{241}%F{202}${ARROW_MARK}%k%f%K{241}%F{15} %~ %k%f${MODE_STR}"
  PROMPT2_STR="%K{202}%F{190} %m%f%F{1}@%f%F{190}%n %k%f%K{241}%F{202}${ARROW_MARK}%k%f%K{241}%F{15} %C %k%f${MODE_STR}"
  HDD=$(df 2>/dev/null | head -2 | tail -1 | awk '{print $5}')
  if [ -z $HDD ]; then
    HDD=$(df 2>/dev/null | head -3 | tail -1 | awk '{print $4}')
  fi
  MEMORY_INFO=$(free -t | tail -1 | awk '{ print $2 " " $3 }')
  MEMORY_INFO=${(z)MEMORY_INFO}
  MEMORY=$(echo ${MEMORY_INFO[2]} ${MEMORY_INFO[1]} | awk '{printf("%d",$1/$2*100)}')
  if $(repository_check); then
    STATUS=$(get_status)
    BRANCH_BG_COLOR=$(get_branch_bg_color ${STATUS})
    BRANCH_TXT_COLOR=$(get_branch_txt_color ${STATUS})
    GIT_STR="%F{${BRANCH_BG_COLOR}}${RIGHT_ARROW_MARK}%f%K{${BRANCH_BG_COLOR}}%F{${BRANCH_TXT_COLOR}} ${BRANCH_MARK} $(get_branch_name)${STATUS} %B$(git_dirty_check) %b%k%f"
    GIT2_STR=" %F{${BRANCH_BG_COLOR}}$(get_branch_name)%f ${STATUS}"
  fi
  RPROMPT_STR="%F{45}HDD%f:${HDD} ％ %F{200}MEMORY%f:${MEMORY}％ ${GIT_STR}%K{${BRANCH_BG_COLOR}}%F{15}${RIGHT_ARROW_MARK}%k%f%K{15}%F{0}%B %T %k%f%b » "
  RPROMPT2_STR="${GIT2_STR}
 » "
  SPACE=$(get_space ${PROMPT_STR} ${RPROMPT_STR})
  if [ $? -eq 1 ]; then
    PROMPT=${PROMPT_STR}${RPROMPT2_STR}
  else
    PROMPT=${PROMPT_STR}${SPACE}${RPROMPT_STR}
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_prompt

# vimode表示
function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    vicmd)
    update_prompt 1
    ;;
    main|viins)
    update_prompt 0
    ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# 色見本sh
source $HOME/dotfiles/lib/color.zsh

# sudoでの環境変数引継ぎ
alias sudo='sudo -E '
# ファイル操作の強制確認
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
# find(sudoで隅々まで)
alias find='sudo find'
# historyのgrep
function hgrep() {
  if [ $# -eq 1 ]; then
    history 99999 | sort -k 2 | uniq -f 2 | sort | grep --color=always -i $1
  else
    echo '\e[4;31;49m[ERROR]\e[m検索する文字列を入れてください。'
  fi
}
# psのgrep
function psgrep() {
  if [ $# -eq 1 ]; then
    ps aux | grep --color=always -i $1
  else
    echo '\e[4;31;49m[ERROR]\e[m検索する文字列を入れてください。'
  fi
}
# llの再帰的表示
function lll() {
  if [ $# -eq 1 ]; then
    ll **/* | grep --color=always -i $1
  else
    ll **/*
  fi
}

# 色設定
autoload -U colors && colors
# 強力な補完機能
autoload -U compinit
compinit -u
# ツンデレ補正
setopt CORRECT
SPROMPT="%{${fg[yellow]}%}%rじゃないの？べ、別にあんたのために修正したんじゃないからね！%{${reset_color}%}
[%rを実行(y),%Rを実行(n),編集(e),却下(a)]:"
# リストを詰めて表示
setopt LIST_PACKED
# 補完一覧ファイル種別表示
setopt LIST_TYPES
# 補完候補表示
setopt AUTO_LIST
# = 以降も補完 (--prefix=/usr)
setopt MAGIC_EQUAL_SUBST
# historyファイル
HISTFILE=~/.zsh_history
# ファイルサイズ
HISTSIZE=99999
# saveする量
SAVEHIST=99999
# 重複を記録しない
setopt HIST_IGNORE_DUPS
# スペース排除
setopt HIST_REDUCE_BLANKS
# 履歴ファイルを共有
setopt SHARE_HISTORY
# zshの開始終了を記録
setopt EXTENDED_HISTORY
# ビープOFF
setopt NOBEEP

# 補完候補の色づけ
eval `dircolors`
export ZLS_COLORS=$LS_COLORS
# 補完候補を矢印キーなどで選択
zstyle ':completion:*:default' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 補完候補をキャッシュ
zstyle ':completion:*' use-cache true
# 補完候補でオプション表示区切り線
zstyle ':completion:*' list-separator '-->'
# 詳細な情報を使う
zstyle ':completion:*' verbose yes

# screenのウィンドウへ実行コマンドを表示
if [ ${STY} ]; then
  preexec() {
    echo -ne "\ek${1%% *}\e\\"
  }
  precmd() {
    echo -ne "\ek$(hostname)\e\\"
  }
fi

# コマンドがインストールされていなかった場合の設定
[ -f /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found
# 個別の依存ファイルの読み込み
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
