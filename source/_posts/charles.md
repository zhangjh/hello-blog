title: 使用Charles抓取调试手机请求
show: true
date: 2018-03-11 18:50:54
tags: [Charles,代理,抓包]
categories: 技术人生
---
<i class="iconfont" style="color: #1296db">&#xe65d;</i>  3/53，每周一篇博，坚持！

在实际工作的开发过程中，我们经常会遇到一些场景需要分析手机访问时的代码问题。这时候我们可以用Chrome提供的模拟手机功能，但有时候是无法模拟的，如请求涉及到了手机定位，这种情形我们只能使用手机端来请求才能获取到实际的请求参数。这时候一般我们都会动用抓包工具来将手机访问的请求代理到电脑上来。

抓包工具有很多，Charles就是一款非常好用的抓包工具。本篇博文里就针对使用Charles来抓取手机端访问请求做一番简介。

## 安装
Charles的安装非常简单，可以直接访问[Charles的官网下载页面](https://www.charlesproxy.com/download/)，选择合适自己操作系统的版本即可。Charles是收费软件，可以免费试用30天。试用期过后未付费用户仍然可以继续使用，但是每次使用超过30分钟后会需要关闭重启。这种引导付费的方案对大部分人来说还是非常友好的，即使你长期不付费也能使用完整的软件功能，30分钟的使用时长也应该能满足大部分人的使用需求了。
如果你出于各种原因，坚持要使用无任何"瑕疵"的版本，你可以选择付费，也可以自行搜索破解补丁。

<!--more-->

## Charles配置
安装完成后，Charles可以完成大部分的自动配置。需要用户自己配置的地方并不多。
手机端的设置部分需要自己设置一下：
1. 首先确保手机和电脑在一个局域网下。
2. 查看电脑的IP地址。这个有各种查看方法，可以通过点击Help->Local IP Address查看本机IP。
3. 打开Charles->Proxy->Proxy Setting菜单，调出Charles的代理设置。如图：
![](http://wx3.sinaimg.cn/large/62d95157gy1fp94hcllkpj20x20sagot.jpg)
图示为默认的设置，如果同时需要代理socks请求，可以打开socks mode。
4. 打开手机的无线网络，找到连接的Wifi设置代理。通常是在高级设置的位置，不同手机操作细节不一。以我的手机为例：
![](http://wx4.sinaimg.cn/large/62d95157gy1fp959s5praj20f00smdig.jpg)
设置代理方式为手动，填入代理服务器IP和端口，即上一步中查询的本地IP和端口。
如果你还是不会手动设置，你也可以采用Charles提供的自动设置方式：
在手机上打开链接：`https://chls.pro/X.X.X.X.pac`，其中X.X.X.X即为上述本机IP，如果你修改了默认端口，那么还需要指定端口：`https://chls.pro/X.X.X.X:XXXX.pac`
5. 使用Charles抓包，现在手机访问任意一个程序试试，看看Charles的抓包是不是就生效了。
![](http://wx4.sinaimg.cn/large/62d95157gy1fp95jybtjnj21om0uqn7g.jpg)
6. 通过截图可以看到有一些请求的前面有一个带锁的小图标，这个其实意思是请求是走的SSL请求，需要设置下SSL Proxy，否则是无法解析的。

	- 我们可以打开Proxy->SSL Proxy Settings，然后将目标地址配置进去，或者直接填写"*,443"
	![](http://wx3.sinaimg.cn/large/62d95157gy1fp95v71b6yj20wo0oadjp.jpg)
	表示抓取任意网站的https请求。
	- 电脑端安装SSL证书
	![](https://upload-images.jianshu.io/upload_images/5337737-895a3736db7ce118.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/507)
	- 手机端安装证书
	![](https://upload-images.jianshu.io/upload_images/5337737-c17b7752efa93560.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/554)
	弹出的对话框中会提示一个链接地址`chls.pro/ssl`，直接访问即可。
7. 试一下抓取https吧。以笔者的`https://favlink.cn`为例：
![](http://wx3.sinaimg.cn/large/62d95157gy1fp961hb9ghj21os0q4gsh.jpg)
完美！
8. 如果要修改某个请求参数，可以选中请求后点击菜单栏上钢笔形状的按钮即可修改请求执行。
![](http://wx2.sinaimg.cn/large/62d95157gy1fp96f63fnqj225o0ks44o.jpg)

如果在进行过程中，发现手机端连接不上Charles，可以看看防火墙是否关闭，防火墙如果开启会影响Charles的连接。

## 结语
除了抓包之外，Charles还有很多其他实用功能：重发请求、修改请求、模拟慢速网络、代理等。本篇主要就抓包做了简要介绍，详细的功能可以参看[Charles的完整使用文档](https://www.charlesproxy.com/documentation/tools/)。
