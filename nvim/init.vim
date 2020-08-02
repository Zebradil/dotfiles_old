if !exists('g:vscode')
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

  " Abbreviate, substitute, change case
  Plug 'tpope/vim-abolish'

  " Interactive git diff
  Plug 'airblade/vim-gitgutter'

  " Better diff options
  Plug 'chrisbra/vim-diff-enhanced'

  " Git-wrapper
  Plug 'tpope/vim-fugitive'
  Plug 'rbong/vim-flog'

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

  " Extended suport for matching parenthesis and words
  Plug 'andymass/vim-matchup'

  " Highlight word under the cursor
  Plug 'RRethy/vim-illuminate'

  " Show current context
  Plug 'wellle/context.vim'

  Plug 'vim-airline/vim-airline'

  Plug 'junegunn/vim-easy-align'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  Plug 'Konfekt/vim-DetectSpellLang'

  " Automatic layout switcher
  Plug 'lyokha/vim-xkbswitch'

  " Language pack
  Plug 'sheerun/vim-polyglot'

  " Helm
  Plug 'towolf/vim-helm'

  " Jsonnet
  Plug 'google/vim-jsonnet'

  " Nginx
  Plug 'vim-scripts/nginx.vim'

  " Ansible
  Plug 'pearofducks/ansible-vim'

  " Python
  Plug 'vim-scripts/indentpython.vim'

  " todo.txt
  Plug 'freitass/todo.txt-vim'

  " Identation
  Plug 'Yggdroot/indentLine'

  " Editing helpers
  Plug 'machakann/vim-sandwich'

  " Syntax check
  Plug 'w0rp/ale'

  " Autoformat
  Plug 'Chiel92/vim-autoformat'

  " Plug 'ervandew/supertab'

  Plug 'editorconfig/editorconfig-vim'

  Plug 'robertbasic/vim-hugo-helper'

  Plug 'tpope/vim-surround'

  " Outline
  Plug 'liuchengxu/vista.vim'

  " Search for definitions
  Plug 'pechorin/any-jump.vim'

  " File icons in explorer windows
  Plug 'ryanoasis/vim-devicons'
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
set inccommand=nosplit

set linebreak

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


" =========================== COC config ↓
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>ff  <Plug>(coc-format)
nmap <leader>ff  <Plug>(coc-format)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" coc-explorer
nnoremap <space>e :CocCommand explorer<CR>

" =========================== COC config ↑

" Support JSONC
autocmd FileType json syntax match Comment +\/\/.\+$+


" Netrw
" Hit P in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 0
let g:netrw_preview = 1
let g:netrw_altv = 1
let g:netrw_winsize=30
" Change directory to the current buffer when opening files.
" set autochdir

let g:airline_powerline_fonts = 1
let g:context_enabled = 0

let g:fzf_history_dir = '~/.local/share/fzf-history'

" for .hql files
au BufNewFile,BufRead *.hql set filetype=hive expandtab
" for .q files
au BufNewFile,BufRead *.q set filetype=hive expandtab

" Initially added for vim-go plugin
filetype plugin indent on

autocmd FileType           text,markdown,mail setlocal spell
autocmd BufNewFile,BufRead COMMIT_EDITMSG     setlocal spell
let g:detectspelllang_langs = {}
let g:detectspelllang_langs.aspell = ['en_US', 'ru_RU']

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
\   'cpp': ['clangtidy'],
\   'python': ['isort', 'black'],
\   'scss': ['prettier'],
\   'rust': ['rustfmt'],
\   'go': ['gofmt'],
\}

let g:ale_linters = {
\   'python': [],
\   'go': ['golint'],
\}

let g:EditorConfig_exclude_patterns = ['fugitive://.\*']

" Disabling hiding stuff in Markdown files
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

let g:vim_markdown_frontmatter = 1

" FZF ---------------------------

nmap <leader>f :Files<cr>|     " fuzzy find files in the working directory (where you launched Vim from)
nmap <leader>/ :BLines<cr>|    " fuzzy find lines in the current file
nmap <leader>b :Buffers<cr>|   " fuzzy find an open buffer
nmap <leader>r :Rg |           " fuzzy find text in the working directory
nmap <leader>c :Commands<cr>|  " fuzzy find Vim commands (like Ctrl-Shift-P in Sublime/Atom/VSC)
nmap <leader>h :History:<cr>|  " fuzzy find Vim commands history

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg -uu --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg -uu --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" FZF ---------------------------


" Vista -------------------------
"
let g:vista_sidebar_width = 65
let g:vista_update_on_text_changed = 1
let g:vista_default_executive = 'coc'

" Disable running Vista on startup by airline
let g:airline#extensions#vista#enabled = 0

autocmd FileType vista,vista_kind nnoremap <buffer> <silent> /
  \ :<c-u>call vista#finder#fzf#Run()<CR>
"
" Vista -------------------------

" Functions ---------------------

" https://vim.fandom.com/wiki/Deleting_a_buffer_without_closing_the_window
"here is a more exotic version of my original Kwbd script
"delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(&modified)
      let answer = confirm("This buffer has been modified.  Are you sure you want to delete it?", "&Yes\n&No", 2)
      if(answer != 1)
        return
      endif
    endif
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-u>Kwbd<CR>

nmap <C-W>! <Plug>Kwbd
endif
