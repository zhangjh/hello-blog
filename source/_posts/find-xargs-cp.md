title: 使用find结合xargs进行大批量复制
show: true
date: 2016-07-19 19:59:32
tags: [find,xargs,cp]
categories: 技术人生
---
##### 背景
今天在写脚本的时候遇到这么一个问题，cp复制过程中报错：
```
cp: will not overwrite just-created `xxxx'
```
没来由的，cp这么基础的命令怎么还会出错？想了想我这命令也就复制的文件多一点，可能是cp的文件太多了，导致cp参数超限了。于是开始验证，同样的复制命令，删除了一些文件之后就cp成功了。

虽然根据谷歌查找到的[**资料**](http://unix.stackexchange.com/questions/110282/cp-max-source-files-number-arguments-for-copy-utility)显示，我这cp的源文件长度还远没有到达最大限制。不纠缠于此，既然文件太多了，那么使用xargs来复制吧。

##### xargs
直接附上命令：
```
find ${src_dir} -type f | xargs -i cp {} ${dst_dir}
```

由于cp是二元操作，需要传入源文件，这里需要使用xargs的替换模式。使用`-i`参数，然后可以使用`{}`表示来自标准输入的参数。
