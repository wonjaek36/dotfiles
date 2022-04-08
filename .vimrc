set nocompatible

filetype off
set rtp+=~/.vim/autoload/plug.vim

call plug#begin('~/.vim/plugged')
" NerdTree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" NerdTree Configs
" let g:loaded_nerdtree_git_status=1
let g:NERDTreeShowGitStatus=1
let g:NERDTreeGitStatusShowClean=1
let g:NERDTreeShowLineNumbers=1

" vim-fugitive
" https://github.com/tpope/vim-fugitive
" Plugin for git
Plug 'tpope/vim-fugitive'

" vim-diminactive
" https://github.com/blueyed/vim-diminactive
" Change background color depends on cursor location
Plug 'blueyed/vim-diminactive'

" vim-airline
" https://github.com/vim-airline/vim-airline
" Show status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" vim-airline configs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s:'
let g:airline#extensions#tabline#left_sep     = ''
let g:airline#extensions#tabline#left_alt_sep = ''

let g:airline_theme = 'wombat'

call plug#end()

"call vundle#begin()

"Plugin 'vundleVim/Vundle.vim'

"Plugin 'itchyny/lightline.vim'
"Plugin 'Xuyuanp/nerdtree-git-plugin'

"Plugin 'airblade/vim-gitgutter'
"Plugin 'scrooloose/syntastic'
"Plugin 'nanotech/jellybeans.vim'

"Plugin 'tmhedberg/SimpylFold'
"let g:SimpylFold_docstring_preview=1

" Plugin 'davidhalter/jedi-vim'
" let g:jedi#show_call_signatures=0
" let g:jedi#popup_select_first=0

" let g:virtualenv_auto_activate=1
" let g:pymode_folding=0
" let g:pymode_rope=0
" let g:jedi#force_py_version=3

"Plugin 'Yggdroot/indentLine'
"Plugin 'hynek/vim-python-pep8-indent'
"filetype plugin indent on
"Plugin 'nvie/vim-flake8'
"let g:syntastic_python_checkers=['flake8']

"call vundle#end()

" Keymapping

" NERDTreeKeymapping
map <Leader>nte <ESC>:NERDTree<CR>
map <Leader>ntt <ESC>:NERDTreeToggle<CR>
map <Leader>ntf <ESC>:NERDTreeFocus<CR>

nnoremap <space> za


" Python configs
au BufNewFile, BufRead *.py
                        \ set tabstop=4
                        \ set softtabstop=4
                        \ set shiftwidth=4
                        \ set textwidth=79
                        \ set expandtab
                        \ set autoindent
                        \ set fileformat=unix
                        \ set colorcolumn=80
                        \ highlight ColorColumn ctermbg=6

if $TERM == "xterm-256color"
        set t_Co=256
endif

" General configs
set encoding=utf-8
set nu
set cursorline
set hlsearch
set smartindent
set expandtab
set backspace=indent,eol,start

" Theme
syntax enable
" set background=dark

set laststatus=2
set statusline=\ %<%l:%v\ [%P]%=%a\ %h%m%r\ %F\

if has("syntax")
syntax on
endif

" let g:solarized_termcolors=256
" let g:solarized_degrade=1
" let g:solarized_termtrans=1
" let g:solarized_bold=1
" let g:solarized_visibility="high"

" colorscheme solarized


