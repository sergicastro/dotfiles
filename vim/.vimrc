" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the
" following enables syntax highlighting by default.
if has("syntax")
    syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
    filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden             " Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)
set showtabline=1       " Show tabs

" At lease show in which mode we are working
set showmode
set cursorline

" Set tab/spaces config
set expandtab shiftwidth=4 softtabstop=4 smarttab smartindent

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif

" Autoload changes in .vimrc
autocmd BufWritePost .vimrc source $MYVIMRC

" Color theme
" [adaryn.vim, adrian.vim, aiseered.vim, anotherdark.vim, aqua.vim, asmanian2.vim, asmdev2.vim, asmdev.vim, astronaut.vim, asu1dark.vim,
" autumn2.vim, autumnleaf.vim, autumn.vim, baycomb.vim, bclear.vim, biogoo.vim, blacksea.vim, bluegreen.vim, borland.vim, breeze.vim,
" brookstream.vim, buttercream.vim, calmar256-dark.vim, calmar256-light.vim, camo.vim, candycode.vim, candy.vim, chela_light.vim, chocolateliquor.vim,
" clarity.vim, cleanphp.vim, colorer.vim, dante.vim, darkblue2.vim, darkbone.vim, darkslategray.vim, darkspectrum.vim, darkZ.vim, dawn.vim,
" denim.vim, desert256.vim, desertEx.vim, dusk.vim, dw_blue.vim, dw_cyan.vim, dw_green.vim, dw_orange.vim, dw_purple.vim, dw_red.vim, dw_yellow.vim,
" earendel.vim, eclipse.vim, ekvoli.vim, fine_blue2.vim, fine_blue.vim, fnaqevan.vim, fog.vim, freya.vim, fruit.vim, fruity.vim, golden.vim,
" guardian.vim, habilight.vim, herald.vim, impact.vim, inkpot.vim, ir_black.vim, ironman.vim, jammy.vim, jellybeans.vim, kellys.vim, leo.vim,
" lettuce.vim, lucius.vim, manxome.vim, marklar.vim, maroloccio.vim, martin_krischik.vim, matrix.vim, molokai.vim, moria.vim, moss.vim,
" motus.vim, mustang.vim, navajo-night.vim, navajo.vim, neon.vim, neverness.vim, nightshimmer.vim, night.vim, no_quarter.vim, northland.vim,
" nuvola.vim, oceanblack.vim, oceandeep.vim, oceanlight.vim, olive.vim, papayawhip.vim, peaksea.vim, print_bw.vim, pyte.vim, railscasts2.vim,
" railscasts.vim, rdark.vim, relaxedgreen.vim, robinhood.vim, rootwater.vim, satori.vim, sea.vim, settlemyer.vim, sienna.vim, silent.vim,
" simpleandfriendly.vim, softblue.vim, soso.vim, spring.vim, summerfruit256.vim, synic.vim, tabula.vim, tango2.vim, tango.vim, taqua.vim,
" tcsoft.vim, tir_black.vim, tolerable.vim, torte.vim, twilight.vim, two2tango.vim, vc.vim, vibrantink.vim, vividchalk.vim, vylight.vim,
" winter.vim, wombat256mod.vim, wombat256.vim, wombat.vim, wood.vim, wuye.vim, xemacs.vim, xoria256.vim, zenburn.vim, zmrok.vim]

" colorscheme Tomorrow-Night 

sy on
set t_Co=256
if has('gui_running')
    colorscheme wombat
else
    colorscheme wombat256mod
endif

" Show number lines the title of the window and the ruler
set number 
set title 
set ruler

" ----------------------- "
"   NO PLUGIN REMAPINGS   "
" ----------------------- "

" :w!! sudo saves the file
cmap w!! w !sudo tee % >/dev/null

" GRB: use fancy buffer closing that doesn't close the split
" cnoremap <expr> bd (getcmdtype() == ':' ? 'Bclose' : 'bd')
nnoremap <silent> <C-d> :lclose<CR>:bdelete<CR>
cabbrev <silent> bd lclose\|bdelete
:nnoremap <silent> <S-Left> :bprevious<CR>
:nnoremap <silent> <S-Right> :bnext<CR>
:noremap <silent> <C-Left> b
:noremap <silent> <C-Right> w

" Move around the splits
noremap <silent> -<down> :wincmd j<CR>
noremap <silent> -<left> :wincmd h<CR>
noremap <silent> -<up> :wincmd k<CR>
noremap <silent> -<right> :wincmd l<CR>

" ---------------- "
"     PLUGINS      "
" ---------------- "

" Pathogen
execute pathogen#infect()


" Rainbow parantheses
au VimEnter * RainbowParenthesesToggle     " Toggle it on/off
au Syntax * RainbowParenthesesLoadRound    " (), the default when toggling
au Syntax * RainbowParenthesesLoadSquare   " []
au Syntax * RainbowParenthesesLoadBraces   " {}
" au Syntax * RainbowParenthesesLoadChevrons " <>

set viminfo+=!
let g:rbpt_colorpairs = [
            \ ['brown',       'RoyalBlue3'],
            \ ['Darkblue',    'SeaGreen3'],
            \ ['darkgray',    'DarkOrchid3'],
            \ ['darkgreen',   'firebrick3'],
            \ ['darkcyan',    'RoyalBlue3'],
            \ ['darkred',     'SeaGreen3'],
            \ ['darkmagenta', 'DarkOrchid3'],
            \ ['brown',       'firebrick3'],
            \ ['gray',        'RoyalBlue3'],
            \ ['black',       'SeaGreen3'],
            \ ['Darkblue',    'firebrick3'],
            \ ['red',         'firebrick3'],
            \ ['darkmagenta', 'DarkOrchid3'],
            \ ['darkgreen',   'RoyalBlue3'],
            \ ['darkcyan',    'SeaGreen3'],
            \ ['darkred',     'DarkOrchid3'],
            \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0


" NERDTree 
noremap <silent><F2> :NERDTreeToggle<CR>
let NERDTreeAutoCenter = 1
let NERDTreeCaseSensitiveSort = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeMouseMode = 2
let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1
let NERDTreeIgnore=['.*\.o$']
let NERDTreeIgnore+=['.*\~$']
let NERDTreeIgnore+=['.*\.out$']
let NERDTreeIgnore+=['.*\.so$', '.*\.a$']
let NERDTreeIgnore+=['.*\.pyc$']
let NERDTreeIgnore+=['.*\.class$']
autocmd vimenter * if !argc() | NERDTree | endif


" NERDTree tabs
let g:nerdtree_tabs_open_on_console_startup=1
let g:nerdtree_tabs_smart_startup_focus=2


" buff explorer
nmap <F4> :BufExplorerHorizontalSplit<CR>
let g:bufExplorerSplitBelow=1


" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = 'ꔖ'
let g:airline_exclude_preview = 1
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '▶'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '◀'
let g:airline_linecolumn_prefix = '␤ '
let g:airline_branch_prefix = '⎇ '
let g:airline_paste_symbol = 'ρ'


" majutsushi tagbar
nmap <F3> :TagbarToggle<CR>


" gundo tree
nnoremap <F6> :GundoToggle<CR>

" ---------------- "
"      PYTHON      "
" ---------------- "
" Jedi vim (autocomplete)
let g:jedi#use_splits_not_buffers = "left"

" Flake 8 code style
autocmd BufWritePost *.py call Flake8()

" Syntastic use python checker
let g:syntastic_python_checkers=['flake8']

" ------------------ "
"  Tmux INTEGRATION  "
" ------------------ "

" Open tmux split
nmap <silent> <F5> :!tmux splitw -v -l 10<CR><CR>

" tmux will send xterm-style keys when xterm-keys is on
if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif"

" Close tmux when exiting vim
autocmd VimLeave * silent !tmux killp -a
