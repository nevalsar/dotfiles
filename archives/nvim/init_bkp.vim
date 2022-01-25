set modelines=0

"""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.local/share/nvim/plugged')

" Appearance
Plug 'croaker/mustang-vim'
Plug 'tomasr/molokai'
Plug 'dracula/vim'
Plug 'altercation/vim-colors-solarized'
Plug 'nathanaelkane/vim-indent-guides'

" IDE plugins
Plug 'tpope/vim-vinegar'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle'}
Plug 'vim-airline/vim-airline'
Plug 'majutsushi/tagbar'
Plug 'neomake/neomake'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/tComment'
Plug 'wellle/targets.vim'

" Language and syntax highlighting
Plug 'kchmck/vim-coffee-script'
Plug 'digitaltoad/vim-jade'

" Git plugins
Plug 'airblade/vim-gitgutter'

" Initialize plugin system
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""


" Use true colors in terminal
set termguicolors
" Load syntax highlighting theme if supports >256 colors
if &t_Co >= 256 || has("gui_running")
    colorscheme dracula
endif

" Enable trackpad/mouse scrolling
set mouse=a

set omnifunc=syntaxcomplete#Complete    " Set up autocomplete
hi Normal ctermbg   =none              " Make brackground transparent
set colorcolumn     =80
set fileformat      =unix
set fileformats     =unix,dos
set encoding        =utf-8
set nowrap                              " don't wrap lines
set number                              " show line numbers
set relativenumber                      " show relative line numbers

" Remove backup options
set nobackup
set noswapfile

" Search rules
"
set ignorecase          " ignores case when searching
set ignorecase          " ignore case when searching
set smartcase           " ignore case if search pattern is all lowercase,
                        " case-sensitive otherwise

" Whitespace rules
"
set tabstop     =4      " size of a hard tabstop
set shiftwidth  =4      " size of an indent
set softtabstop =0      " a combination of spaces and tabs are used to simulate
                        " tab stops at a width other than hard tabstop
set expandtab           " convert all typed tabs to spaces
set copyindent          " copy the previous indentation on autoindenting
set shiftround          " use multiple of shiftwidth when indenting with '<'
                        " and '>'
set showmatch           " set show matching parenthesis

" Highlight whitespaces visually
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

" Set exception for html and xml
autocmd filetype html,xml set listchars-=tab:>.
autocmd filetype js,coffee set shiftwidth=2

set undolevels=1000     " increase levels of undo
set title               " change the terminal's title


" Wildignore rules to restrict matching
"
set wildignore +=node_modules                       " node_modules folder
set wildignore +=.hg,.git,.svn                      " VCS folders
set wildignore +=*.aux,*.out,*.toc                  " Latex Indermediate files
set wildignore +=*.jpg,*.bmp,*.gif,*.png,*.jpeg     " Binary Images
set wildignore +=*.o,*.obj,*.exe,*.dll,*.manifest   " Compiled Object files
set wildignore +=*.sw?                              " Vim swap files
set wildignore +=*.DS_Store                         " OSX files
set wildignore +=*.luac                             " Lua byt code
set wildignore +=migrations                         " Django migrations
set wildignore +=*.pyc                              " Python Object codes
set wildignore +=*.orig                             " Merge resolution files

" Save file as root after opening a file without root privileges
cmap w!! w !sudo tee % >/dev/null

" http://robots.thoughtbot.com/5-useful-tips-for-a-better-commit-message
autocmd Filetype gitcommit setlocal spell textwidth=72

" https://robots.thoughtbot.com/opt-in-project-specific-vim-spell-checking-and-word-completion
autocmd BufRead,BufNewFile *.md set filetype=markdown

" Spell-check Markdown files
autocmd FileType markdown setlocal spell

" Overwrite original inode for crontab files
autocmd FileType crontab setlocal bkc=yes

" Splits
set splitbelow
set splitright

" Split navigation commands
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


"""""""""""""""""""""""""""""""""""""""""""""""""""
"               PLUGIN CONFIGURATIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""


" vim-indent-guides
"
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup=1


" vim-airline
"
let g:airline#extensions#tabline#enabled=1


" vim-gitgutter
"
let g:gitgutter_updatetime = 750


" Neomake
"
" When writing a buffer, and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 750)
" open list window automatically
let g:neomake_open_list = 2


" Toggle Tagbar
nmap <F8> :TagbarToggle<CR>


" Toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""

" Keybindings
"

" Map leader to custom kev
let mapleader = ","

" Buffer navigation key-bindings
nmap <leader>p :bprevious<CR>
nmap <leader>n :bnext<CR>

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Remap : to ; for easier vim commands
nnoremap ; :

" Easy toggle word wrap
map <F7> :set wrap!<cr>

" Clear out search with leader+space
nnoremap <leader><space> :noh<cr>

" Map cut and paste actions
vnoremap <C-c> "+y
vnoremap <C-x> "+x
vnoremap <C-v> "+gP

