syntax on
filetype plugin indent on
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set clipboard=unnamedplus
set mouse=a
set ignorecase
set smartcase
set cursorline
set splitbelow
set splitright
set hlsearch
set incsearch

call plug#begin('~/.vim/plugged')
  
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

let g:coc_global_extensions = ['coc-clangd']
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:ale_linters = {'c': ['gcc', 'clang'], 'cpp': ['g++', 'clang++']}
let g:ale_fixers = {'c': ['clang-format'], 'cpp': ['clang-format']}
let g:ale_fix_on_save = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

map <C-p> :Files<CR>
map <C-f> :Rg<CR>

nmap <F2> :TagbarToggle<CR>

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'dracula'

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'

autocmd BufWritePost *.c,*.cpp !gcc % -o %:r && ./%:r
autocmd FocusLost,InsertLeave * silent! wall

set timeoutlen=300
set nobackup
set nowritebackup
set noswapfile

highlight Search cterm=bold ctermbg=yellow ctermfg=black
highlight Error cterm=bold ctermbg=red ctermfg=white
highlight WarningMsg ctermbg=yellow ctermfg=black

nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

let mapleader = "\<S-Space>"
nnoremap <leader>f :ALEFix<CR>
nnoremap <leader>m :w<CR>:make<CR>
nnoremap <leader>r :w<CR>:make<CR>:!./%:r<CR>
nnoremap <leader>* :let @/='\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>

colorscheme dracula

" Git shortcuts using Fugitive
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gP :Gpull<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Glog<CR>
