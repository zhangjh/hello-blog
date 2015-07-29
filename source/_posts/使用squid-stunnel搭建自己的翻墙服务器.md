title: 使用squid+stunnel搭建自己的翻墙服务器
date: 2015-07-17 10:30:38
tags: 翻墙 squid stunnel vpn代理
categories: 技术人生 
photos:
	- http://ww3.sinaimg.cn/large/62d95157gw1eu5kesk5m5j20dw0c2js1.jpg
---

　　GFW让国内的码农们要比国外同行们必须多掌握一门必备技能：**翻墙**。
　　就为了更好的上网体验，天朝上国的我们要跟移动、联通、电信(死比运营商肆无忌惮搞网络劫持推送广告)，工信部(互联网内容审查)，GFW作斗争，浪费大好光阴，真是想想就让人想[**爆粗**](http://www.bilibili.com/video/av2550217)。这不，大GFW最近技术又牛逼了，goagent已经被墙的半身不遂了。。有这技术研究点别的多好，天朝的网络审查制度典型的"把洗澡水和孩子一起泼了"：翻墙的除了去看法哔功的，也有社会主义现代化建设的我们啊。
　　我本身翻墙的时候不多，用上的时候开下goagent基本也能对付了，虽然对限制自由这事很不爽，但也只能不爽了。可最近goagent也总是不能用了，这尼玛还咋玩。。
　　租用的国外服务器只部署个博客好像有点浪费，这基本只有我自己看的玩意儿能用多少流量，太浪费了啊。于是想着是否可以自己搭建个代理实现肉身翻墙呢？
　　下面是我折腾的通过*国外服务器+squid+stunnel+chrome+SwitchOmege*实现的代理翻墙方式，照着操作你也可以。

<!--more-->

# 翻墙原理
　　1. 客户端向stunnel服务器发送访问请求
　　2. stunnel将请求加密后发送给代理服务器的stunnel服务
　　3. 代理服务器的stunnel服务接收到请求后将请求解密发送给代理服务器的squid服务
　　4. squid服务接收到实际的客户端访问请求(经过了加密解密处理)，向目标网站请求并返回数据

　　之所以要加上stunnel加密，是因为GFW会把请求墙掉，导致原始请求连代理服务器都发送不过去。
# 物料准备
　　1. 国外服务器，可以正常无限制访问互联网，用来代理国内被墙的请求
　　2. 国内服务器，可以是服务器也可以是自己的主机，用来做stunnel加密服务器
　　3. stunnel，squid，chrom以及chrome下的代理插件SwitchOmega(stunnel，squid必须，客户端代理可以采取别的浏览器)
#环境
　　1. 我的国外服务器系统是Centos 6.0-x86，以下称为服务器A
　　2. 我的国内stunnel采用的也是服务器部署，之所以没有采用自己的主机，考虑到如果将stunnel加密服务也部署在我的客户端上的话，只要我电脑关机后就要重新启动stunnel服务，而且如果换电脑的话就不能用了。因此将服务和客户端分开了，没有条件的可以将stunnel加密服务搭建在自己的主机上亦可。以下称stunnel加密服务器为服务器B，自己用来上网的电脑称为客户端。
　　服务器Ｂ的系统是Linux 2.6.32。
# 搭建步骤
## 服务器A上安装squid以及stunnel
- 安装squid
`yum install squid`
- 修改squid配置文件：

```
vim /etc/squid/squid.conf      #路径以自己安装的为准
```
将配置文件的
```
http_access deny all
修改为
http_access allow all
其余多余的http_access选项删除
```
- 启动squid
`service squid start`

- 安装stunnel
`yum install stunnel`
由于需要stunnel进行加密，因此还需要生成相应的密钥：(依赖openssl，通常linux发行版都自带了，如果没有预装可以自行安装)
```
cd /usr/local/etc/stunnel/
openssl req -new -x509 -days 1000 -nodes -out stunnel.pem -keyout stunnel.pem  
#生成一个有效时间1000天的证书文件stunnel.pem

```
- 修改配置文件
```
vim /usr/local/etc/stunnel/stunnel.conf    #路径以自己安装的为准
```
我的配置文件：
```
fips=no
syslog=yes
debug=7
output=/var/log/stunnel.log
setuid=root                        #我是部署在root账户下，看部署的账户了 
setgid=root                          
pid=/var/run/stunnel.pid
cert=/usr/local/etc/stunnel/stunnel.pem     #上述生成的证书文件路径
key=/usr/local/etc/stunnel/stunnel.pem
client=no
[squid]
accept=443                         #stunnel的监听接口 
connect=127.0.0.1:3128             #服务器A的connect配置基本没啥用
```
- 启动stunnel
`stunnel stunnel.conf`
	
# 服务器B上安装stunnel
在服务器B上安装stunnel，步骤类似服务器A，需要注意的是，证书文件可以和服务器A一样，直接复制过来即可。
- 修改配置文件：
我的配置
```
cert = ./stunnel.pem               #复制过来的证书文件路径
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
verify = 2
CAfile = ./stunnel.pem
client=yes
compression = zlib
ciphers = AES256-SHA
delay = no
failover = prio
sslVersion = TLSv1
fips = no
[sproxy]
accept  = 8888                     					#服务器B上stunnel的监听端口，可以随便设，影响客户端的代理设置 
connect = 服务器A的IP:服务器A的stunnel监听端口      #填写服务器A的IP和端口，用来和A交互
```
- 启动stunnel

# Tests
配置差不多了，配置下客户端代理试试看吧
1. 下载chrome浏览器下的代理管理插件SwitchOmega
2. 配置代理地址
![](http://ww1.sinaimg.cn/large/62d95157gw1eu5s08oeo9j20o605jmy2.jpg)
代理地址填写服务器B的地址，端口填写服务器B上stunnel服务器的监听端口

访问被墙地址的时候将模式切换到设置的该模式。
	
![](http://ww1.sinaimg.cn/large/62d95157gw1eu5tgaewnxj20p508m76l.jpg)

Ｇｏｏｄ！
