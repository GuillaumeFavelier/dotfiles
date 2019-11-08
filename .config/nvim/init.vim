set nocompatible
filetype off

" Add the dein installation directory into runtimepath
set runtimepath+=$HOME/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.vim/dein')
  call dein#begin('~/.vim/dein')

	" User installed plugins
  call dein#add('~/.vim/dein/repos/github.com/Shougo/dein.vim')
	" autocomplete
  call dein#add('Shougo/deoplete.nvim')
	" comment code
  call dein#add('tpope/vim-commentary')
	" starting screen
  call dein#add('mhinz/vim-startify')
	" integration with git
  call dein#add('tpope/vim-fugitive')
  call dein#add('tpope/vim-rhubarb')
  call dein#add('junegunn/gv.vim')
	call dein#add('airblade/vim-gitgutter')
	" python guide enforcement
  call dein#add('nvie/vim-flake8')
	" themes
	call dein#add('tyrannicaltoucan/vim-quantum')
	call dein#add('fneu/breezy')
	call dein#add('ayu-theme/ayu-vim')
	call dein#add('whatyouhide/vim-gotham')
	" Tags
	call dein#add('majutsushi/tagbar')
	" rust stl
  call dein#add('rust-lang/rust.vim')
  call dein#add('racer-rust/vim-racer')
	" file explorer
  call dein#add('scrooloose/nerdtree')
	" line of numbers
  call dein#add('myusuf3/numbers.vim')
	" add language server protocol support: https://langserver.org/
	call dein#add('autozimu/LanguageClient-neovim', {
    \ 'rev': 'next',
    \ 'build': 'bash install.sh',
    \ })

  call dein#end()
  call dein#save_state()
endif

" plugins configuration
let g:startify_custom_header = []
let g:gitgutter_enabled = 0
let g:deoplete#enable_at_startup = 1
let g:LanguageClient_autoStart = 1
let g:python3_host_prog = '/usr/bin/python3'
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }
colorscheme gotham

" nvim configuration
syntax on
set tabstop=2
set shiftwidth=2
set background=dark
set termguicolors

" autostart
autocmd BufWritePost *.py call Flake8()
autocmd BufNewFile,BufRead *.vert set syntax=c
autocmd BufNewFile,BufRead *.frag set syntax=c

" maps
vmap <C-S-c> "+y
nmap <C-S-v> "+p
nmap <C-right> :tabn<CR>
nmap <C-left> :tabp<CR>
nmap <C-n> :tabedit<CR>
nmap <C-m><right> :tabm +1<CR>
nmap <C-m><left> :tabm -1<CR>
nnoremap <F1> :NERDTreeToggle<CR>
nnoremap <F2> :r! find . -type f<CR>
nnoremap <F3> :TagbarToggle<CR>
nnoremap <F10> :call dein#update()<CR>
