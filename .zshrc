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
# historyのgrep
alias hgrep='history -99999 | grep'

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

# 個別の依存ファイルの読み込み
[ -f ~/.zshrc_local ] && source ~/.zshrc_local
