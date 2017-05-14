#!/bin/bash

TOP_DIR=`pwd`
WORK_DIR=$TOP_DIR/iso
ISO_FILE="sec-stor-x86_64.iso"
PRODUCT_SW_DIR="/home/admin/rpmbuild/RPMS/x86_64"
PRODUCT_TOOLS_DIR="../../third-part-tool"
POST_INSTALL_SCRIPT="../../src/util"

function usage()
{
    echo ""
    echo "Usage: $0 [-iu]"
    echo -e "\t-h --help"
    echo -e "\t-i    Setup build environment and the first run to build ISO"
    echo -e "\t-u    Update partly file exclude copying from cd-rom then rebuild ISO"
    echo ""
    exit 1
}

function error_exit()
{
    umount /mnt
    echo "Error exit"
    exit 1
}

# 拷贝产品软件RPM包到Packages目录
function copy_product_sw()
{
    count=`ls $PRODUCT_SW_DIR/*.rpm | wc -l`
    # 产品软件共计有3个RPM包
    if [ $count != 3 ];then
        echo -e "\nError: product software packages not found"
        exit 1
    fi

    cp -fr $PRODUCT_SW_DIR/*.rpm $WORK_DIR/isolinux/Packages/

}

# 检查RPM包的依赖关系
function check_package_dependency()
{
    rpm --initdb --dbpath /tmp/testdb
    cd $WORK_DIR/isolinux/Packages/
    echo "Checking RPM packages dependency"
    rpm --test --dbpath /tmp/testdb -Uvh *.rpm
    if [ $? != 0 ];then
        echo "Error: check package dependency fail"
        rm -fr /tmp/testdb
        exit 1
    fi
    rm -fr /tmp/testdb
}

# 生成ISO文件
function generateISO()
{
    echo "*****Step3: copy post install files and customer software"
    cp -fr $PRODUCT_TOOLS_DIR/* $WORK_DIR/isolinux/postinstall/third-tools/
    cp $POST_INSTALL_SCRIPT/post_install.sh $WORK_DIR/isolinux/postinstall/
    chmod +x $WORK_DIR/isolinux/postinstall/post_install.sh

    copy_product_sw
    check_package_dependency

    echo "*****Step4: copy kickstart config file"
    cp $TOP_DIR/ks.cfg $WORK_DIR/isolinux/ks/

    echo "*****Step5: generate respority data info"
    cd $WORK_DIR/isolinux
    createrepo -g $WORK_DIR/comps.xml . 

    echo "*****Step6: build the ISO"
    cp -f $TOP_DIR/isolinux.cfg $WORK_DIR/isolinux/

    cd $WORK_DIR
    if [ -e "$ISO_FILE" ];then
        rm -f $ISO_FILE
    fi
    mkisofs -o $ISO_FILE -b isolinux.bin -c boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -R -J -v -T isolinux/
}

#-----------------------------main-----------------------------------#
# 命令行参数解析
if [ $# -gt 1 ] || [ $# -eq 0 ];then
    usage
fi
    
# 更新部分文件后直接生成ISO，不重新从光盘拷贝所有文件
if [ $# -eq 1 ] && [ $1 == "-u" ];then
    echo "*****Skip copy files from cd-rom"
    generateISO
    exit 0
fi

if [ $# -eq 1 ] && [ $1 != "-i" ];then
    usage
fi

# 开始构建工作环境,从安装光盘拷贝所有文件来新构建ISO
echo "*****Step1: create work directory"
if [ -d "$WORK_DIR" ];then
    rm -fr $WORK_DIR
fi

mkdir -p $WORK_DIR
mkdir -p $WORK_DIR/isolinux
mkdir -p $WORK_DIR/isolinux/{images,ks,Packages,LiveOS,postinstall}
mkdir -p $WORK_DIR/isolinux/postinstall/third-tools

echo "*****Step2: copy file from cd-rom"
ret=`lsscsi -si | awk '$4 ~ /DVD/ {print $4}'`
if [ -z $ret ];then
    echo "Error: cd-rom not found, please insert DVD drive."
    error_exit
fi

cd_name=`lsscsi -si | awk '/DVD/ {print $7}'`
umount /mnt & > /dev/null
mount $cd_name /mnt
if [ $? != 0 ];then
    echo "Error: mount cd-rom fail."
    error_exit
fi

# 从安装光盘中拷贝文件
echo "Copying files,please wait for a moment..."
cp -fr /mnt/isolinux/* $WORK_DIR/isolinux
cp -fr /mnt/.discinfo $WORK_DIR/isolinux
cp -fr /mnt/images/* $WORK_DIR/isolinux/images
cp -fr /mnt/LiveOS/* $WORK_DIR/isolinux/LiveOS
cp /mnt/repodata/*-x86_64-comps.xml.gz $WORK_DIR/comps.xml.gz
gunzip -d $WORK_DIR/comps.xml.gz

# 开始拷贝RPM包
while IFS='' read -r line || [[ -n "$line" ]];
do
    echo "Copying RPM package: $line.rpm"
    cp /mnt/Packages/$line.rpm $WORK_DIR/isolinux/Packages/
    if [ $? != 0 ];then
        echo "Error: copy $line.rpm fail"
        error_exit
    fi
done < $TOP_DIR/rpmlist.log

generateISO

# 生成ISO后卸载光盘
umount /mnt
echo "Build ISO complete, fetch $ISO_FILE under $WORK_DIR"
exit 0
