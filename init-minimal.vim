" Configuration file for vim
set modelines=0     " CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility " remove change the following statements
set nocompatible    " Use Vim defaults instead of 100% vi compatibility
set backspace=2     " more powerful backspacing
set foldmethod=indent
set foldlevel=99
set foldenable
set nu
set rnu
set cursorline
set showcmd
set wrap
set wildmenu
set scrolloff    =7
set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set smarttab
set tabstop      =4
set shiftwidth   =4        " >> indents by 4 spaces.
set shiftround             " >> indents to next multiple of 'shiftwidth'.
set softtabstop  =4        " Tab key indents by 4 spaces.
set list
set listchars=tab:‣\ ,trail:▫,precedes:«,extends:»
set encoding=utf-8
set hidden
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set timeoutlen=500
set statusline+=%F
set laststatus=2
set hlsearch
set incsearch
set ignorecase
set smartcase
set mouse=a
syntax on

let mapleader="\<space>"
inoremap jk <esc>

map <up> <c-w>k
map <down> <c-w>j
map <left> <c-w>h
map <right> <c-w>l

map <Space><Space> <Esc>/<++><CR>:nohlsearch<CR>"0c4l

inoremap <c-k> <c-o>d$
inoremap <c-d> <c-o>s

map tu :tabe<CR>

nmap Q :q<CR>
nmap <leader>Q :q!<CR>
nmap W :w<CR>
nmap <Leader>W :wa<CR>

nmap <M-C-d> $a;<Esc>o
imap <M-C-d> <Esc>:call nvim_input("<M-C-d>")<CR>

nmap <M-]> :tabn<CR>
nmap <M-[> :tabp<CR>
nmap <silent> <leader>Tl :call OpenARightTerm("l")<CR>
nmap <silent> <leader>Tj :call OpenARightTerm("j")<CR>
tnoremap <Esc> <C-\><C-n>
