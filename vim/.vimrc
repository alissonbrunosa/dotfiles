call plug#begin()
" Tools
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'

Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'airblade/vim-gitgutter'

" Go plugins
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Themes
Plug 'vim-airline/vim-airline'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'alissonbrunosa/black'
call plug#end()

syntax on
colorscheme catppuccin_mocha

set nocompatible
set number
set relativenumber
set cursorline
set hidden
set ruler
set exrc
set secure
set incsearch
set noshowmode
set list
set showcmd
set listchars=eol:⏎,tab:···,trail:·,extends:>,precedes:<
set showbreak=↪\
set ignorecase
set smartcase
set hlsearch
set scrolloff=30
set clipboard=unnamedplus
set backupdir=/tmp
set directory=/tmp
set tags+=.git/tags
set autoread
set backspace=indent,eol,start


if has('gui_running')
  set guifont=JetBrains\ Mono\ Bold\ 12
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left hand scroll bar
  set guioptions-=b  "remove bottom scroll bar
  set guioptions-=m  "remove bottom menu bar
endif

if has("termguicolors")
  set termguicolors
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
endif


augroup filetypedetect
" Iracema
au BufNewFile,BufRead *.ir setf iracema
augroup END
