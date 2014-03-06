#!/bin/bash

# インストールチェック
directory=~/.vim/bundle
if [ -d ${directory}/neobundle.vim ]; then
  echo '[info] it is already installed'
  exit
fi
if [ ! -d $directory ]; then
  mkdir -p $directory
fi
# NeoBundleのインストール
git clone git://github.com/Shougo/neobundle.vim ${directory}/neobundle.vim
echo 'Installation of NeoBundle is complete!'
echo 'Please Run the following command to launch the vim!'
echo ':NeoBundleInstall'
