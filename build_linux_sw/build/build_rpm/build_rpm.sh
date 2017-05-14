#!/bin/bash 

MACROS_CONFIG="$HOME/.rpmmacros"
WORK_DIR="$HOME/rpmbuild"
SPEC_FILE="demo.spec"
SOURCE_TARBALL_NAME="demo-1.0.tar"

username=`whoami`
if [ $username == 'root' ];then
    echo "Warning: Forbid root user build RPM package"
    exit 1
fi

# 确认发布版本号
demo_version=`awk '/define demo_version/ {print $3}' $SPEC_FILE`
subsys_version=`awk '/define subsys_version/ {print $3}' $SPEC_FILE`
echo  "------------------------------------------"
echo  "SPEC文件中定义的包发布版本号如下"
echo  "用户态应用程序RPM包发布版本:    $demo_version"
echo  "内核子系统模块RPM包发布版本:    $subsys_version"
echo  "------------------------------------------"
echo -e -n "\n请确认以上发布版本(y/n):"
read selection
echo $selection
if [ $selection == 'y' ];then
    echo "Begin to build RPM packages"
elif [ $selection == 'n' ];then
    echo -e "\nPlease update release version in ./$SPEC_FILE"
    exit 0
else
    echo "Invalid input"
    exit 1
fi

# 创建目录结构
echo ">>>>>>>Create directory"
if [ -d $WORK_DIR ];then
    echo "Warnning: Work directory existed and now remove"
    rm -fr $WORK_DIR
fi

mkdir -p $WORK_DIR/{BUILD,RPMS,SOURCES,SPECS,SRPMS,BUILDROOT}

# 创建宏配置文件
echo ">>>>>>>Create RPM macro config"
if [ -f $MACROS_CONFIG ];then
    echo 'Warnning: Macros config file existed and now remove'
    rm -f $MACROS_CONFIG
fi

echo "%_topdir %(echo $HOME)/rpmbuild" >> $MACROS_CONFIG
echo "%debug_package %{nil}" >> $MACROS_CONFIG
echo "%__os_install_post %{nil}" >> $MACROS_CONFIG

# 拷贝SPEC文件
echo ">>>>>>>Copy RPM SPEC file"
cp ./$SPEC_FILE $WORK_DIR/SPECS 
if [ $? != 0 ];then
    echo "ERROR: copy RPM SPEC file fail"
    exit 1
fi

# 打包源码
echo ">>>>>>>Compress source code"
cd ../../src
tar -czf $SOURCE_TARBALL_NAME * 
if [ $? != 0 ];then
    echo "ERROR: get source code tarball fail"
    exit 1
fi
mv $SOURCE_TARBALL_NAME $WORK_DIR/SOURCES

# 构建RPM包
echo ">>>>>>>Begin build RPM package"
cd $WORK_DIR
rpmbuild -ba $WORK_DIR/SPECS/$SPEC_FILE
if [ $? != 0 ];then
    echo "ERROR: build RPM package fail"
    exit 1
fi

echo "Building RPM complete and fetch RPM package under directory $WORK_DIR/RPMS/"
