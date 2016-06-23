title: js区分访问设备
show: true
date: 2015-12-10 10:55:32
tags: [js,javascript,区分访问设备,获取访问设备]
categories: 技术人生
---
{% cq %} 需求是王道，有需求才有折腾的动力。  {% endcq %}

昨天在写结婚照分享的页面时，布局采用了一行三章的方式，于是每张照片的宽度定义为33%。

PC下访问一切ok，但是换用手机端访问后发现有问题，三张照片有两张在一行上，另一张就掉到下一行去了。看起来很怪异。
于是想给PC访问和移动端访问做一个自适应设计。移动端屏幕下，一行就显示一张就可以了。

#### 判断方法
判断访问终端是手机还是PC，大体上有以下几种方法：
1. 终端平台
2. 操作系统
3. 浏览器内核
4. userAgent
......

<!--more-->

这几种方法都需要利用到js的navigator对象来获取相应的信息，具体的navigator知识可以参考：[w3school Navigator对象](http://www.w3school.com.cn/jsref/dom_obj_navigator.asp)
navigator都有哪些可以使用的属性可以在浏览器的终端里查看下。![](http://ww1.sinaimg.cn/mw690/62d95157gw1eyue0nqiegj209n07kaab.jpg)
经我实验，appName，platform，appVersion，useragent等可以获得当前设备信息。
![](http://ww2.sinaimg.cn/mw690/62d95157gw1eyue4s75yjj20oz05gjrx.jpg)
但有些信息准确度上就不好说了。appName和platform的误差可能会有，上图中我的64bit Chrome，appName和platform分别是"Netscape"、"Win32"。

#### 代码实例
采用userAgent获取设备信息判断终端类型
```js
	function isPc(){
		var userAgentInfo = navigator.userAgent;
		//可识别的移动终端，支持以下
		var agents = ["Android", "iPhone", "SymbianOS", "Windows Phone", "iPad", "iPod"];
		var flag = true;
		for(var i=0,len=agents.length;i<len;i++){
			if(userAgentInfo.indexOf(agents[i]) != -1){
				flag = false;
				break;
			}
		}
		return flag;
	}
```

获取到了设备信息后，在判断出是移动端访问后，将宽度33%的设置去除，恢复100%，于是移动端的访问体验也恢复了。
