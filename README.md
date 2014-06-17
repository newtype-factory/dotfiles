# My Dotfiles

## 内容
zsh(+oh-my-zsh),screen,vimの環境構築用

## 設定方法
```
$ cd
$ git clone https://github.com/newtype-factory/dotfiles
$ cd dotfiles
$ ./setup/symlink.sh
$ ./setup/vim-neobundle.sh
$ ./setup/vim-colorscheme.sh
$ ./setup/oh-my-zsh.sh
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
