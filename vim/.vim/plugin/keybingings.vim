" Key Bindings
let g:mapleader = ' '
nnoremap <leader>f :Rg<space>
nnoremap <silent><leader>b :Buffers<CR>
nnoremap <silent><leader>o :Files<CR>
nnoremap <silent><leader>c :bd<CR>
nnoremap <silent><leader>w :up<CR>

nnoremap <silent><C-j> :m .+1<CR>==
nnoremap <silent><C-k> :m .-2<CR>==
inoremap <silent><C-j> <Esc>:m .+1<CR>==gi
inoremap <silent><C-k> <Esc>:m .-2<CR>==gi
vnoremap <silent><C-j> :m '>+1<CR>gv=gv
vnoremap <silent><C-k> :m '<-2<CR>gv=gv

if has("terminal")
  set termwinsize=20*0
  nnoremap <leader>t :bo terminal ++close<cr>
endif

nnoremap <leader>sw :execute ':Rg ' . expand('<cword>')<CR>

