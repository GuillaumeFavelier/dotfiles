set nocompatible
filetype off

" nvim configuration
syntax on
set tabstop=2
set shiftwidth=2
set background=dark
set termguicolors

" maps
vmap <C-S-c> "+y
nmap <C-S-v> "+p
nmap <C-right> :tabn<CR>
nmap <C-left> :tabp<CR>
nmap <C-n> :tabedit<CR>
nmap <C-m><right> :tabm +1<CR>
nmap <C-m><left> :tabm -1<CR>
