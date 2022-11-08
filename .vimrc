syntax on
set number
set showcmd
set showmatch
set tabstop=2
set incsearch
set hlsearch
set laststatus=2 "always display status line
set statusline=%#PmenuSel#%F\ %=\ %p%%\ %l:%c
set visualbell
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set mouse=a
set timeoutlen=10
set ttimeoutlen=10 "wait up to 10ms after Esc for special key

"copy to windows clipboard
if system('uname -r') =~ "microsoft"
    augroup Yank
        autocmd!
        autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
        augroup END
endif


"Remap keys, meaning: n(normal-mode) nore(non-recursive) map(mapping)
"search in 3 modes
nnoremap <c-f> /
inoremap <c-f> <Esc>/
vnoremap <c-f> <Esc>/

"save
nnoremap <c-s> :w<CR> "normal mode: save
inoremap <c-s> <Esc>:w<CR> "insert mode: escape to normal and save
vnoremap <c-s> <Esc>:w<CR> "visual mode: escape to normal and save

"quit
nnoremap q :q<CR>
nnoremap Q :q<CR>

"search next
map <CR> n "Enter

"redo
nnoremap <c-y> <c-r>
inoremap <c-y> <Esc><c-r>i
vnoremap <c-y> <c-r>

"undo
nnoremap <c-z> u
inoremap <c-z> <Esc>ui
vnoremap <c-z> u

"cut
nnoremap <c-x> dd
inoremap <c-x> <Esc>ui
vnoremap <c-x> dd

"copy
nnoremap <c-c> yy
inoremap <c-c> <Esc>ui
vnoremap <c-c> yy

"paste
nnoremap <c-v> pp
inoremap <c-v> <Esc>pi
vnoremap <c-v> pp