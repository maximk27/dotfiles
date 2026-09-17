colorscheme delek

syntax on
filetype on

set ttimeout
set ttimeoutlen=10


let &t_SI = "\e[6 q" " 
let &t_EI = "\e[2 q" " 

set clipboard=unnamedplus
set tabstop=4
set shiftwidth=4
set smartindent
set scrolloff=8
set noswapfile
set backspace=indent,eol,start

set signcolumn=yes
highlight SignColumn guibg=NONE ctermbg=NONE

nnoremap ;q :q
nnoremap ;w :w


nnoremap <Down> 5j
nnoremap <Up> 5k
nnoremap <C-u> 10<C-y>
nnoremap <C-d> 10<C-e>


vnoremap <Down> 5j
vnoremap <Up> 5k
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
