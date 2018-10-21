title: 给网站添加HTTPS证书，提供HTTPS安全服务
show: true
date: 2018-10-21 15:40:25
tags: [https,nginx,证书]
categories: 技术人生
---
首先说点题外话，今年本来立了个flag，每周写一篇博客，结果写到第18篇就一直停更到现在了，脸都被打肿了。。。
flag实在是不能立啊。今年上半年忙成狗，还没有拿到好的结果，世事难料啊~唯成长不能停息，下半年博客还是要继续写起来，想分享想记录的还是有很多话题，要克服自己的惰性，虽然下半年还有装修的事要忙，也不要给自己立flag了，尽力克服惰性多分享一些多记录一些吧。

目前HTTPS渐渐普及，Chrome还把http服务的网站标记为不安全。之前把[藏经阁](https://favlink.cn)升级成了HTTPS，博客呢一直没有弄，有一些外部依赖需要整，不像藏经阁单页应用基本无外部依赖，就搞个证书升级下就好了那么简单。今天抽空把博客也升级成了HTTPS，这里就从头做个简单的总结分享下吧。

#### 一. 申请HTTPS证书
HTTPS为什么能保证信息传输的安全性的理论知识我就不多介绍了，简单说一下，如果要提供HTTPS证书，必不可少的是CA证书。证书就像一个权威机构，你接入了就可以保证数据传输的安全性，因为https协议需要加密传输，加解密的过程需要证书授权。
关键地，一个HTTPS证书通常价格不菲，针对个人站点一般都无法承受。好在[阿里云](https://yundun.console.aliyun.com/?spm=5176.2020520001.1011.3.7a1b4bd30oLJhd&p=cas#/cas/home)提供针对个人单域名的免费证书服务，貌似腾讯云也有类似服务，这里以阿里云的为例介绍。

1. 购买证书
从上面链接进入阿里云证书服务，点击购买证书，选择赛门铁克的免费型证书，如图所示
![](http://wx2.sinaimg.cn/mw690/62d95157ly1fwfwhmet65j21kw0w4wnk.jpg)

2. 补全域名信息
购买成功后返回证书控制台，点击补全补全域名信息
这里需要注意的是，阿里云会校验你填写的域名是否真的为你所有，需要你去域名解析处增加一条TXT解析记录，指向所要求的值，按照控制台给出的值进行操作即可

3. 签发完成
信息补全后系统会自动检测，满足要求后会自动签发，这个过程还是比较快的。通常添加了解析记录后很快就能收到签发短信。
在控制台里可以看到已签发的证书。

<!--more-->

#### 二. 设置HTTPS证书
从控制台处下载已签发的HTTPS证书，相应地有安装提示。
通常利用Nginx进行端口转发，这里以Nginx安装为例。
Nginx的安装本篇不多做介绍，百度一下有很多介绍。

下载的证书主要包括两个文件，一个以key后缀结尾的另一个以pem后缀结尾的。
你可以给文件改名，但两个文件的内容都不要做任何改动。

在nginx的安装目录下创建cert目录，最终的目录结构如下：
```
- nginx
  -- sbin   //执行文件目录
  -- conf   //配置文件目录
  -- cert   //证书目录
```
修改nginx.conf，加入证书信息，将安装提示部分加入nginx配置文件的http部分，以下贴出我的主体部分nginx配置加以说明：
```
	upstream blog {
		server 127.0.0.1:4000;
    }

    server {
		listen	80;
		server_name zhangjh.me;
		return 301 https://zhangjh.me;
    }

    # HTTPS server
    server {
	    listen 443 ssl;
	    server_name zhangjh.me;
	    root html;
	    index index.html index.htm;
	    ssl_certificate   /xxxxx.pem;
	    ssl_certificate_key  /xxxxx.key;
	    ssl_session_timeout 5m;
	    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
	    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	    ssl_prefer_server_ciphers on;
	    location / {
			root html;
			index index.html index.htm;
			proxy_pass http://blog;
	    }
    }
```
`upstream`配置一个名为"blog"的负载均衡器,指明服务信息为本机的4000端口服务，第一个server配置了一个80端口监听器，当请求域名为"zhangjh.me"的80端口服务时，301重定向https的服务地址，样就可以保证用户无论访问http还是https最终都可以得到https服务。

第二个`server`配置的则是https的服务。https的默认端口是443，这里的`ssl_certificate`和`ssl_certificate_key`字段需要配置到下载的https证书的全路径地址。location字段表明所有的请求都将被转向proxy_pass配置的负载均衡器去。也就是本机的4000端口服务。

#### 三. 服务https升级改造
上述配置完成后，https证书就已经安装完毕，可以试试服务是否已经自动转向https服务了。
但在实际的使用当中需要注意的是，由于浏览器安全策略的存在，https服务如果加载http的资源和服务会被浏览器拦截。
也就是说，如果原先的服务未做改造，直接提供https服务的话，就可能存在一些资源和服务被浏览器拒绝加载而出现影响服务功能的问题出现。
因此我们需要先对服务进行https的升级改造然后再提供https服务。

这里我忘记截图了，我以微博的提示做一个说明：
![](http://wx3.sinaimg.cn/mw690/62d95157ly1fwfxcr0yh3j21kw0a0tkl.jpg)
可以看出来，微博现在还不支持HTTPS。在https访问下，存在很多资源文件由于安全策略被拦截掉。图中的"Mixed Content"提示就是。通常红色的必须要解决掉，黄色的告警可以忽略，一般不会影响功能使用。

我们在升级时也可以根据这个提示来找出我们有哪些依赖是需要进行改造的。
如果是支持https服务的依赖，我们可以在依赖的时候去除写死的scheme，采用无scheme方式引用，即：
```
<script src="http://code.jquery.com/jquery-3.3.1.min.js"></script>
```
改成
```
<script src="//code.jquery.com/jquery-3.3.1.min.js"></script>
```
这样，所加载的文件就会采用我们访问的网站的scheme来定。
不幸的是，不是我们依赖的所有服务都已经改造成了HTTPS，这种情况下，如果强行改成https依赖肯定不行，会找不到资源。这时就只能排除该依赖寻找替代了。否则我们的网站也就不能进行https改造。

如果你发现了我的博客有哪里改造不全导致功能存在问题，欢迎给我留言反馈哦~·~
