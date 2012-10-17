set nocompatible        " use vim defaults
" set scrolloff=3       " keep 3 lines when scrolling
set ai                  " set auto-indenting on for programming

set showcmd             " display incomplete commands
"set nobackup           " do not keep a backup file
set number              " show line numbers
set ruler               " show the current row and collumn

set hlsearch            " highligh searches
set incsearch           " do incremental searches
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase is present

set visualbell t_vb=    " turn off error beep/flash
set novisualbell        " turn off visual bell

set backspace=indent,eol,start " make the backspace key work as it should

syntax on               " turn syntax highlighting on by default
filetype on             " detext type of file
filetype indent on      " load indent file for specific file type

"set autoindent          
"set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set pastetoggle=<F2>

"latex
filetype plugin on
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let Tex_UseMakefile=0
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_ViewRule_dvi='xdvi'
let g:Tex_CompileRule_dvi='latex -interaction=nonstopmode --src-specials $*'
let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode $*'
let g:Tex_MultipleCompileFormats='pdf,dvi'

