安装说明

假定安装系统路径为iso_make

1. 启动脚本修改
   直接修改init目录下的文件
   其中init/install目录下存放安装脚本
   修改完成后，在iso_make目录下运行
        ./mkcpio.sh，即可在iso_make目录下生成initrd.gz
2. 文件系统修改
   文件系统如果有修改，需要重新生成ISO镜像文件
   将修改后的文件替换iso_c/install目录下的同名文件
   在iso_make目录下运行：
        ./geniso.sh
   即可在iso_make目录生成linux.iso文件
   注：该脚本会自动将iso_make下的initrd.gz文件复制到iso-c目录下的同名文件

3. USB启动
   3.1 按以前的方法生成USB启动盘。
   3.2 将iso-c目录下的vmlinuz, initrd.gz复制到U盘根目录
   3.3 将iso-c目录下的isolinux/isolinux.cfg复制到U盘根目录，并重命名为syslinux.cfg（老版本的syslinux使用这个名字）
   3.4 将生成的linux.iso放到U盘根目录


