colorscheme slate

syntax on
filetype on

set ttimeout
set ttimeoutlen=10

set clipboard=unnamedplus
set tabstop=4
set shiftwidth=4
set smartindent
set scrolloff=8
set noswapfile
set backspace=indent,eol,start

set signcolumn=yes
highlight SignColumn guibg=NONE ctermbg=NONE

inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-e> <End>

nnoremap ;q :q
nnoremap ;w :w

nnoremap v V
nnoremap V v

nnoremap <ESC>j 5j
nnoremap <ESC>k 5k
nnoremap <C-u> 10<C-y>
nnoremap <C-d> 10<C-e>


vnoremap <ESC>j 5j
vnoremap <ESC>k 5k
vnoremap <C-u> 10<C-y>
vnoremap <C-d> 10<C-e>


inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

nnoremap - :Exp<CR>
nnoremap _ :e!<CR>
