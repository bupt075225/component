#!/bin/bash

CONTEXT_DIR="/opt"

install_vim ()
{
    apt -y install vim
}

install_depend_tools ()
{
    apt install -y git universal-ctags ack
    # Gtags (GNU GLOBAL)
    apt install -y global
}

install_youcompleteme ()
{
    cd $CONTEXT_DIR
    cp -fr YouCompleteMe ~/.vim/plugged
    apt install -y build-essential cmake python3-dev
    apt install -y golang
    cd ~/.vim/plugged/YouCompleteMe
    python3 install.py --force-sudo --clangd-completer --go-completer
    if [ $? != 0 ];then
        exit 1
    fi
}

install_vim_plugins ()
{
    if [ ! -d "~/.vim" ];then
        mkdir -p ~/.vim
        cd ~/.vim
        mkdir plugged plugin syntax colors doc autoload
        cd -
    fi
    cp $CONTEXT_DIR/plug.vim ~/.vim/autoload/

    cp -fr $CONTEXT_DIR/ack.vim ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/ale ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/asyncrun.vim ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/LeaderF ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/nerdtree ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/vim-autotag ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/vim-fugitive ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/vim-gitgutter ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/vim-go ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/vim-gutentags ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/gutentags_plus ~/.vim/plugged/
    cp -fr $CONTEXT_DIR/vim-preview ~/.vim/plugged/

    cp -fr $CONTEXT_DIR/vimrc.linux /root/.vimrc
    install_youcompleteme
    vim +PlugInstall +qall
}

config_system ()
{
    # Enable git auto completion
    cp -fr $CONTEXT_DIR/git-completion.bash ~/.git-completion.bash
    echo "source ~/.git-completion.bash" >> ~/.bashrc

    # Show current git branch in command line
    cat $CONTEXT_DIR/show_git_branch_conf >> ~/.bashrc
}

clean_env ()
{
    rm -fr $CONTEXT_DIR/*
    apt clean
}

install_depend_tools
install_vim
install_vim_plugins
config_system
clean_env

mkdir -p /home/git_repo
