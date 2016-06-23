title: 延迟加载原理及实现
show: true
date: 2016-01-28 15:36:13
tags: ["懒加载","延迟加载","jquery","lazyload"]
categories: 技术人生
---
#### 懒加载
"懒加载"或谓"延迟加载"、"按需加载"是一种网页性能优化的技术。在很多场景下被使用，如微博的信息流，百度的图片搜索以及阿里巴巴的底部p4p，右侧p4p等，都是在用户访问到的时候才加载，这样可以避免在加载页面时加载过多资源造成页面渲染时间拉长，影响用户体验。
一直想了解下p4p异步加载的实现方式，没有前端的代码权限，因此只能自己琢磨，本文即是在内部光年平台的开发过程中，探索并应用的一种懒加载方法。总结记录如下。

#### 屏幕高宽相关属性
正式开始前，首先总结一下，跟浏览器以及网页文档高宽相关的几个属性，这几个属性对于后文要说到的懒加载实现方法有重要意义。
1. 网页可见区域宽
`document.body.clientWidth`
2. 网页可见区域高
`document.body.clientHeight`
3. 网页正文全文宽
`document.body.scrollWidth`
4. 网页正文全文高
`document.body.scrollHeight`
5. 网页被滚动的高
`document.body.scrollTop`
6. 网页被滚动的左
`document.body.scrollLeft`
5. 屏幕分辨率宽
`window.screen.height`
6. 屏幕分辨率高
`window.screen.width`
7. 网页元素绝对位置
屏幕的坐标系原点位于屏幕左上角，所以一个元素的绝对位置指的是相对于屏幕左上角的坐标值。该值需要通过计算才能得到。
每个元素都有offsetLeft和offsetTop属性，表示该元素的左上角相对父元素左上角的距离。因此只要将元素自身的offsetLeft，offsetTop和其父元素的值相加，即可得到该元素的绝对坐标。
参见下图：
![](http://ww2.sinaimg.cn/mw690/62d95157gw1f0jtsa67o9g20dw0aewec.gif)
有一些属性在懒加载实现方法中并未用到，考虑到比较常用，一并整理在此以作备忘。

<!--more-->

#### 懒加载原理
朴素的想法来看，要想实现懒加载，那么只要将非首屏内容异步加载，在用户访问到的时候再发出请求即可。当某个模块容器到达了网页可见区域时，使用ajax异步请求将请求内容渲染出来即可。于是问题转换为模块容器何时到达可见区域。

模块容器与网页可见区域相互交叠时，模块容器即到达了可见区。此时触发请求。

#### 判断模块是否到达可视区
根据上述分析，问题进一步转换为判断两个长方形何时发生"碰撞"。
两个长方形发生"碰撞"的两种临界情形如下图所示：
![](http://ww4.sinaimg.cn/mw690/62d95157gw1f13h0mc6nrj20em0hq3z4.jpg)
我们先来看下第一种情形。
在此临界情形下，分别取两个长方形的中线，两根中线的距离差应该刚好等于两个长方形宽度和的一半。
即有如下公式成立：
```
m1 = left1 + width1/2
m2 = left2 + width2/2
|m1 - m2| = (width1 + width2) / 2
```
当`|m1 - m2| < (width1 + width2) / 2`时，两个长方形发生了"碰撞"。

同理，如果在高度方向上发生碰撞，则有：
```
m1 = top1 + height1 / 2
m2 = top2 + height2 / 2
|m1 - m2| < (height1 + height2) / 2
```

#### 获取元素绝对位置
根据上述分析，将元素与其父元素左上角的偏离坐标和其父元素离坐标原点的偏离位置累加即可。
```
function getDstResource(p){
    var l = 0,t = 0,w,h;
    w = p.offsetWidth;
    h = p.offsetHeight;
    while (p.offsetParent){
        l += p.offsetLeft;
        t += p.offsetTop;
        p = p.offsetParent;
    }
    return {'left':l,'top':t,'width':w,'height':h};
}
```

#### 完整示例
```
//获取可视区
function getVisiableZone(){
    var l,t,w,h;
    l = document.documentElement.scrollLeft || document.body.scrollLeft;
    t = document.documentElement.scrollTop || document.body.scrollTop;
    w = document.documentElement.clientWidth;
    h = document.documentElement.clientHeight;
    return {'left':l,'top':t,'width':w,'height':h};
}

//获取元素绝对位置
function getDstResource(p){
    var l = 0,t = 0,w,h;
    w = p.offsetWidth;
    h = p.offsetHeight;
    while (p.offsetParent){
        l += p.offsetLeft;
        t += p.offsetTop;
        p = p.offsetParent;
    }
    return {'left':l,'top':t,'width':w,'height':h};
}

//判断两个长方形是否交叠
function overlap(rect1,rect2){
    var l1,l2,t1,t2,w,h;
    l1 = rect1.left + rect1.width / 2;
    l2 = rect2.left + rect2.width / 2;
    t1 = rect1.top + rect1.height / 2;
    t2 = rect2.top + rect2.height / 2;
    w = (rect1.width + rect2.width) / 2;
    h = (rect1.height + rect2.height) / 2;
    return Math.abs(l1 - l2) < w && Math.abs(t1 - t2) < h;
}

//异步加载
if(overlap(getVisiableZone(),getDstResource(document.getElementById("xxx")))){
	$.ajax();
	......
}
```

