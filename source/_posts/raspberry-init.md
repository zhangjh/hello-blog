title: 树莓派安装完系统后必做的几件事--树莓派初始化操作
show: true
date: 2017-07-31 14:36:25
tags: [树莓派,raspberry]
categories: 技术人生
---
# 背景
阅读本文需要你有一定的Linux编码水平，至少能够读懂Bash，对于一个树莓派玩家来说这都不是事儿了吧。

树莓派使用Micro SD卡来作为系统存储，而SD卡又很容易坏，当我们辛苦配置好的树莓派工作环境因为SD卡挂掉，重装时各种配置又要来一趟真的很奔溃，关键还不记得当初一个个都配置了啥了。。

我最近在配置树莓派时就遇到了类似的问题，因为挂载移动硬盘出了点差错(下文会说)，导致系统启动失败，以为是系统被我折腾坏了，格了好几遍SD卡重装，每次都要把软件、配置都重来一遍，于是索性将第一次开机后必做的几件事写成了初始化脚本传到github了，重装后直接下下来执行下就解决了。方便多了，再也不怕重装系统。

顺便记录下导致我写这个自动化初始化树莓派脚本的最初问题。

# 问题
一开始我的树莓派是没有显示器的，都是使用VNC远程连接。最近在配置了不知道哪个东西后，树莓派就连不上了，反复重装过几次，经过一番配置之后重启后必然又连不上。后来搞了跟显示器的连接线，启动后发现树莓派进入了"**emergency mode**"，网上查了下，解决方案对我都不适用，最后我才发现，原来是我在设置自动挂载移动硬盘的时候出错，导致系统启动失败。我的硬盘是NTFS格式的，而树莓派不能直接挂载ntfs格式，需要先安装一个`ntfs-3g`工具。由于重装过系统，忘记了安装这个，直接将挂载命令写入了fstab文件而又没有验证是否能够挂载成功(毕竟挂载过太多次了，想当然以为没问题了)。

<!--more-->

# 树莓派初始化
痛定思痛，这些安装后的初始化配置操作，每次重装都不可避免要做，重复而又繁琐，经常还会忘记还有哪些没有做。干脆写成自动化命令来操作好了。
首先我们要确定哪些东西是树莓派安装系统完之后是必不可少的，在我看来，我的树莓派启动后必须要做到这些才能算是一个可以工作的树莓派了：
```
更新pi用户密码
更新国内源
安装中文环境
安装VNC
安装ftp
安装samba
修改sh指向bash
挂载外部存储
安装VIM并设置vimrc
安装node环境
设置alias
设置开机启动服务
设置无线连接
```
考虑到，我们也许并不是每次都要完整的走完这么多步，脚本应该灵活地支持我们只执行某一个特定步骤，我们希望脚本可以通过接收参数来执行某个特定步骤。比较长的配置文件内容我们可以设置好了cp替换到特定位置。下面直接上代码。
只挑选几个步骤说明，完整代码请[**戳此查看**](https://github.com/zhangjh/forgottenGoodThings/blob/master/pi/initPi.sh)。
```bash
#0. 首先我们要确定sudo权限
function checkSu(){
    touch /root/test
    if [ $? -ne 0 ];then
        echo "Must run as root or sudo !"
    	exit
    fi
    rm /root/test
}

#1. 修改更新源为国内源，加快下载速度
function updateSource(){
    cat /etc/apt/sources.list | grep -q "aliyun"
    # 不是国内源时替换
    if [ $? -ne 0 ];then
        cp /etc/apt/sources.list /etc/apt/sources.list.bak
        echo "deb http://mirrors.aliyun.com/raspbian/raspbian/ jessie main contrib non-free" > /etc/apt/sources.list
        echo "deb-src http://mirrors.aliyun.com/raspbian/raspbian/ jessie main contrib non-free" >> /etc/apt/sources.list
        apt-get update
        apt-get upgrade
    fi
}

#5. 挂载外部存储
function mountDisk(){
    disk=`fdisk -l | grep "/dev/sda[0-9]" | awk '{print $1}'`
    if [ "X${disk}" != "X" ];then
        # 挂载点不存在设置挂载点
		if [ ! -e /mnt/share ];then
            mkdir -p /mnt/share
            chown pi:pi /mnt/share
        fi
        df -h | grep -q "/mnt/share"
        if [ $? -ne 0 ];then
			# ntfs-3g不存在时先安装
            version=`which ntfs-3g`
            if [ "X${version}" == "X" ];then
                apt-get install ntfs-3g
            fi
            mount ${disk} /mnt/share
        fi
        #8. 自动挂载
        cat /etc/fstab | grep -q "${disk}"
        if [ $? -ne 0 ];then
            echo "/dev/sda1 /mnt/share/ ntfs-3g slient,umask=0,locale=zh_CN.utf8 0 0" >> /etc/fstab
        fi
    fi
}
```
接收参数我们可以使用Shell的getopts，以上步骤都独立成函数，运行时可以通过传入特定的参数运行特定步骤：
```bash
while getopts "pbsvfSnmriIaAh" opt 
do
    case ${opt} in
      p) updatePasswd;;
      b) updateBash;;
      s) updateSource;;
      v) installVnc;;
      f) installFtp;;
      s) installSamba;;
      n) installNode;;
      m) mountDisk;;
      r) setVimrc;;
      i) updateStartup;;
      I) installInputMethod;;
      a) setAlias;;
      A) all;;
      h) Usage;;
    esac
done
```
如果忘记了哪个参数是执行什么操作的，可以传递`-h`查看帮助信息。

