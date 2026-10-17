" plain vim for remotes: syntax + solarized, mirrors the nvim mine/ settings.
" colors: ~/.vim/colors/solarized-autumn.vim, or the nvim repo's export.

syntax on
filetype plugin indent on

set ttimeout
set ttimeoutlen=10

let &t_SI = "\e[6 q" "
let &t_EI = "\e[2 q" "

" ------------------------------------------------------------------ colors
" truecolor (the export only has gui colors), incl. inside tmux
if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=light
try
  colorscheme solarized-autumn
catch
  if filereadable(expand('~/.config/nvim/colors/solarized-autumn.vim'))
    source ~/.config/nvim/colors/solarized-autumn.vim
  else
    colorscheme delek
  endif
endtry

" ------------------------------------------------------------------ settings
if has('clipboard')
  set clipboard=unnamedplus
endif
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set autoindent
set scrolloff=8
set noswapfile
set backspace=indent,eol,start
set hlsearch
set incsearch
set ignorecase
set nowrap
set cursorline
set splitbelow
set splitright
set numberwidth=3

set undofile
set undodir=~/.vim/undo//
if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p')
endif

set signcolumn=yes
highlight SignColumn guibg=NONE ctermbg=NONE

set listchars=tab:>\ ,trail:·,nbsp:+
silent! set fillchars+=eob:\

set laststatus=2
set statusline=\ %f\ %m%r\ %=\ %Y\

" ;f / ;g like telescope
set path=.,**
set wildmenu
set wildignore+=*.o,*.out,*/.git/*,*/build/*,*/__pycache__/*,*/venv/*,*/.venv/*
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

function! s:Grep() abort
  let l:pattern = input('Grep: ')
  if empty(l:pattern)
    return
  endif
  execute 'silent grep! ' . shellescape(l:pattern)
  copen
  redraw!
endfunction

" ------------------------------------------------------------------ maps
let mapleader = " "

" stop pinky hurt
nnoremap ;q :q
nnoremap ;w :w

" reset
nnoremap _ :e!<CR>

" insert blank line above
nnoremap <C-n> :call append(line('.') - 1, '')<CR>

" scrolling
nnoremap <Down> 5j
nnoremap <Up> 5k
nnoremap <C-u> 10<C-y>
nnoremap <C-d> 10<C-e>

vnoremap <Down> 5j
vnoremap <Up> 5k
vnoremap <C-u> 10<C-y>
vnoremap <C-d> 10<C-e>

" indent
vnoremap > >gv
vnoremap < <gv

inoremap <C-c> <Esc>

" window
nnoremap <Left> <C-w>h
nnoremap <Right> <C-w>l

nnoremap <leader>l :set number!<CR>

" search
nnoremap ;f :find
nnoremap ;g :call <SID>Grep()<CR>
nnoremap ;z :browse oldfiles<CR>

" harpoon-ish: m{key} / '{key} use global (uppercase) marks
nnoremap mm mM
nnoremap '' 'M
for s:key in split('qwerasdfzxcv', '\zs')
  execute 'nnoremap m' . s:key . ' m' . toupper(s:key)
  execute "nnoremap '" . s:key . " '" . toupper(s:key)
endfor

" pairs
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" file hub
nnoremap - :Exp<CR>

" ------------------------------------------------------------------ filetypes
augroup mine
  autocmd!
  autocmd FileType html,css,javascript,typescript,cmake setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType c,cpp setlocal cindent cinoptions=l1,(s
augroup END
