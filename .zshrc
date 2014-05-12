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

# prompt設定
setopt prompt_subst
setopt prompt_percent
source $HOME/dotfiles/lib/git.zsh
MODE_NORMAL_STR="%K{164}%F{241}"$ARROW_MARK"%k%f%K{164}%F{15} NORMAL %k%f%F{164}"$ARROW_MARK"%f"
MODE_INSERT_STR="%K{33}%F{241}"$ARROW_MARK"%k%f%K{33}%F{15} INSERT %k%f%F{33}"$ARROW_MARK"%f"
function get_space() {
  local HOME_DIR='' STR='' LENGTH=0 WIDTH=0 SPACES=''
  HOME_DIR=$(cd && pwd)
  STR=$(echo $1$2 | sed -e 's/%[KF]{[0-9]\+}//g' | sed -e 's/%[kfBb]//g')
  STR=$STR$(pwd | sed -e "s#${HOME_DIR}#~#" | sed -e 's#/.oh-my-zsh#ZSH#')
  LENGTH=$#STR
  WIDTH=${COLUMNS}
  (( LENGTH = ${WIDTH} - ${LENGTH} - 1))
  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done
  echo $SPACES
}
function update_prompt() {
  local NORMAL_MODE=0 MODE='' PROMPT_STR='' RPROMPT_STR='' GIT_STR='' SPACE=''
  local BRANCH_BG_COLOR=256 # default(透過色)
  local BRANCH_TXT_COLOR=256 # default(透過色)
  if [ $# -eq 1 ]; then
    NORMAL_MODE=$1
  fi
  if [ ${NORMAL_MODE} -eq 1 ]; then
    MODE=${MODE_NORMAL_STR}
  else
    MODE=${MODE_INSERT_STR}
  fi
  PROMPT_STR="%K{190}%F{2} %n %k%f%K{241}%F{190}"$ARROW_MARK"%k%f%K{241}%F{15}%  %~ %k%f"${MODE}
  if $(repository_check); then

    STATUS=$(get_status)
    BRANCH_BG_COLOR=$(get_branch_bg_color ${STATUS})
    BRANCH_TXT_COLOR=$(get_branch_txt_color ${STATUS})
    GIT_STR="%F{${BRANCH_BG_COLOR}}"$RIGHT_ARROW_MARK"%f%K{${BRANCH_BG_COLOR}}%F{${BRANCH_TXT_COLOR}} ${BRANCH_MARK} $(get_branch_name)%f${STATUS}%F{${BRANCH_TXT_COLOR}} %B$(git_dirty_check) %b%k%f"
  fi
  RPROMPT_STR=${GIT_STR}"%K{${BRANCH_BG_COLOR}}%F{15}"$RIGHT_ARROW_MARK"%k%f%K{15}%F{0}%B %T %k%f%b » "
  SPACE=$(get_space ${PROMPT_STR} ${RPROMPT_STR})
  PROMPT=${PROMPT_STR}${SPACE}${RPROMPT_STR}
}
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
    history 99999 | sort -k 2 | uniq -f 2 | sort | grep --color=always -i $1 | less -R
  else
    echo '\e[4;31;49m[ERROR]\e[m検索する文字列を入れてください。'
  fi
}
# psのgrep
function psgrep() {
  if [ $# -eq 1 ]; then
    ps aux | grep --color=always -i $1 | less -R
  else
    echo '\e[4;31;49m[ERROR]\e[m検索する文字列を入れてください。'
  fi
}
# llの再帰的表示
function lll() {
  if [ $# -eq 1 ]; then
    ll **/* | grep --color=always -i $1 | less -R
  else
    ll **/* | less -R
  fi
}
# 色
autoload -U colors && colors
# 強力な補完機能
autoload -U compinit
compinit -u
# コマンド訂正機能
# setopt correct
# リストを詰めて表示
setopt list_packed
# 補完一覧ファイル種別表示
setopt list_types
# 補完候補を矢印キーなどで選択
zstyle ':completion:*:default' menu select
# historyファイル
HISTFILE=~/.zsh_history
# ファイルサイズ
HISTSIZE=99999
# saveする量
SAVEHIST=99999
# 重複を記録しない
setopt hist_ignore_dups
# スペース排除
setopt hist_reduce_blanks
# 履歴ファイルを共有
setopt share_history
# zshの開始終了を記録
setopt EXTENDED_HISTORY
# 補完候補表示
setopt auto_list
# 補完候補の種類分け
setopt list_types

# 補完候補の色づけ
eval `dircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 補完候補をキャッシュ
zstyle ':completion:*' use-cache true
# 補完候補でオプション表示区切り線
zstyle ':completion:*' list-separator '-->'
# 詳細な情報を使う
zstyle ':completion:*' verbose yes

# コマンドがインストールされていなかった場合の設定
[ -f /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found
# 個別の依存ファイルの読み込み
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
