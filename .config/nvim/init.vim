" Neovim Config
""""""""""""""""

command! VIM echo 'nvim'
let mapleader = ' '

" Download vim-plug if it is missing
    if ! filereadable(expand('~/.local/share/nvim/site/autoload/plug.vim'))
        echon "\n  :: Downloading junegunn/vim-plug to manage plugins...   "
        let output = system("curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'")
        if v:shell_error != 0
            echon "[ ERROR ]\n"
            echo output
        else
            echon "[ DONE ]\n"

            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
    endif


" Configure Plugins
    call plug#begin('~/.local/share/nvim/plugged')
        Plug 'tomasiser/vim-code-dark'
        Plug 'tpope/vim-sensible'
        Plug 'tpope/vim-surround'
        Plug 'arcticicestudio/nord-vim'
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'tpope/vim-eunuch'
        "Plug 'xolox/vim-misc'
        "Plug 'xolox/vim-session'
        "Plug 'thaerkh/vim-workspace'
        "Plug 'semanser/vim-outdated-plugins'
        Plug 'tpope/vim-fugitive'
        Plug 'luochen1990/rainbow'
        Plug 'guns/xterm-color-table.vim'
        Plug 'editorconfig/editorconfig-vim'
        Plug 'tpope/vim-fugitive'
        "Plug 'terryma/vim-multiple-cursors'
        Plug 'lambdalisue/suda.vim'
        Plug 'rust-lang/rust.vim'
        Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
        Plug 'fidian/hexmode'

        " START vim-zettel
        Plug 'vimwiki/vimwiki'
        Plug 'junegunn/fzf'
        Plug 'junegunn/fzf.vim'
        Plug 'michal-h21/vim-zettel'
        " END vim-zettel

        Plug 'vim-scripts/cmdalias.vim'
        Plug 'LnL7/vim-nix'
        " Might require nodejs >= 10.12
        Plug 'neoclide/coc.nvim', {'branch': 'release'}
        Plug 'isobit/vim-caddyfile'

        Plug 'preservim/nerdcommenter' " same as 'scrooloose/nerdcommenter'
        Plug 'preservim/nerdtree' " same ase 'scrooloose/nerdtree'
        Plug 'moll/vim-bbye'
        Plug 'mbbill/undotree'
    call plug#end()


    "autocmd VimEnter * PlugUpgrade | PlugUpdate
    "
    " Auto install plugins on vim startup
    "autocmd VimEnter *
    "  \  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
    "  \|   PlugInstall
    "  \| endif


" Set color scheme
    "colorscheme nord
    "colorscheme challenger_deep
    colorscheme codedark


" Configure airline
    if $USER != 'root'
        let g:airline#extensions#tabline#formatter = 'markdown_title'
    endif
    "let g:airline_theme='bubblegum'
    let g:airline_theme='codedark'
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_min_count = 0
    "let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    " Always show buffers and just show tab number
    let g:airline#extensions#tabline#show_tabs = 0
    "let g:airline_solarized_bg='dark'
    set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

    " Indicate root user in airline
    if $USER == 'root'
        function! AirlineRoot(...)
            call a:1.add_section('Error', 'ROOT')
        endfunction
        call airline#add_statusline_func('AirlineRoot')
    endif


    " Display window number in airline
    function! WindowNumber(...)
        let builder = a:1
        let context = a:2
        call builder.add_section('airline_b', '%{tabpagewinnr(tabpagenr())}')
        return 0
    endfunction

    if (!get(g:, 'x3ro#airlineWindowNumber', 0))
        let x3ro#airlineWindowNumber = 1
        call airline#add_statusline_func('WindowNumber')
        call airline#add_inactive_statusline_func('WindowNumber')
    endif

" Enable mouse
    set mouse=a


" Editorconfig
    " Disable for fugitive
    let g:EditorConfig_exclude_patterns = ['fugitive://.\*']


" Auto-Save/Load default session
    "let g:session_autosave = 'yes'
    "let g:session_autoload = 'yes'
    let g:session_command_aliases = 1


" Easy switch between buffers
	set hidden
	nnoremap <leader>p :bprev<CR>
    nnoremap <M-<> :bprev<CR>
	nnoremap <leader>n :bnext<CR>
	nnoremap <M->> :bnext<CR>
    nnoremap <leader><Tab> :b#<Enter>


" Fix slow vim
    set timeoutlen=1000
    set ttimeoutlen=0


" Enable syntax highlighting
    filetype plugin on
    syntax on


" Enable hybrid relative numbers
    set number relativenumber
    highlight LineNr ctermfg=grey ctermbg=black guifg=#aaaaaa guibg=#292929


" Indent with 4 spaces
    filetype indent on
    set tabstop=4    " show existing tabs with 4 spaces width
    set shiftwidth=4 " when indenting with '>', use 4 spacees width
    set expandtab    " on pressing tab, inssert 4 spaces
    set autoindent
    autocmd FileType yaml set indentkeys-=0#


" Jump to last position
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif


" Command to (write and) reload .vimrc
    let x3ro#vimrc = '~/.config/nvim/init.vim'
    command! RR
        \  if (bufname('%') != '' && expand('%:p') == expand(x3ro#vimrc))
        \|     write
        \| endif
        \| exec "source " x3ro#vimrc
        \| redraw
        \| echo "===> :source " . x3ro#vimrc . " <==="
        \| if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
        \|     PlugInstall
        \| endif


" Change directory to current file
    command! CD
        \ chdir %:h |
        \ redraw | echo "===> :chdir"expand("%:p:h")"<==="

" Open new split panes to right and bottom, which feels more natural than Vim’s default
    set splitbelow
    set splitright


" Columns for 80 and 120 characters (120 is a thick line)
    " Line numbers
    highlight CursorLineNr cterm=bold ctermfg=yellow
    highlight LineNr ctermfg=darkgray

    " Rulers (80 / 120 chars)
    let &colorcolumn="81,".join(range(121,999),",")
    "highlight ColorColumn ctermbg=237 guibg=#292929
    highlight ColorColumn ctermbg=233 guibg=#292929

    " Theme : nord
    "highlight Visual cterm=bold ctermbg=238 ctermfg=NONE
    "highlight ErrorMsg ctermfg=0


" GUI Options
    set guioptions-=m  " Remove menu bar
    set guioptions-=T  " Remove toolbar
    set guioptions-=r  " Remove right-hand scroll bar
    set guioptions-=L  " Remove left-hand scroll bar
    "set showtabline=2  " Always show tab bar
    if &guifont == "" |
      \ set guifont=Monospace\ 10 |
    \ endif


" Smart case (in)sensitive search
    :set ignorecase
    :set smartcase


" Scrolloff
    set scrolloff=5

    " When jumping to end of file, leave 5 lines blank below
    nnoremap G 5<C-y>G5<C-e>


" Commands
    command! Config e ~/.config/nvim/init.vim
    command! SudoEdit echo "DO NOT USE!!! Seems to write empty file with neovim!"
    command! SudoWrite echo "DO NOT USE!!! Seems to write empty file with neovim!"

    " Write / Save when being too fast and typing uppercase characters
    command! W w
    command! Q q
 
    " Prevent opening the command history on "q:"
    nnoremap q: :

    " Alias for toggling lines
    command! LinesToggle set number! relativenumber!
    command! LL LinesToggle

    " FZF Aliases
    "let g:fzf_command_prefix = 'Fzf'
    command! F Files
    command! L Lines
    command! H History

    " Auto save files on focus lost / buffer switch
    command! AutoSaveOn
        \  let x3ro#autoSave = 1
        \| set autowriteall
        \| autocmd! FocusLost *
            \  if (bufname('%') != '')
            \|     :write
            \| endif

    command! AutoSaveOff
        \  let x3ro#autoSave = 0
        \| set noautowriteall
        \| autocmd! FocusLost *

    command! AutoSave
        \  if get(g:, 'x3ro#autoSave', 0)
        \|     echo "AutoSave: On"
        \| else
        \|     echo "AutoSave: Off"
        \| endif

    command! MenuShow
      \ set guioptions+=mT

    command! MenuHide
      \ set guioptions-=mT


" System Clipboard
    " Copy to clipboard
    vnoremap  <leader><leader>y  "+y
    nnoremap  <leader><leader>Y  "+yg_
    nnoremap  <leader><leader>y  "+y
    "nnoremap  <leader>yy  "+yy

    " Cut to clipboard
    vnoremap  <leader><leader>d  "+d
    nnoremap  <leader><leader>D  "+dg_
    nnoremap  <leader><leader>d  "+d
    "nnoremap  <leader>dd  "+dd

    " Paste from clipboard
    nnoremap <leader><leader>p "+p
    nnoremap <leader><leader>P "+P
    vnoremap <leader><leader>p "+p
    "vnoremap <leader>P "+P


" Alt bindings for select all, copy and paste
    "nnoremap <A-a> ggVG
    "vnoremap <A-c> "+y
    "nnoremap <A-v> "+p


" Emacs navigation in command mode
    cnoremap <C-b> <Left>
    cnoremap <C-f> <Right>
    cnoremap <M-b> <S-Left>
    cnoremap <M-f> <S-Right>
    " Search through history using the already typed command
    cnoremap <C-p> <Up>
    cnoremap <C-n> <Down>

    " Remap the key to edit the last commands
    set cedit=<C-q>


" Save file
    nnoremap <leader>fs :w<Enter>


" Clear search highlights when pressing ESC in normal mode
    nnoremap <esc><esc> :noh<cr>:<C-h>


" Undotree
    if has("persistent_undo")
       let target_path = expand('~/.undodir')

        " create the directory and any parent directories
        " if the location does not exist.
        if !isdirectory(target_path)
            call mkdir(target_path, "p", 0700)
        endif

        let &undodir=target_path
        set undofile
    endif

    let g:undotree_WindowLayout = 3
    let g:undotree_SplitWidth = 50
    let g:undotree_SetFocusWhenToggle = 1
    "let g:undotree_TreeNodeShape = '○'
    "let g:undotree_DiffCommand = "git diff --no-index"

    nnoremap <F8> :UndotreeToggle<CR>


" Bbye - Close buffer without closing associated windows
    " Alias `:bd` to `:Bdelete`
    autocmd VimEnter * call CmdAlias('bd', 'Bdelete')


" SPACE:
    " Switch to window by number
    nnoremap <leader>1 <C-w>1w
    nnoremap <leader>2 <C-w>2w
    nnoremap <leader>3 <C-w>3w
    nnoremap <leader>4 <C-w>4w
    nnoremap <leader>5 <C-w>5w
    nnoremap <leader>6 <C-w>6w
    nnoremap <leader>7 <C-w>7w
    nnoremap <leader>8 <C-w>8w
    nnoremap <leader>9 <C-w>9w
    nnoremap <leader>0 <C-w>0w

    " Manage buffers
    nnoremap <leader>bd :Bdelete<CR>
    nnoremap <leader>bx :Bdelete<CR>
    nnoremap <leader>bX :Bdelete!<CR>
    nnoremap <leader>b<leader>x :Bwipeout<CR>
    nnoremap <leader>b<leader>X :Bwipeout!<CR>
    nnoremap <leader>bn :bnext<CR>
    nnoremap <leader>bp :bprev<CR>

    " Manage windows
    nnoremap <leader>wn <C-w>w
    nnoremap <leader>wp <C-w><S-w>
    nnoremap <leader>wc <C-w>c
    nnoremap <leader>wd <C-w>c
    nnoremap <leader>wx <C-w>c
    nnoremap <leader>wX <C-w>c
    nnoremap <leader>wsv :split<CR>
    nnoremap <leader>wsh :vsplit<CR>
    nnoremap <leader>wh <C-w>h
    nnoremap <leader>wj <C-w>j
    nnoremap <leader>wk <C-w>k
    nnoremap <leader>wl <C-w>l


"map <F14>a <C-M-a>
"nnoremap <C-M-a> :echo "x"
 

" NERDTree
    function! StartNERDTree()
        if argc() > 0
            if isdirectory(argv()[0])
                " When started with a directory, bring NERDTree to the side
                if !exists('s:std_in')
                    " When started without STDIN piped, close fullscreen NERDTree
                    bwipeout 
                endif
                execute 'NERDTree' argv()[0] | execute 'cd '.argv()[0]
                if argc() > 1 || exists('s:std_in')
                    " When started with more paths or with STDIN piped, focus main window
                    wincmd p
                endif
            else
                " When started with a file, start NERDTree and focus main window
                NERDTree
                wincmd p
            endif
        else
            " When started without arguments, just start NERDTree
            NERDTree
            if argc() > 1 || exists('s:std_in')
                " When started with STDIN piped, focus main window
                wincmd p
            endif
        endif
    endfunction

    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * call StartNERDTree()

    " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
    autocmd BufWinEnter * if winnr() == 1 && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
        \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

    " Exit Vim if NERDTree is the only window left.
    autocmd BufEnter * 
        \  if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()
        \|     quitall
        \| endif

    let g:NERDTreeDirArrowExpandable = '▶'
    let g:NERDTreeDirArrowCollapsible = '▼'
    nnoremap <M-n> :NERDTreeFocus<cr>
    nnoremap <M-N> :NERDTree<cr>


" NERDCommenter
    " Enable NERDCommenterToggle to check all selected lines is commented or not 
    let g:NERDToggleCheckAllLines = 1
    " Align line-wise comment delimiters flush left instead of following code indentation
    let g:NERDDefaultAlign = 'left'

    map ^_ <leader>ci
    vmap ^_ <leader>c<space>gv


" Improved line shifting
    vnoremap < <gv
    vnoremap > >gv


" Configure suda.vim
    let g:suda_smart_edit = 1

    function! GetSudaName(name)
        if (a:name =~ "^suda://")
            return a:name
        endif
        return "suda://" . a:name
    endfunction

    command! SudaWrite exec ":saveas " . GetSudaName(expand('%'))
    command! SudaEdit exec ":file " . GetSudaName(expand('%'))


" My SudoEdit
    "function! X_SudoWrite()
    "    let l:tmp = 'vim-sudo-write.XXXXXXXXXX.' . expand('%:gs?/?_?')
    "    let l:tmp = system("mktemp --dry-run --tmpdir '" . l:tmp . "'")
    "    let l:tmp = substitute(l:tmp, '\n.*', '', '')

    "    "if ! filereadable(l:tmp)
    "    "    echoerr "ERROR: Something went wrong while creating the temp file!"
    "    "    return 0
    "    "endif

    "    exec ":write " . l:tmp

    "    call system("sudo tee /tmp/blablubb <'" . l:tmp . "'")
    "    call delete(g:xxxx)
    "    return 0
    "endfunction
    ""command! SudoWrite call X_SudoWrite()
    "
    "command! SudoWrite
    "    \  call system("sudo true")
    "    \| if v:shell_error
    "    \|     try
    "    \|         call inputsave()
    "    \|         redraw | let password = inputsecret('SUDO Password: ')
    "    \|     finally
    "    \|         call inputrestore()
    "    \|     endtry
    "    \|     call system("sudo -p '' -S true", password)
    "    \| endif
    "    \| call system("sudo true")
    "    \| echo v:shell_error


" AurDiff
    " This requires the plugin 'tpope/vim-fugitive'
    command! AurDiff
        \  chdir %:h |
        \| let ref = system("git reflog |  awk '/(merge|reset:) / { current=$1; if (prev == \"\") { prev=current; } if (prev != current) { print current; exit } ; prev=current }'")
        \| let ref = substitute(ref, '\n.*', '', '')
        \| echo system("git reflog | awk -v ref=\"" . ref . "\" '{ if ($1 == ref) { print \"==> \" $0 } else { print \"    \" $0 } }'")
        \| call input("\nPress any key to continue")
        \| exec ":Gdiffsplit " ref


" Save file with Ctrl-S
    noremap  <silent> <C-S>   :update<CR>
    vnoremap <silent> <C-S>   <C-C>:update<CR>
    inoremap <silent> <C-S>   <C-O>:update<CR>


map <Up> 
map <Down> 

"if ! get(g:, 'x3ro#autoSaveSet', 0)
"    let x3ro#autoSaveSet = 1
"    AutoSaveOn
"endif

" ========================

" Show extra whitespaces
"set listchars=tab:\|·,trail:~,extends:>,precedes:< ",space:·
"set listchars=tab:\|·,trail:~,extends:>,precedes:<,space:·
"set list!
"highlight SpecialKey ctermfg=darkgray guibg=red
  
"highlight MyGroup ctermbg=darkgray
"match MyGroup /\%(\_^\s*\)\@<=\%(\%1v\|\%5v\|\%9v\)\s/

command! ZetID exec "normal O@ID:\<c-r>=strftime('%Y%m%d%H%M%S')<esc>j"
inoreabbrev @ID: @ID:<c-r>=strftime('%Y%m%d%H%M%S')<CR>

set noeol
set nofixeol

" vim-zettel config
    " Settings for Vimwiki
    let g:vimwiki_list = [{'path':'~/Zettelkasten/','ext':'.md','syntax':'markdown'}]
    let g:zettel_fzf_command = "rg"

    " Custom commands / aliases
    cnoreabbr Znew ZettelNew
    command! Zcheck VimwikiCheckLinks
    command! Zrename VimwikiRenameFile
    command! Zopen ZettelOpen
    command! Zbacklinks VimwikiBacklinks
    command! Zindex VimwikiIndex


" Git Emoji Log (https://github.com/ahmadawais/Emoji-Log)
    command! GCnew !git commit -m "HORAAY" -e --allow-empty

" Coc Config
    "" Use tab for trigger completion with characters ahead and navigate.
    "" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    "" other plugin before putting this into your config.
    "inoremap <silent><expr> <TAB>
    "      \ pumvisible() ? "\<C-n>" :
    "      \ <SID>check_back_space() ? "\<TAB>" :
    "      \ coc#refresh()
    "inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    "function! s:check_back_space() abort
    "    let col = col('.') - 1
    "    return !col || getline('.')[col - 1]  =~# '\s'
    "endfunction

    "" Use <c-space> to trigger completion.
    "inoremap <silent><expr> <c-space> coc#refresh()

    "" Use K to show documentation in preview window.
    "nnoremap <silent> K :call <SID>show_documentation()<CR>

    "" Highlight the symbol and its references when holding the cursor.
    "autocmd CursorHold * silent call CocActionAsync('highlight')
