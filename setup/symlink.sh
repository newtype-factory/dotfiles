#!/bin/bash

# 既に存在する場合は処理スキップ
dotfiles=".zshrc .vimrc .screenrc"
for dotfile in $dotfiles
do
  if [ ! -f ~/${dotfile} ]; then
    ln -s ~/dotfiles/${dotfile} ~/
    source ~/${dotfile} 2> /dev/null
  else
    echo "[info] ${dotfile} file already exists"
  fi
done
echo 'Create a symlink is complete!'
