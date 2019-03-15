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
	" python guide enforcement
  call dein#add('nvie/vim-flake8')
	" themes
	call dein#add('tyrannicaltoucan/vim-quantum')
	call dein#add('fneu/breezy')
	call dein#add('ayu-theme/ayu-vim')
	call dein#add('whatyouhide/vim-gotham')
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

let g:deoplete#enable_at_startup = 1
let g:LanguageClient_autoStart = 1
let g:python3_host_prog = '/usr/bin/python3'
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['~/.local/bin/pyls'],
    \ }

" plugins configuration
syntax on
set tabstop=2
set shiftwidth=2
set background=dark
set termguicolors
colorscheme gotham

" autostart
autocmd BufWritePost *.py call Flake8()
autocmd BufNewFile,BufRead *.vert set syntax=c
autocmd BufNewFile,BufRead *.frag set syntax=c

" maps
nnoremap <F1> :call dein#update()<CR>
nnoremap <F2> :NERDTreeToggle<CR>
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
