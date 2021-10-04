set modelines=0

"""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.local/share/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'tomasr/molokai'
Plug 'itchyny/lightline.vim'
Plug 'w0rp/ale'
Plug 'maximbaz/lightline-ale'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }

" Initialize plugin system
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""

" https://github.com/jeffkreeftmeijer/neovim-sensible/blob/master/plugin/neovim-sensible.vim
"
" Use hybrid (both absolute and relative) line numbers
set number relativenumber

" Use the system clipboard
set clipboard=unnamed

" Use a color column on the 80-character mark
set colorcolumn=80

" Use ,, to switch between buffers
nnoremap <leader><leader> :b#<CR>

" Show `▸▸` for tabs: 	, `·` for tailing whitespace:
set list listchars=tab:▸▸,trail:·


" Use true colors in terminal
set termguicolors
" Load syntax highlighting theme if supports >256 colors
if &t_Co >= 256 || has("gui_running")
    colorscheme molokai
endif

" Enable trackpad/mouse selection and scrolling
set mouse=a

" Reload files modified outside of vim if not modified in vim
"
set autoread
" http://stackoverflow.com/questions/2490227/how-does-vims-autoread-work#20418591
au FocusGained,BufEnter * :silent! !


" Ignore case if search pattern is lower case, else match case
set smartcase

" Set infinite undo
set undolevels=1000

" Change terminal title
set title

" Spell-check Markdown files
autocmd FileType markdown setlocal spell


"""""""""""""""""""""""""""""""""""""""""""""""""""
"               PLUGIN CONFIGURATIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-airline
set noshowmode


" vim-gitgutter
let g:gitgutter_updatetime = 750


" ale
"
" Enable completion where available.
let g:ale_completion_enabled = 1


" lightline-ale
let g:lightline = {}

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }
let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ]] }

" nvim-telescope/telescope.nvim
"
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>


" gelguy/wilder.nvim
"
call wilder#setup({'modes': [':', '/', '?']})

"""""""""""""""""""""""""""""""""""""""""""""""""""

" General keybindings
"
" Quickly edit/reload vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Clear searches with leader+space
nnoremap <leader><space> :noh<CR>

" Remap : to ; for easier vim commands
nnoremap ; :
