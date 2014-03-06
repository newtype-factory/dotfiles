#!/bin/bash

# インストールチェック
directory=~/.vim/bundle
if [ -d ${directory}/vim-colorschemes ]; then
  echo '[info] it is already installed'
  exit
fi
if [ ! -d $directory ]; then
  mkdir -p $directory
fi
# vim-colorschemesのインストール
git clone git://github.com/flazz/vim-colorschemes ${directory}/vim-colorschemes
ln -s ${directory}/vim-colorschemes/colors ~/.vim/colors
# フォントの透過処理(PuTTY用)
molokai=~/.vim/colors/molokai.vim
sed -i -e "s/\( \+\)hi Normal\( \+\)ctermfg=252 ctermbg=233/\1hi Normal\2ctermfg=252 ctermbg=none/i" $molokai
echo 'Installation of vim-colorschemes is complete!'
