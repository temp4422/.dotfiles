syntax on
set number
set showcmd
set showmatch
set tabstop=2
set incsearch
set hlsearch
set laststatus=2
set statusline=%#PmenuSel#%F\ %=\ %p%%\ %l:%c\  
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
map <Enter> n
set visualbell
"set term=builtin_ansi
"set <Up>=^[[A
"set <Down>=^[[B
"set <Right>=^[[C
"set <Left>=^[[D
set mouse=a
