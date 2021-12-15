call plug#begin()
" Tools
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'airblade/vim-gitgutter'

" Go plugins
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Themes
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
call plug#end()

syntax on
colorscheme nord

set nocompatible
set background=dark
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
set scrolloff=2
set clipboard=unnamedplus
set backupdir=/tmp
set directory=/tmp
set tags+=.git/tags
set autoread
set backspace=indent,eol,start

let g:mapleader = ' '

nnoremap <leader>f :Rg<space>

nnoremap <silent><leader>b :Buffers<CR>
nnoremap <silent><leader>o :Files<CR>
nnoremap <silent><leader>c :bd<CR>
nnoremap <silent><leader>w :up<CR>
nnoremap <silent><leader>d :Wdirs<CR>

if has("terminal")
  set termwinsize=20*0
  map <Leader>tt :bo terminal ++close<cr>
endif

if has('gui_running')
  set guifont=JetBrains\ Mono\ Bold\ 12
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left hand scroll bar
  set guioptions-=b  "remove bottom scroll bar
  set guioptions-=m  "remove bottom menu bar
endif

if has("termguicolors")
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:airline_theme='nord'
