" Maintainer:   Yri Davies  <0xdavy@gmail.com>
" Last change:  2017 Jun 26

" Variables and arrays {{{
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'N·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ ''  : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ ''  : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \}

" }}}
" Misc {{{
set backspace=indent,eol,start  " allows backspace to remove indentation and stuff
set modelines=1                 " checks the last line of a file for mode changes
execute pathogen#infect()
" }}}
" Color scheme {{{
syntax enable           " enable syntax processing
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
endif
highlight VertSplit ctermfg=bg ctermbg=18
" }}}
" Indentation {{{
" General indentation rules
set tabstop=4       " tabs are 4 spaces long when reading a file
set softtabstop=4   " tabs are 4 spaces long when editing (for backspace)
set shiftwidth=4    " expanded tabs are 4 spaces long
set expandtab       " tabs are inserted as spaces for things like bash
set smarttab        " tab key brings you to the next tabstop multiple rather than hard-inserting four spaces
set copyindent      " copy indentation from previous line
" Filetype-specific indentation rules
autocmd FileType html setlocal shiftwidth=2 tabstop=2
" }}}
" UI config {{{
set number          " line numbers
set relativenumber  " Show relative numbers for lines
set showmode        " Show the current mode
set showcmd         " shows the typed command bottom right
set cursorline      " highlight current line
set cursorcolumn    " highlight current column
filetype indent on  " opens indentation file based on detected filetype (.c, .py, etc)
set wildmenu        " visual autocomplete for commands
set wildmode=list:longest,list:full " more efficient autocomplete!
set lazyredraw      " only redraw when necessary
set showmatch       " highlight matching for brackets [{()}]
set mouse=a         " Allow mouse interaction in all modes
set showbreak=↪\ 
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set fillchars=vert:\ 
augroup CursorIndicatorsInActiveWindowOnly
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
    autocmd WinLeave * setlocal nocursorline
    autocmd WinLeave * setlocal nocursorcolumn
augroup END
" }}}
" Status line {{{
" Base statusline
hi User1 ctermfg=8 ctermbg=18
" Column number
hi User2 ctermfg=2 ctermbg=0
" File name
hi User3 ctermfg=0 ctermbg=3
" Warnings
hi User4 ctermfg=1 ctermbg=18
" Git
hi User5 ctermfg=4 ctermbg=18
" Mode
hi User6 ctermfg=0 ctermbg=17

set statusline =

set statusline+=%2*
set statusline+=%3c\     "Column number
set statusline+=%1*

set statusline+=%1*\ 
set statusline+=%3*
set statusline+=\ %<    " Truncate here
set statusline+=%f\     "tail of the filename
set statusline+=%h      "help file flag
set statusline+=%y\     "filetype
set statusline+=%1*

" Status line for vim-fugitive
set statusline+=%5*
set statusline+=\ %{fugitive#statusline()}\ 
set statusline+=%1*

"display a warning if fileformat isnt unix
set statusline+=%4*
set statusline+=%{&ff!='unix'?'\ ['.&ff.']\ ':''}
set statusline+=%1*

"display a warning if file encoding isnt utf-8
set statusline+=%4*
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'\ ['.&fenc.']\ ':''}
set statusline+=%1*

"read only flag
set statusline+=%4*
set statusline+=%r
set statusline+=%1*

"modified flag
set statusline+=%4*
set statusline+=%m
set statusline+=%1*

" Screen side marker, everything below this is on the right
set statusline+=%=

" Vim mode, verbose
set statusline+=%6*
set statusline+=\ %{g:currentmode[mode()]}\ 
set statusline+=%1*\ 

set laststatus=2        " always show the status line

" }}}
" Search settings {{{
set incsearch       " search as you type
set hlsearch        " highlight matches
set ignorecase      " ignore case in searches
set smartcase       " respect case if you type it
" }}}
" Folding {{{
set foldenable          " enable this
set foldlevelstart=10   " open 10 levels of folds
set foldnestmax=10      " allow at most 10 nested folds
set foldmethod=indent   " fold based on indentation by default
" }}}
" Movement {{{
set scrolljump=5    " jump 5 lines when the cursor leaves the screen
set scrolloff=15    " keep 15 lines visible above and below the cursor at all times
" }}}
" TMUX workarounds {{{
if &term =~ "xterm\\|rxvt\\|screen"
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
endif
if exists('$TMUX')  " change cursor mode to vertical bar in TMUX
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}} 
" Nerdtree {{{
" autocmd vimenter * NERDTree     " start NERDTree when vim starts
" autocmd vimenter * :wincmd l    " start in the file window rather than in NERDTree
" close NERDTree if it's the only screen left in vim
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
" Ripgrep {{{
if executable("rg")
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" }}}
" Fzf {{{
if executable("fzf")
    " Add fzf to runtimepath
    set rtp+=~/.dotfiles-tools/fzf
    " And also for fecken mac
    set rtp+=/usr/local/opt/fzf
    " [Layout] Fzf uses the left 30% of the screen in vim
    let g:fzf_layout = {'left': '30%'}
    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1
endif
" }}}
" Commands {{{
" Ripgrep everything
command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)
" Ripgrep only php files
command! -bang -nargs=* Rgphp
            \ call fzf#vim#grep(
            \   'rg -tphp --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)
" Ripgrep only css/html files
command! -bang -nargs=* Rghtmlcss
            \ call fzf#vim#grep(
            \   'rg -thtml -tcss --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)
" Ripgrep only css/html files
command! -bang -nargs=* Rgxml
            \ call fzf#vim#grep(
            \   'rg -txml --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)
command! -bang -nargs=* Rgu
            \ call fzf#vim#grep(
            \   'rg -u --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)
" Ripgrep only php files
command! -bang -nargs=* Rgphpu
            \ call fzf#vim#grep(
            \   'rg -u -tphp --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)
" Ripgrep only css/html files
command! -bang -nargs=* Rghtmlcssu
            \ call fzf#vim#grep(
            \   'rg -u -thtml -tcss --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)
" Ripgrep only css/html files
command! -bang -nargs=* Rgxmlu
            \ call fzf#vim#grep(
            \   'rg -u -txml --column --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)

nnoremap <C-p>a :Rg
" }}}
" Mappings {{{
"   Disable normal space functionality
nnoremap <SPACE> <Nop>
"   Use it as a leader for keybinds
let mapleader=" "
"   Clear search
nnoremap <silent> <leader>/ :nohlsearch<CR>
nnoremap <leader><space> za
" }}}
" Back up stuff {{{
if has("vms")
    set nobackup      " do not keep a backup file, use versions instead
else
    set backup        " keep a backup file (restore to previous version)
    set backupdir=/tmp,.
    set directory=/tmp,.
    if has('persistent_undo')
        set undofile    " keep an undo file (undo changes after closing)
        set undodir=/tmp,.
    endif
endif
" }}}
" Functions {{{
"
"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    else
        call cursor(1,1)
    endif
endfunction

" Toggle a markdown notes file in a fixed window on the right with f12
nnoremap <F12> :NotesToggle<cr>
command! -nargs=0 NotesToggle call <sid>toggleNotes()
function! s:toggleNotes() abort
    let winnr = bufwinnr("notes.md")
    if winnr > 0
        exec winnr . "wincmd c"
        return
    endif
    botright 100vs notes.md
    setl wfw
    setl nonu
    " hack to make nerdtree et al not split the window
    setl previewwindow
    " for some reason this doesnt get run automatically and the cursor 
    " position doesn't get set
    doautocmd bufreadpost %
    " normal zMzO
endfunction

" }}}
" OS-specific stuff {{{
if has ('unix')
    if has ('osx')  " OSX
        source ~/.vim/mac-specific.vim
    else            " Linux etc
        source ~/.vim/linux-specific.vim
    endif
endif
" }}}

" vim:foldmethod=marker:foldlevel=0
