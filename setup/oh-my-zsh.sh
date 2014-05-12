#!/bin/bash

# インストールチェック
directory=~/.oh-my-zsh
if [ -d ${directory} ]; then
  echo '[info] it is already installed'
  exit
fi
# oh-my-zshのインストール
git clone git://github.com/robbyrussell/oh-my-zsh ${directory}
echo 'Installation of oh-my-zsh is complete!'
