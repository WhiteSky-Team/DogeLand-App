#
# DogeLand CLI Module
# 
# license: GPL-v2.0
#
deploy_linux(){
echo "- 正在检查"
if [ ! -n "$rootfs2" ]; then
    echo "- 无效安装路径"
    exit 255
    sleep 1000
    else
    echo "">/dev/null
fi
if [ ! -n "$file" ]; then
    echo "- 无效系统包文件"
    exit 255
    sleep 1000
    else
    echo "">/dev/null
fi
#
# Install
#
echo "- 正在安装 $file"
rm -rf $rootfs2
mkdir $rootfs2/
if [ `id -u` -eq 0 ];then
 tar -xzvf $file -C $rootfs2 >/dev/null
else
 proot --link2symlink $TOOLKIT/busybox tar -xzvf $file -C $rootfs2 >/dev/null
fi
#
# Settings
#
echo "- 正在设置"
# Set Configure
echo "Stop">$rootfs2/status
rm -rf $CONFIG_DIR/cmd.conf
echo "/bin/sh /cli.sh dropbear_start">$CONFIG_DIR/cmd.conf
echo "!初始化命令行已设置默认启动dropbear"
rm -rf $CONFIG_DIR/rootfs.conf
echo "$rootfs2" >$CONFIG_DIR/rootfs.conf
#
mkdir $rootfs2/sys
mkdir $rootfs2/dev
mkdir $rootfs2/proc
if [ -d "$rootfs2/etc/dropbear" ];then
  chmod -R 0777 $rootfs2/etc/dropbear/
  else
  echo "">/dev/null
fi
# Install CLI
cp $TOOLKIT/cli.sh $rootfs2/
mkdir $rootfs2/include/
cp -R $TOOLKIT/include/* $rootfs2/include/
# ReadRootfsInfo
echo "- 正在解析包"
if [ -f "$rootfs2/info.log" ];then
cat $rootfs2/info.log
echo ""
else
echo "- 找不到文件,可能不是官方包或者包损坏也可能解压失败"
fi
echo ""
if [ -d "$rootfs2/etc/dropbear/" ];then
  echo "">/dev/null
  else
  mkdir $rootfs2/etc/dropbear/
fi

sleep 1
source $TOOLKIT/linux-deploytool.sh configure
}