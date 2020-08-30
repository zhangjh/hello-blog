title: 使用IntelliJ Idea进行远程调试
show: true
date: 2016-12-15 14:29:30
tags: [idea,远程调试]
categories: 技术人生
---

最近接手了一个烂摊子项目，据说是多少年前的了，没有人会部署本地环境，只能在服务器上通过脚本部署。这么一来就没法使用IDE的调试功能了，排查问题很不方便，跟同事一沟通，发现他们之前是用远程调试来排查问题。用了这么久Idea了，今天还是第一次知道还有远程调试这个功能。本篇就记录一下怎么在Idea里开启远程调试。

1. 开启远程访问端口启动服务
以java应用启动为例，启动参数里要添加这条额外的命令：
	```
	-Xrunjdwp:transport=dt_socket,address=8089,server=y,suspend=n
	```
	其中的address就是要开启的远程访问端口

<!-- more -->

2. Idea打开工程，保证待调试代码和远程版本一致
	编辑debug配置，如下图，在Remote处
	![](http://ww1.sinaimg.cn/mw690/62d95157gw1farh0k000zj20uc0kqtbt.jpg)
	host填写远程机器地址，port填写8089

3. 添加该远程调试，开启debug调试
	![](http://ww1.sinaimg.cn/mw690/62d95157gw1farh0kp4ayj20uc0kqgo5.jpg)
	添加刚刚配置好的远程调试，点击Debug开启调试

4. 添加断点进行调试
	然后就跟本地调试一样啦
