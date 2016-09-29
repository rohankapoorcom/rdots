" Vundle Setup
set nocompatible            " be improved
filetype off                " required! for vundle
set rtp+=~/.vim/bundle/Vundle.vim

"Vundle Bundles
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'vim-airline/vim-airline'
" themes
Plugin 'vim-airline/vim-airline-themes'
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

call vundle#end()

" Colors
:silent! colorscheme Tomorrow-Night-Bright
let g:airline_theme = 'tomorrow'

" Tab Indenting Controls
set expandtab " Convert tabs to spaces
set smarttab
set softtabstop=4 " Number of spaces in tab when editing
set shiftwidth=4
set tabstop=4 " Number of visual spaces per <tab>

set autoindent " Auto indent to previous level
set smartindent " Better indenting for brackets
filetype plugin indent on " Auto indenting based on file type

" UI Config
syntax on
set number
syntax on
set mouse=a
set ruler
set showmatch
set noerrorbells
set title
set cursorline
set wildmenu " Visual autocomplete for command menu
set updatetime=50
set timeoutlen=1000 ttimeoutlen=0 " No delay when switching modes
let g:gitgutter_enabled = 1

" Key Bindings
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_quit_key='<Esc>'

" Airline
set laststatus=2
let g:airline_powerline_fonts=1
let g:bufferline_echo=0
set noshowmode
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='|'
