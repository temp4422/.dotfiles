syntax on
set number
set showcmd
set showmatch
set tabstop=2
set incsearch
set hlsearch
set laststatus=2
set statusline=%#PmenuSel#%F\ %=\ %p%%\ %l:%c\  
set visualbell
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set mouse=a
set timeoutlen=10
set ttimeoutlen=10 " wait up to 10ms after Esc for special key

"Remap keys
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

map <Enter> n

"set term=builtin_ansi
"set <Up>=^[[A
"set <Down>=^[[B
"set <Right>=^[[C
"set <Left>=^[[D

nnoremap <c-s> :w<CR> " normal mode: save
inoremap <c-s> <Esc>:w<CR>l " insert mode: escape to normal and save
vnoremap <c-s> <Esc>:w<CR> " visual mode: escape to normal and save


nnoremap q :q<CR> " normal mode: quit
nnoremap Q :q<CR> " normal mode: quit
