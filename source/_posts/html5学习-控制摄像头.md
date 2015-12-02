title: html5学习--控制摄像头
date: 2015-08-20 10:10:29
tags: html5 摄像头
categories: 技术人生
---
最近对html5萌生了兴趣，起初是因为在学习全栈时见识到了html5的强大威力。如下面这个例子：
```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
</head>
<body>
    <input type="date">
</body>
</html>
```
仅仅一个"date"类型的input框就解决了html插入日期控件的工作，而且造型还挺风骚。
![](http://ww4.sinaimg.cn/large/62d95157gw1ev8v865h61j207t06v3ys.jpg)
<!--more-->

考虑到html5还可以直接操纵硬件，诸如摄像头、麦克风之类，立马让人玩心大增。
下面是我学习使用html5控制摄像头的一段demo，我的一些学习实验性的代码会放在这里：[**戳**](https://github.com/zhangjh/practice)。
参考的文章是：
1. [w3cschool html5教程](http://www.w3school.com.cn/html5/index.asp)
2. [Eric Bidelman的html5视频音频操作的博文](http://www.html5rocks.com/zh/tutorials/getusermedia/intro/)

Lets Go！

首先先添加几个控件：
```
<video id="video" autoplay>
</video>
<button id="snap">拍摄</button>
<canvas id="canvas" style="border:2px solid #000099" width="640" height="480">
    no canvas availabel
</canvas>
```
video用来流式的显示摄像头的实时图像，canvas用来显示截图。
Ok了，html5的布局就这么几句话。关键的javascript语句用来获取操作摄像头权限，获取实时图像，截图并绘图等操作。
关键的媒体捕获的语句为：getUserMedia(),不过"前端第二定理"告诉我们：任何好用的东西都不会全部兼容。。，同样的，不同浏览器对这个的实现也不一样，IE内核的浏览器下是getUserMedia，webkit内核的浏览器下是webkitGetUser，firefox下是mozGetUserMedia。因此要为不同的浏览器做适配：调用不同的接口来操作。

```
if(navigator.getUserMedia){
    navigator.getUserMedia(videoObj,function(stream){
        video.src = stream;
        video.play();
    },errcb);
}else if(navigator.webkitGetUserMedia){
    navigator.webkitGetUserMedia(videoObj,function(stream){
        video.src = window.webkitURL.createObjectURL(stream);
        video.play();
    },errcb);
}else if(navigator.mozGetUserMedia){
    navigator.mozGetUserMedia(videoObj,function(stream){
        video.src = window.URL.createObjectURL(stream);
        video.play();
    },errcb);
}
```
getUserMedia函数接收的第一个参数是个多媒体设备对象，这篇文章里是视频设备，写作`{"video":true}`，第二个参数是获取设备成功时的回调函数，第三个参数是获取失败时的回调函数。

值得说明的是，绑定video的数据流的方法也是多浏览器特性的。看代码即可。

至此，应该已经可以通过获取摄像头获得实时的图像展示到video控件里了。

如果需要截图还需要利用到html5的canvas绘图功能。

```
var canvas = document.getElementById("canvas"),
    context = canvas.getContext("2d");
document.getElementById("snap").addEventListener("click",function(){
    context.drawImage(video,0,0,640,480);
})
```
首先通过getContext方法返回一个用户在画布上绘图的环境，参数指明了要在画布上绘图的类型，当前的唯一合法值是`"2d"`；然后调用drawImage绘图，第一个参数规定要使用的图像或视频，这里使用的是视频，第二、三个参数指明剪切的x，y坐标，第四、五个参数指明被剪切图像的宽度和高度。是不是很简单？

将代码组合起来即可运行了~值得注意的是：
1. 如果是本机调试将会发现调用摄像头无效，不会弹出控制摄像头的权限申请
2. 如果跟我一样使用hexo部署调试的页面也不会出现权限申请
具体的原因我还没弄清楚，目前只有在服务器上部署才可以，firefox、chrome下调试成功。

[可戳此处运行demo](/capture_demo.html)

