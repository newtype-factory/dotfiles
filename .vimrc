colorscheme molokai
set nocompatible      " vi互換モードオフ

" プラグイン設定
filetype off
filetype plugin indent off
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
endif
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Lokaltog/powerline', { 'rtp': 'powerline/bindings/vim' }
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'scrooloose/syntastic'
let g:syntastic_check_on_open=1
let g:syntastic_auto_jump=1
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2
let g:syntastic_enable_highlighting=1
let g:syntastic_echo_current_error=1
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'scrooloose/nerdtree'
let g:NERDTreeDirArrows=0
let g:NERDTreeShowHidden=1
let g:NERDTreeWinSize=45
NeoBundle 'honza/vim-snippets'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
let g:neosnippet#enable_snipmate_compatibility=1
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
NeoBundle 'Shougo/neocomplcache'
let g:neocomplcache_enable_at_startup=1
let g:neocomplcache_force_overwrite_completefunc=1
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-rails'
NeoBundle 'thinca/vim-ref'
NeoBundle 'vim-scripts/dbext.vim'
filetype plugin indent on

" 基本設定
syntax on              " 構文の色分け
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,iso-2022-jp,ucs-2le,ucs-2,cp932
set fileformats=unix,dos,mac
set modeline          " モードラインの有効化
set nobackup          " バックアップを取らない
set autowrite         " 自動保存
set showcmd           " 入力中のコマンド表示
set showmode          " 現在のモードを表示
set history=10        " コロンコマンドの最大保存数
set showmatch         " 対応する括弧のハイライト
set number            " 行番号を表示
set cursorline        " カーソルラインの色付け
set laststatus=2      " ステータスを常に表示
set smartindent       " 高度なインデント処理
set noautoindent      " 自動インデントOFF
set tabstop=2         " タブ展開文字数
set shiftwidth=2      " インデント数
set softtabstop=2     " タブキー入力時のスペース数
set expandtab         " タブ入力を空白文字に置き換え
set smartcase         " 行頭が大文字の場合、大文字小文字区別して検索
set ignorecase        " 大文字小文字区別しない検索
set nowrapscan        " 最終検索後、先頭へループしない
set hlsearch          " 検索語句のハイライトを行う
set incsearch         " インクリメンタルサーチを行う
set title             " ファイル名の表示
set ruler             " ルーラーの表示
set t_Co=256          " 256色表示
set list
set listchars=eol:¬
set pastetoggle=<F12>

" 縦方向のカレントライン表示
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinLeave * set nocursorcolumn
  autocmd WinEnter,BufRead * set cursorline
  autocmd WinEnter,BufRead * set cursorcolumn
augroup END
" .vimrcの即時反映用
nnoremap <leader>rv :source $MYVIMRC<CR>
" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
" 末尾のスペースを表示
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
autocmd WinEnter * match WhitespaceEOL /\s\+$/
" 引数なしでvimを開いたらNERDTree起動
autocmd vimenter * if !argc() | NERDTree | endif
" インサートモードを抜けた時に色変更が遅れないようにする処理
if has('unix') && !has('gui_running')
  inoremap <silent> <Esc> <Esc>
  inoremap <silent> <C-[> <Esc>
endif
