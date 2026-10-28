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
nnoremap ;f :find<Space>
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

" comment: <C-s> like Comment.nvim. vim 9.1+ ships gc/gcc, older vim gets
" a small commentstring toggle instead
silent! packadd comment
if maparg('gcc', 'n') !=# ''
  nmap <C-s> gcc
  xmap <C-s> gc
else
  function! s:ToggleComment() range abort
    let l:parts = split(empty(&commentstring) ? '# %s' : &commentstring, '%s', 1)
    let l:left = substitute(l:parts[0], '\s*$', '', '')
    let l:right = substitute(get(l:parts, 1, ''), '^\s*', '', '')
    let l:pat = '^\s*\V' . escape(l:left, '\')

    " uncomment only if every non-blank line is already commented
    let l:lines = filter(getline(a:firstline, a:lastline), 'v:val =~ "\\S"')
    let l:commented = !empty(l:lines) && empty(filter(copy(l:lines), 'v:val !~ l:pat'))

    for l:lnum in range(a:firstline, a:lastline)
      let l:line = getline(l:lnum)
      if l:line !~ '\S'
        continue
      endif
      if l:commented
        let l:line = substitute(l:line, '^\(\s*\)\V' . escape(l:left, '\') . '\m \?', '\1', '')
        if !empty(l:right)
          let l:line = substitute(l:line, '\m \?\V' . escape(l:right, '\') . '\m\s*$', '', '')
        endif
      else
        let l:line = substitute(l:line, '^\(\s*\)', '\1' . escape(l:left, '\&') . ' ', '')
        if !empty(l:right)
          let l:line .= ' ' . l:right
        endif
      endif
      call setline(l:lnum, l:line)
    endfor
  endfunction
  nnoremap <silent> <C-s> :call <SID>ToggleComment()<CR>
  xnoremap <silent> <C-s> :call <SID>ToggleComment()<CR>
endif

" ------------------------------------------------------------------ quickfix
" in the quickfix list, j/k (J/K by 5) open the item and come back, D drops it
function! s:QfDelete() abort
  let l:items = getqflist()
  let l:line = line('.')
  call remove(l:items, l:line - 1)
  call setqflist(l:items, 'r')
  if empty(l:items)
    return
  endif
  call cursor(min([l:line, len(l:items)]), 1)
  execute "normal! \<CR>\<C-w>j"
endfunction

function! s:QfMaps() abort
  nnoremap <buffer> <silent> j j<CR><C-w>j
  nnoremap <buffer> <silent> k k<CR><C-w>j
  nnoremap <buffer> <silent> J 5j<CR><C-w>j
  nnoremap <buffer> <silent> K 5k<CR><C-w>j
  nnoremap <buffer> <silent> D :call <SID>QfDelete()<CR>
endfunction

" ------------------------------------------------------------------ filetypes



function! s:Osc52Yank() abort
    if v:event.operator !=# 'y'
        return
    endif
    if v:event.regname !=# '' && v:event.regname !=# '+' && v:event.regname !=# '*'
        return
    endif
    let l:text = join(v:event.regcontents, "\n")
    if v:event.regtype ==# 'V'
        let l:text .= "\n"
    endif
    let l:b64 = substitute(system('base64', l:text), '\n', '', 'g')
    let l:seq = "\e]52;c;" . l:b64 . "\x07"
    if exists('*echoraw')
        call echoraw(l:seq)
    else
        call writefile([l:seq], '/dev/tty', 'b')
    endif
endfunction

augroup mine
  autocmd!
  autocmd FileType qf call s:QfMaps()
  autocmd FileType html,css,javascript,typescript,cmake setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType c,cpp setlocal cindent cinoptions=l1,(s)
  autocmd FileType netrw nmap <buffer> f <CR>
  autocmd TextYankPost * call s:Osc52Yank()
augroup END
