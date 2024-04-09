#!/bin/bash

CONTEXT_DIR="/opt"

install_vim ()
{
    apt -y install vim
}

install_depend_tools ()
{
    apt install -y git universal-ctags ack
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
    cp -fr $CONTEXT_DIR/vimrc.linux /root/.vimrc
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

install_vim
install_depend_tools
install_vim_plugins
config_system
clean_env

mkdir -p /home/git_repo
