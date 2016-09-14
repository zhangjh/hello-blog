title: 手写组件化轮播
show: true
date: 2016-09-14 11:41:12
tags: [轮播,js,组件化]
categories: 技术人生
photos: 
- https://camo.githubusercontent.com/603242775b598fb96d1b9da9c5a9e54d8fd686c7/687474703a2f2f7777312e73696e61696d672e636e2f6d773639302f3632643935313537677731663773787a6c32326a7a6a32306a32306171676d372e6a7067
---
## 背景
轮播效果在web开发中使用很频繁，之前一直是使用网上找来的插件，今天研究了一下自己实现了一下，没多大难度，还是很简单的，顺便再组件化了一把，以后再有需要就使用自己的了不用再用第三方插件了。知其然知其所以然，本篇博文对此做一分享。

## 实现原理
让我们先来看一下轮播的实现原理。
轮播其实很类似于我们小时候玩的抽卡片的小玩意儿：底下一层是绘制好的图案，上面一层开了一个窗口，通过转动上层的窗口来展示底层不同的图案。
轮播也是这样，我们可以理解为：底层排列好了要轮播的图片，上层的窗口每次只展示一个图片，每点击一次窗口就滑动一次。

<!-- more -->

## 需求
我们来写一个轮播插件，需要满足以下几个功能：
1. 支持左右翻页
2. 图片上显示小圆点，点击小圆点也可以翻页
3. 翻页后点亮相应的小圆点
4. 自动翻页
5. 鼠标hover到图片上后自动翻页停止，移开后恢复自动翻页

## 实现
以下讲解主要部分，完整代码见：[**组件化轮播**](https://github.com/zhangjh/practice/blob/master/轮播)
#### HTML容器

```
<div class="container">
	<ul id="c1">
		<li index=1><img src="" alt=""></li>
		<li index=2><img src="" alt=""></li>
		... ...
	</ul>
	<a class="pre arrow"><</a>
	<a class="next arrow">></a>
	<div id="nav">
		<span class="on" index=1></span>
		<span index=2></span>
		... ...
	</div>
</div>
```
没什么好说的，样式里需要将图片显示在一行，整个容器的宽度定义为单张图片的宽度*图片张数即可。
```
li {
	display: inline-block;
	float:left;
}
.container {
	position: relative;
	width: xx;  		/*跟单张图片同宽高*/
	height: xx;
	overflow: hidden;   /*溢出部分隐藏*/
}
```

#### js逻辑

1. 左右翻页
  点击一次next，窗口向右滑动一次，由于窗口固定，等同于底层向左滑动一次，于是我们可以得到：
点击next时，包裹图片的容器left偏移量需要减去一个图片宽度，反之点击prev时，包裹图片的容器left偏移量要加上一个图片宽度。
代码实现如下：
```
var $next = $(".next");
var $pre = $(".pre");
var $ul = $("ul");	
var imgW = $("img").width();
$next.on("click",function(){
	var curLeft = $ul.offset().left;
	var left = curLeft - imgW;
	$ul.animate({
		left: left
	},1000);
});

$pre.on("click",function(){
	var curLeft = $ul.offset().left;
	var left = curLeft + imgW;
	$ul.animate({
		left: left
	},1000);
});
```
  以上代码有个问题，当next翻到最后一张或者prev翻到第一张时，继续翻页就不能正常工作了。因为我们没有设置边界条件。
  当翻到最后一张时，再次点击next，left值需要置回0，表示展示第一张图。
  当翻到第一张时，再次点击prev，left值需置回最后一张图的left偏移。因此我们可以在代码中加上边界设置条件。

	```
	var imgSize = $("img").length;
	...
	//到达最后一张
	if(curLeft === (0 - imgW * (imgSize - 1))){
		left = 0;
	}
	$ul.animate(...);

	//到达第一张
	if(curLeft === 0){
		left = 0 - (imgW * (imgSize - 1));
	}
	```

2. 小圆点翻页
  其实实现了左右翻页后，我们就知道，翻页的功能是类似的，只要计算出点击后对应的left偏移量即可。
  点击任意小圆点后，相应的偏移量为当前第几个位置减去1之后个图片宽度。(第一个位置偏移为0)
```
var $span = $("span");
$span.on("click",function(){
	var curLeft = $ul.offset().left;
	var left = 0 - ($(this).attr("index") - 1) * imgW;
	$ul.animate(...);
});
```

3. 翻页后点亮对应的小圆点
  这个功能很简单，给当前图片对应的小圆点位置设置一个样式即可。我们要做的即是翻页后将对应的小圆点置为有效状态。
  如何判断当前哪个小圆点应该置为有效呢？可以通过偏移量来判断。通过之前的分析我们可以看出，偏移量跟位置很有关系，当知道了偏移量后当前是第一张图片也顺应得知了。
	```
	var index = Math.abs(curLeft) / imgW + 1;
	$span.find(".on").removeAttr("class");
	$span.find("span:nth-child(" + index + ")").attr("class","on");
	```

4. 自动翻页
  在实现了左右翻页功能后，自动翻页功能也很好实现了。其就是相当于设置了一个定时器，然后自动点击next按钮。于是代码实现如下：
	```
	setInterval(function(){
		$next.click();
	},3000);
	```

5. hover停止滚动
  当鼠标hover到图片上后，我们需要停止自动滚动。这意味着我们将定时器清除掉即可，为此我们需要给上一步的定时器一个名字，如timer。鼠标移开之后再次恢复自动点击即可。
  
	```
	$img.hover(function(){
		clearInterval(timer);
	},function(){
		//恢复
		$next.click();
	});
	```

至此，我们主要的功能都已经实现了。但明显地存在几个问题：
- 重复代码多
- 代码不好复用
- 扩展性不够，如果有多个轮播，改造成本大

如果只是一次性的用用是没问题的，但若是想以后重用，减少改造成本的话就需要继续改造下了。我们来看下如何将其改造成组件化的版本。

## 组件化

首先我们将公共的部分抽取出来，如滑动的操作、自动滚动的操作，然后将各个步骤封装，如展示后一张、展示前一张、点亮小圆点等，在文件最后我们将接口导出供外部引入使用。
在前述代码的基础上，我们直接看下组件化版本的代码实现：

```
var Carousel = {
	//传入容器
	init: function($carousel){
		this.$carousel = $carousel;
		console.log(this.$carousel);
		this.$pre = $carousel.siblings(".pre");
		this.$next = $carousel.siblings(".next");
		this.$nav = $carousel.siblings("#nav");
		this.$span = this.$nav.find("span");
		this.$img = $carousel.find("img");
		this.imgWidth = $carousel.find("img").width();
		this.imgSize = $carousel.find("img").length;
		//设置容器宽度
		this.$carousel.css("width",this.imgWidth * this.imgSize);
		//设置滚动点居中
		this.$nav.css("left",this.imgWidth / 2);
		this.$nav.css("marginLeft",0 - this.$nav.width() / 2);

		this.bind();
		this.autoSlider();
	},
	bind: function(){
		//hover停止滚动
		var that = this;
		this.$img.hover(function(){
			clearInterval(that.timer);
		},function(){
			that.autoSlider();
		});
		this.$pre.on("click",function(){
			that.showPre(that.$pre);
		});
		this.$next.on("click",function(){
			that.showNext(that.$next);
		});
		this.$span.on("click", function (e) {
			that.showAnyOne($(e.target));
		});
	},
	showPre: function($ele){
		var that = this;
		//防止多次点击
		var curLeft = this.$carousel.offset().left;
		var left = curLeft + this.imgWidth;

		if($ele === this.$pre){
			//到达头部置0
			if(curLeft === 0){
				left = 0 - (this.imgWidth * (this.imgSize - 1));
			}
		}else {
			left = ($ele.attr("index") - 1) * this.imgWidth;
		}
		this.doSlide(left);
	},
	showNext: function($ele){
		var that = this;
		//防止多次点击
		var curLeft = this.$carousel.offset().left;
		var left = curLeft - this.imgWidth;

		if($ele === this.$next){
			//到达尾部置0
			if(curLeft === (0 - this.imgWidth * (this.imgSize - 1))){
				left = 0;
			}
		}else {
			left = ($ele.attr("index") - 1) * this.imgWidth;
		}
		this.doSlide(left);
	},
	showAnyOne: function ($ele) {
		var curLeft = this.$carousel.offset().left;
		var left = 0 - ($ele.attr("index") - 1) * this.imgWidth;
		this.doSlide(left);
	},
	autoSlider: function(){
		var that = this;
		this.timer = setInterval(function(){
			that.$next.click();
		},3000)
	},
	setActive: function(left){
		var index = Math.abs(left) / this.imgWidth + 1;
		this.$nav.find(".on").removeAttr("class");
		this.$nav.find("span:nth-child(" + index + ")").attr("class","on");
	},
	doSlide: function (left) {
		var that = this;
		if(!window.processing){
			window.processing = true;
			this.setActive(left);
			this.$carousel.animate({
				left: left
			},1000,function(){
				window.processing = false;
			});
		}
	}
};

var exports = function ($container) {
	 return Carousel.init($container);
}

window.exports = exports;

//Usage:
//Carousel.init($("#c1"));
```
