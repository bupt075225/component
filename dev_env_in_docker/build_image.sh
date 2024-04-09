#!/bin/bash

WORK_DIR="/home/build_image"
INSTALLER="tools_installer.sh"
CUR_DIR=$(pwd)

prepare_context ()
{
    echo "preparing context"
    cp -fr $CUR_DIR/context/sources.list $WORK_DIR
    cp -fr $CUR_DIR/context/plug.vim $WORK_DIR
    cp -fr $CUR_DIR/context/show_git_branch_conf $WORK_DIR
    cp -fr $CUR_DIR/context/git-completion.bash $WORK_DIR

    cp $CUR_DIR/$INSTALLER $WORK_DIR
    cp $CUR_DIR/Dockerfile $WORK_DIR
    cp ../vimrc.linux $WORK_DIR
}

if [ ! -d "$WORK_DIR" ];then
    echo "making work directory"
    mkdir -p "$WORK_DIR"
else
    echo "work directory exist, clean stale files"
    rm -fr $WORK_DIR/*
fi

prepare_context

cd $WORK_DIR
docker build --progress=plain -t workstation:1.0 .
