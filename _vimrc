"--------------------------------------------------
" Descriptor: vimrc for windows
" Author: Bill Liu
" Email: nonprivatemail@163.com
"
" Usage:
" 1.Add gvim install directory to  enviroment variable PATH
" 2.Put ctags and cscope exe file to gvim install directory(eg.vim80)
" 2.Vundle and plugin working directory:vimfiles\bundle
" 3.Install vundle
" 4.Open gvim and enter normal mode to install plugin using PluginInstall
"--------------------------------------------------
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

"--------------------------------------------------
" Vundle setting
"--------------------------------------------------
filetype off         " vundle require disable file type detection
set rtp+=E:/APP/Vim/vimfiles/bundle/vundle/   " set vundle install path
call vundle#begin('E:/APP/Vim/vimfiles/bundle/')  " set a path where vundle should install plugins
" Let vundle manage vundle
Plugin 'VundleVim/Vundle.vim'

" All of your plugins must be added before the following line
" Added nerdtree
Plugin 'scrooloose/nerdtree'

let NERDTreeIgnore=['*.pyc'] " ignore files in NERDTree
let NERDTreeWinPos='right'   " nerdtree locate at right side
let NERDTreeShowBookmarks = 1
" Open NERDTree with F2
map <F2> :NERDTreeToggle<cr>
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Open a NERDTree automatically when vim starts up
autocmd vimenter * NERDTree 
autocmd vimenter * wincmd p  " focus main windows on launch

" Added Ctrlp
Plugin 'kien/ctrlp.vim'

map <c-o> :CtrlP <cr>
" Exclude files and directories
set wildignore+=*\\.git\\*,*\\tmp\\*,*.swp,*.zip,*.exe,*.pyc,*.so
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" Added cscove(a smart cscope helper)
Plugin 'brookhong/cscope.vim'

nnoremap <C-\>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <C-\>l :call ToggleLocationList()<CR>
" s: Find this C symbol
nnoremap  <C-\>s :call CscopeFind('s', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <C-\>c :call CscopeFind('c', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <C-\>e :call CscopeFind('e', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <C-\>fi :call CscopeFind('i', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <C-\>d :call CscopeFind('d', expand('<cword>'))<CR>

" Added autotag
Plugin 'craigemery/vim-autotag'

let g:autotagTagsFile="tags"

call vundle#end()
filetype plugin indent on  " not to ignore plugin indent changes

" Brief help
" :PluginList        - lists configured plugins
" :PluginInstall     - installs plugins; append `!` to update or :PluginUpdate
" :PluginSearch foo  - searches for foo; append `!` to refresh local cache
" :PluginClean       - confirms removal of unused plugins; append `!` to auto

"--------------------------------------------------
" General setting
"--------------------------------------------------
set nocompatible     " Use Vim defaults (much better!)
set history=50       " keep 50 lines of command line history
set nu!              " dispaly the line numbers
set nowrap           " no auto new line 
set ruler            " show the cursor position all the time
set ignorecase
set smartcase
set autoread         " when the file is modified externally, the file is automatically updated
set nobackup
set noswapfile
set clipboard+=unnamed " the default register is shared with the system clipboard
set winaltkeys=no
set mouse=a          " enable mouse under any mode
set tags=tags;       " begin find tags file from working directory
set autochdir        " set current dir as working directory

"--------------------------------------------------
" Lang & Encoding setting
"--------------------------------------------------
set fileencodings=utf-8,gbk2312,gbk,gb18030,cp936  " encode supported
set fileencoding=utf-8  " current file encode
set encoding=utf-8      " gvim internal file encode
set langmenu=zh_CN
let $LANG = 'en_US.UTF-8'
language messages zh_CN.utf-8  " avoid consle output garbled under windows system

" avoid menu garbled under windows system
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set fileformat=unix     " new file <EOL>

"--------------------------------------------------
" GUI setting
"--------------------------------------------------
colorscheme evening
set splitbelow       " the split window is located below
set splitright       " the split window is located to right
set guioptions-=T    " hide the toolbar
set guioptions-=m    " hide the menu bar
set guioptions-=L
set guioptions-=r
set guioptions-=b

set guioptions-=e    " use vim tab but not gvim

set guifont=Courier\ New:h14  " font and size
au GUIEnter * simalt ~x " the window is automatically maximized when it starts up

"--------------------------------------------------
" Find/replace setting 
"--------------------------------------------------
set hlsearch         " highlight search result
set incsearch        " Incremental search

"--------------------------------------------------
" Coding setting
"--------------------------------------------------
syntax enable        " syntax highlight
syntax on            " turn on file type detection
set autoindent       " always set autoindenting on
set expandtab        " use spaces instead of tabs
set shiftwidth=4     " 1 tab == 4 spaces
set tabstop=4
set showmatch        " show parentheses matching


