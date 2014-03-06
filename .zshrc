# PROMPT表示
PS1="[${USER}@${HOST%%.*} %1~]%(!.#.$) "

#autoload -Uz vcs_info
#zstyle ':vcs_info:*' formats '(%s)-[%b]'
#zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
#precmd () {
#    psvar=()
#    LANG=en_US.UTF-8 vcs_info
#    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
#}
#RPROMPT="%1(v|%F{green}%1v%f|)"

autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null
function rprompt-git-current-branch {
  local name st color gitdir action
  if [[ "$PWD" =~ '/¥.git(/.*)?$' ]]; then
    return
  fi
  name=`git rev-parse --abbrev-ref=loose HEAD 2> /dev/null`
  if [[ -z $name ]]; then
    return
  fi

  gitdir=`git rev-parse --git-dir 2> /dev/null`
  action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"

  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=%F{green}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=%F{yellow}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=%B%F{red}
  else
     color=%F{red}
  fi

  echo "$color$name$action%f%b "
}
# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst
# 右端の表示
RPROMPT='[`rprompt-git-current-branch`%~]'

# 日本語環境
export LANG=ja_JP.UTF-8

# KEYBIND
bindkey -v

# ls拡張
alias ls='ls --color=auto'
alias ll='ls -la'
# ファイル操作の強制確認
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
# find(sudoで隅々まで)
alias find='sudo find'

autoload -U colors
colors
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
HISTSIZE=10000
# saveする量
SAVEHIST=10000
# 重複を記録しない
setopt hist_ignore_dups
# スペース排除
setopt hist_reduce_blanks
# 履歴ファイルを共有
setopt share_history
# zshの開始終了を記録
setopt EXTENDED_HISTORY
# 色を使う
setopt prompt_subst
# 補完候補表示
setopt auto_list
# 補完候補の種類分け
setopt list_types
# 補完候補の色づけ
eval `dircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

if [ -f /etc/zsh_command_not_found ]; then
    source /etc/zsh_command_not_found
fi

# source auto-fu.zsh
if [ -f ~/.zsh/auto-fu.zsh ]; then
    source ~/.zsh/auto-fu.zsh
    function zle-line-init () {
        auto-fu-init
    }
    zle -N zle-line-init
    zstyle ':completion:*' completer _oldlist _complete
fi

# 個別の依存ファイルの読み込み
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
