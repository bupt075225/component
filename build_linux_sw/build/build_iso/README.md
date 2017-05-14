该目录下存放构建映像文件的核心文件。映像文件用于生产灌装。

## 文件功能介绍

build_iso.sh　　　　　建立构建映像文件的工作环境，自动构建映像文件

ks.cfg　　　　　　　　kickstart配置文件

mvRPMs.py　　　　　从安装光盘拷贝RPM包的Python脚本

rpmlist.log　　　　　　定制映像文件所需的RPM包名

isolinux.cfg　　　　　　安装菜单配置文件，其中包含了kickstart自动安装选项

