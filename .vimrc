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
set ttimeoutlen=10 "wait up to 10ms after Esc for special key


"Remap keys, meaning: n(normal-mode) nore(non-recursive) map(mapping)
"search in 3 modes
nnoremap <c-f> /
inoremap <c-f> <Esc>/
vnoremap <c-f> <Esc>/

"save in 3 modes
nnoremap <c-s> :w<CR> "normal mode: save
inoremap <c-s> <Esc>:w<CR> "insert mode: escape to normal and save
vnoremap <c-s> <Esc>:w<CR> "visual mode: escape to normal and save

"quit in normal mode
nnoremap q :q<CR>
nnoremap Q :q<CR>

"search next
map <CR> n "Enter