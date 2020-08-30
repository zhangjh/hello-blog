title: gitcafe pages托管的博客dns解析
show: true
date: 2015-12-17 16:35:45
tags: [gitcafe pages,gitcafe dns,gitcafe 域名解析]
categories: 技术人生
---
#### 背景
博客托管在github上，目前有很重要的两个问题：
{% cq %} 
1. github拒绝百度收录
2. 每次发文章都会有github page build warning告警邮件
{% endcq%}

上次写了一篇解决告警邮件的问题，但百度不能收录的问题貌似不能同时被解决。虽然改回去以后短暂的百度可以收录了，但今天看又不能收录了，真是。。。

于是今天又折腾了一把，把博客迁移到gitcafe上托管了，不纠缠了，顺带还能提升访问速度。

本篇不是探讨如何迁移，网上一搜已经一把了，主要想记录一下迁移到gitcafe后如何进行自定义域名的解析。
关于这个问题，网上一水的文章，就没看到一个解释清楚了的，都是直接就贴配置了，但那些ip都是怎么来的呢？没有任何的说明，难道我的配置也可以写你的ip？这个就连[**官方的help文档**](https://help.gitcafe.com/manuals/help/pages-services#绑定自定义域名)也是语焉不详。

以下是我自己折腾成功后的结果，记录下来供后来者借鉴。为此还付出了网站一段时间无法访问的代价。。

<!--more-->

#### 解析方法
1. 和github不一样，gitcafe不用在项目下建立CNAME文件
2. dig反查自己gitcafe pages的ip，将自定义的域名解析到该ip上
```js
	//我的gitcafe pages域名：JHspider.gitcafe.io，按需替换
	dig JHspider.gitcafe.io

```
找到结果中标红的那行
![](http://ww1.sinaimg.cn/mw690/62d95157gw1ez2raaxsvtj20j309e76b.jpg)
此处的ip即为网上多数文章中直接给出的ip的来源。
在域名解析商处，配置A记录，将自定义的域名解析到此ip即可。

以我的阿里云解析为例：
![](http://ww2.sinaimg.cn/mw690/62d95157gw1ez2rcob54zj20pt03fjrk.jpg)

