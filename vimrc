"--------------------------------------------------
" Descriptor: vimrc for Linux no plugin
" Author: Bill Liu
" Email: nonprivatemail@163.com
"--------------------------------------------------

set incsearch    " incremental search
set hlsearch     " highlight search result
set nocompatible " use Vim defaults (much better!)
set autoindent   " always set autoindenting on
set history=50   " keep 50 lines of command line history
set ruler        " show the cursor position all the time
set showcmd
set writebackup
set nu
set ignorecase
syn on
set si
set showmatch smartcase
set showmode
set wrapscan
set nowrap
set autoread
set ff=unix
set expandtab " use spaces instead of tabs
set shiftwidth=4 " 1 tab == 4 spaces
set tabstop=4

:syntax enable
:colorscheme evening

if getfsize("vimscript")>0
    source vimscript
    " CTRL-F12 product ctags DB
    nmap <C-F12>:!ctags -R .<CR><CR>
endif

" If Vim has got support for cscope
if has("cscope")
    set csprg=/usr/bin/cscope
    " change this to 0 to search cscope DBs first,1 to search ctags DBs
    set csto=1
    " search cscope and ctags DB at the same time
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add databse pointed to by environment
    "elseif #CSCOPE_DB != ""
        "cs add $CSCOPE_DB
    endif
    set csverb

    " using 'CTRL-\' then a search type makes the vim window
    " c:jump to function caller
    " d:list function to be called 
    " e:egrep search
    " s:search symbol definition
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
endif
