

" ===== 基本設定 =====
set number          " 行番号表示
set cursorline      " カーソル行をハイライト
set expandtab       " タブをスペースに変換
set tabstop=2       " タブ幅2（Terraform標準）
set shiftwidth=2    " インデント幅2
set autoindent      " 自動インデント
set smartindent     " スマートインデント
set hlsearch        " 検索結果をハイライト
set incsearch       " インクリメンタルサーチ
set ignorecase      " 検索で大文字小文字を無視
set smartcase       " 大文字を含む場合は区別
set showmatch       " 対応する括弧をハイライト
set wildmenu        " コマンド補完を強化
syntax on           " シンタックスハイライト有効
filetype plugin indent on
autocmd BufNewFile,BufRead *.tf set filetype=terraform

" .terraform/や.tfstateを補完・検索から除外
set wildignore+=*/.terraform/*,*.tfstate,*.tfstate.backup

" vim-plugがインストールされていない場合に自動インストール
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" ===== プラグイン =====
call plug#begin('~/.vim/plugged')

Plug 'hashivim/vim-terraform'   " シンタックス＆自動フォーマット
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

" ===== Terraform設定 =====
let g:terraform_fmt_on_save = 1  " 保存時に自動でterraform fmt
let g:terraform_align = 1        " インデント自動整列

" ===== LSP設定 =====
if executable('terraform-ls')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'terraform-ls',
    \ 'cmd': {server_info->['terraform-ls', 'serve']},
    \ 'allowlist': ['terraform'],
    \ })
endif

" 補完をEnterで確定
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" ホバーで情報表示
nnoremap <leader>gh :LspHover<CR>

" 定義ジャンプ
nnoremap <leader>gd :LspDefinition<CR>
