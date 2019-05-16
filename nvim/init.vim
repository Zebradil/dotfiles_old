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

  " Git-wrapper
  Plug 'tpope/vim-fugitive'

  " Git-commit browser
  Plug 'junegunn/gv.vim'

  Plug 'junegunn/vim-github-dashboard'

  " Colorschemes
  Plug 'chriskempson/base16-vim'

  " Distruction-free writing
  Plug 'junegunn/goyo.vim'

  " Highlight current text block
  Plug 'junegunn/limelight.vim'

  " Colorize matching parenthesis
  Plug 'luochen1990/rainbow'

  " Extended suport for matching parenthesis and words
  Plug 'andymass/vim-matchup'

  Plug 'vim-airline/vim-airline'

  Plug 'junegunn/vim-easy-align'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  "Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  "Plug 'rust-lang/rust.vim'
  "Plug 'lumiliet/vim-twig'
  "Plug 'cespare/vim-toml'
  Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
  Plug 'Konfekt/vim-DetectSpellLang'

  " Automatic layout switcher
  Plug 'lyokha/vim-xkbswitch'

  " Language pack
  Plug 'sheerun/vim-polyglot'

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

set cursorline
set number
set relativenumber
set noshowmode
set termguicolors

colorscheme base16-default-dark

set exrc
set secure

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set autoindent
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set laststatus=2
set textwidth=120
set updatetime=100

" Jump to the last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

" Required for operations modifying multiple buffers like rename.
set hidden

" Netrw
" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1
" Change directory to the current buffer when opening files.
set autochdir

let g:airline_powerline_fonts = 1
let g:rainbow_active = 0
let g:deoplete#enable_at_startup = 1

if has('mac')
    let g:LanguageClient_serverCommands = {
        \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
        \ 'python': ['~/Library/Python/3.7/bin/pyls'],
        \ 'php': ['php', '~/.config/composer/vendor/felixfbecker/language-server/bin/php-language-server.php'],
        \ }
else
    let g:LanguageClient_serverCommands = {
        \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
        \ 'python': ['~/.local/bin/pyls'],
        \ 'php': ['php', '~/.config/composer/vendor/felixfbecker/language-server/bin/php-language-server.php'],
        \ }
endif

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
"nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

"autocmd BufWritePre *.py :call LanguageClient#textDocument_formatting_sync()

" let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_loggingFile = '/tmp/lsp.log'

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

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
let g:ale_python_flake8_options = '--max-line-length=120'
let g:ale_python_black_options = '-l120'

" Disabling hiding stuff in Markdown files
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0
