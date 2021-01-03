call plug#begin()
Plug 'rakr/vim-one'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'thoughtbot/vim-rspec'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'alissonbrunosa/vim-wdirs', { 'do': './install' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'arcticicestudio/nord-vim', { 'tag': 'v0.15.0' }
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
set expandtab
set shiftwidth=2
set incsearch
set noshowmode
set list
set showcmd
set listchars=eol:⏎,tab:···,trail:·,extends:>,precedes:<
set showbreak=↪\
set ignorecase
set smartcase
set incsearch
set hlsearch
set scrolloff=2
set clipboard=unnamedplus
set backupdir=/tmp
set directory=/tmp
set tags+=.git/tags
set autoread
set backspace=indent,eol,start

let g:mapleader = ' '

nnoremap <silent><leader>b :Buffers<CR>
nnoremap <silent><leader>o :Files<CR>
nnoremap <silent><leader>c :bd<CR>
nnoremap <silent><leader>w :up<CR>
nnoremap <silent><leader>f :BLines<CR>
nnoremap <silent><leader>d :Wdirs<CR>

map <A-a>j <C-w>j
map <A-a>k <C-w>k
map <A-a>l <C-w>l
map <A-a>h <C-w>h
map <A-a>q <C-w>q

if has("terminal")
  map <Leader>tt :terminal ++close<cr>
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

" Ruby
augroup filetype_ruby
  autocmd!
  au BufRead,BufNewFile *.rb set expandtab
  au BufRead,BufNewFile *.rb set tabstop=2
  au BufRead,BufNewFile *.rb set softtabstop=2
  au BufRead,BufNewFile *.rb set shiftwidth=2
  au BufRead,BufNewFile *.rb set autoindent
  au         BufNewFile *.rb set fileformat=unix
augroup END

" Go
augroup filetype_go
  autocmd!
  au BufRead,BufNewFile *.go set expandtab
  au BufRead,BufNewFile *.go set tabstop=4
  au BufRead,BufNewFile *.go set softtabstop=4
  au BufRead,BufNewFile *.go set shiftwidth=4
  au BufRead,BufNewFile *.go set autoindent
  au         BufNewFile *.go set fileformat=unix
augroup END

" JSON
augroup filetype_json
  autocmd!
  au BufRead,BufNewFile *.json set expandtab
  au BufRead,BufNewFile *.json set tabstop=4
  au BufRead,BufNewFile *.json set softtabstop=2
  au BufRead,BufNewFile *.json set shiftwidth=2
  au BufRead,BufNewFile *.json set autoindent
  au         BufNewFile *.json set fileformat=unix
augroup END

let g:prettier#autoformat = 0
let g:airline_theme='nord'

autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.vue,*.yaml PrettierAsync
au WinEnter * :vertical resize 140

let g:discovery_path = "/home/alisson/code"
