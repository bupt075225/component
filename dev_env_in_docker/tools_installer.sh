#!/bin/bash

CONTEXT_DIR="/opt"

install_yum_repos ()
{
    rm -fr /etc/yum.repos.d/*
    cp $CONTEXT_DIR/*.repo /etc/yum.repos.d/
    cp $CONTEXT_DIR/RPM-GPG-KEY-EPEL-8 /etc/pki/rpm-gpg/
}

install_depend_tools ()
{
    yum install vim -y
    yum install ack -y
    yum install git -y
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

install_yum_repos
install_depend_tools
install_vim_plugins

