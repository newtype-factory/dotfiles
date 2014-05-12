# My Dotfiles

## 内容
zsh(+oh-my-zsh),screen,vimの環境構築用

## 設定方法
```
$ cd
$ git clone https://github.com/newtype-factory/dotfiles
$ cd dotfiles
$ ./symlink.sh
$ ./vim-neobundle.sh
$ ./vim-colorscheme.sh
$ ./oh-my-zsh.sh
$ cp .zshrc_local.sample ~/.zshrc_local
```

## NeoBundleのインストール
```
$ vim
vim上で以下コマンドを打ってインストール
:NeoBundleInstall
```

## サーバ依存のあるzshの設定
```
$ vi ~/.zshrc_local
```
