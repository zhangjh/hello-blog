title: xz格式文件的解压
show: true
date: 2016-08-04 16:34:42
tags: [xz,解压]
categories: 技术人生
---

安装node的时候经常会下载到xz格式的压缩包，它是tar包外层在用xz压缩一遍，压缩比更高。

用的不是很多，但正因为此每次用到都要查一下，记录一下：

```
#解压：
xz -d file.xz
tar -xvf file.tar

#如果没有xz命令，安装一下
sudo yum install xz 
```
