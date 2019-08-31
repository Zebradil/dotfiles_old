"===============================================================================
" Plugins
"===============================================================================
" Autoinstall vim-plug {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif
" }}}

call plug#begin('~/.local/share/nvim/plugged')
  " Some defaults from experienced users
  Plug 'tpope/vim-sensible'

  " Fully automatic identation settings
  Plug 'tpope/vim-sleuth'

  " [Un]comment lines with gc
  Plug 'tpope/vim-commentary'

  " Interactive git diff
  Plug 'airblade/vim-gitgutter'

  " Better diff options
  Plug 'chrisbra/vim-diff-enhanced'

  " Git-wrapper
  Plug 'tpope/vim-fugitive'

  " Git-commit browser
  Plug 'junegunn/gv.vim'

  Plug 'junegunn/vim-github-dashboard'

  " Colorschemes
  Plug 'chriskempson/base16-vim'

  " Distruction-free writing
  Plug 'junegunn/goyo.vim'

  " Enhancements for netrw
  Plug 'tpope/vim-vinegar'

  " Highlight current text block
  Plug 'junegunn/limelight.vim'

  " Colorize matching parenthesis
  Plug 'luochen1990/rainbow'

  " Extended suport for matching parenthesis and words
  Plug 'andymass/vim-matchup'

  " Highlight word under the cursor
  Plug 'RRethy/vim-illuminate'

  Plug 'vim-airline/vim-airline'

  Plug 'junegunn/vim-easy-align'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  "Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  "Plug 'rust-lang/rust.vim'
  "Plug 'lumiliet/vim-twig'
  "Plug 'cespare/vim-toml'
  Plug 'zebradil/hive.vim'
  Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
  Plug 'Konfekt/vim-DetectSpellLang'

if !has('mac')
  " Automatic layout switcher
  Plug 'lyokha/vim-xkbswitch'
endif

  " Language pack
  Plug 'sheerun/vim-polyglot'

  " Helm
  Plug 'towolf/vim-helm'

  " Python
  Plug 'vim-scripts/indentpython.vim'

  " Identation
  Plug 'Yggdroot/indentLine'

  " Editing helpers
  Plug 'tpope/vim-surround'

  " Syntax check
  Plug 'w0rp/ale'

  " Autoformat
  Plug 'Chiel92/vim-autoformat'

  Plug 'robertbasic/vim-hugo-helper'
call plug#end()

set mouse=a

set cursorline
set number
set relativenumber
set noshowmode
set termguicolors

" Set word highlight style to underline
hi link illuminatedWord Visual

colorscheme base16-default-dark

set exrc
set secure

"set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set laststatus=2
set updatetime=100

set diffopt=filler,internal,algorithm:histogram,indent-heuristic

let mapleader=" "

" Jump to the last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ -uu

" Required for operations modifying multiple buffers like rename.
set hidden

" Netrw
" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize=30
" Change directory to the current buffer when opening files.
" set autochdir

let g:airline_powerline_fonts = 1
let g:rainbow_active = 0
let g:deoplete#enable_at_startup = 1

if has('mac')
    let g:LanguageClient_serverCommands = {
        \ 'rust': ['~/.cargo/bin/rustup', 'run', 'nightly', 'rls'],
        \ 'python': ['~/Library/Python/3.7/bin/pyls'],
        \ 'php': ['php', '~/.config/composer/vendor/felixfbecker/language-server/bin/php-language-server.php'],
        \ }
else
    let g:LanguageClient_serverCommands = {
        \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
        \ 'python': ['~/.local/bin/pyls'],
        \ 'php': ['php', '~/.config/composer/vendor/felixfbecker/language-server/bin/php-language-server.php'],
        \ }
endif

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

"autocmd BufWritePre *.py :call LanguageClient#textDocument_formatting_sync()

" let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_loggingFile = '/tmp/vim-lsp.log'

let g:fzf_history_dir = '~/.local/share/fzf-history'

" for .hql files
au BufNewFile,BufRead *.hql set filetype=hive expandtab
" for .q files
au BufNewFile,BufRead *.q set filetype=hive expandtab

" Initially added for vim-go plugin
filetype plugin indent on

autocmd FileType text,markdown,mail setlocal spell
let g:guesslang_langs = [ 'en_US', 'ru_RU']

" Enable automatic layout switcher
let g:XkbSwitchEnabled = 1

" Ale
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_fix_on_save = 1

let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\   'scss': ['prettier'],
\}

let g:ale_linters = {'python': ['flake8']}

" Disabling hiding stuff in Markdown files
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

let g:vim_markdown_frontmatter = 1

nmap <leader>f :Files<cr>|     " fuzzy find files in the working directory (where you launched Vim from)
nmap <leader>/ :BLines<cr>|    " fuzzy find lines in the current file
nmap <leader>b :Buffers<cr>|   " fuzzy find an open buffer
nmap <leader>r :Rg |           " fuzzy find text in the working directory
nmap <leader>c :Commands<cr>|  " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
nmap <leader>h :History:<cr>|  " fuzzy find Vim commands history

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg -uu --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
