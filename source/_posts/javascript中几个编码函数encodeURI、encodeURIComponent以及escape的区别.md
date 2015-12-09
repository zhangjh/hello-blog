title: javascript中几个编码函数encodeURI、encodeURIComponent以及escape的区别
date: 2015-08-03 19:58:58
tags: [javascript,encode]
categories: 技术人生
---
####背景
今天平台在向调用的平台发送回调请求的时候，发现有问题，排查了一会儿发现并不是所有的回调请求都会有问题。基本上纯字母或数字的回调都没有问题，而出问题的请求包含"&","-"等特殊字符，于是第一时间想到是不是解析特殊字符的问题。

于是跟接收方约定，我将请求encode后发送，接收方接收后decode后再解析。

####TEST1
代码片段：
```
var resParams = {"name":encodeURI(out.name),"blockId":blockId,"total":1,"detail":encodeURI(reportPath)};
```
发布后，重新触发，查看日志：

```
..."detail":"http://(绿色围墙)/detail?id=1&suffix=1438601805325"...}
```
怎么貌似请求串没有改变？

第一反应，怀疑是不是编码没有成功，但我之前一直都是使用`encodeURI`编码，并不会别的什么方法，于是百度了下，发现还有个`encodeURIComponent以及escape的区别`方法。

####TEST2
```
var resParams = {"name":encodeURIComponent(out.name),"blockId":blockId,"total":1,"detail":encodeURIComponent(reportPath)};
```
发布后，重新触发，查看日志：
```
..."detail":"http://(绿色围墙)/detail%3Fid%3D1%26suffix%3D1438601805325"...}
```
起效了~

####总结
> javascript中有三种编码的函数，分别是：*`escape()`*,*`encodeURI()`*以及*`encodeURIComponent()`*。

1. escape
该方法不对ASCII字母和数字编码，也不会对ASCII标点符号编码，除此之外的所有字符均会被编码。
基本上该方法已经被javascript标准所遗弃，从ECMAScript v3开始，标准就建议使用encodeURI和encodeURIComponent代替。

2. encodeURI
该方法不会对字母和数字编码，也不会对这些ASCII标点符号编码：** -_.!~*'() **
该方法的目的是对URI进行完整的编码，对URI中具有特殊含义的标点符号不进行转义。
因此正如我遇到的问题一样，如果URI中含有分隔符，则应当使用`encodeURIComponent`方法编码。

3. encodeURIComponent
该方法不会对字母和数字编码，也不会对这些ASCII标点符号编码：** -_.!~*'() **
其他字符，如** ;/?:@&=+$,# **这些用于分隔 URI 组件的标点符号，都会由十六进制转义替换。
encodeURIComponent除了编码标准的URI之外，对于它的参数也都一并进行处理。

他们对应的解码函数分别是：
*`unescape()`*,*`decodeURI()`*,*`decodeURIComponent()`*
