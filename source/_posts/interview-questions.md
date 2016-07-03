title: 两道面试题
show: true
date: 2016-07-03 11:41:08
tags: [面试,js]
categories: 技术人生
---
#### 背景

周末去面试练了下手，感觉发挥的不太好。主要是在技术考核阶段代码写的不好，说实话挺反感这种当场让面试者在白板上写代码的方式来考核，我举个例子应该你就明白了。我们每个人小时候应该都有过这种经历，考试的时候监考老师停在你身边看着你的时候，简直是无从下笔...面试也是一样的道理，你站在白板前，面试官在你身后盯着你，在那种应激的状态下很难思考充分，有时候简直是无从思考，所以如果下次再考我写代码的话，请允许我用自己的电脑吧，起码我还可以有试错和调试的机会。

面试的不好当然挺沮丧的，有点伤自信，我事后简单想了一下就写出来了，所以就更加觉得这种面试方式面不出来水平了，sigh...这里简单的记录一下，吸取个教训。

##### 问题一

> 使用Promise描述如下过程：绿灯亮3秒，然后红灯亮3秒，然后黄灯再亮3秒。灯亮过程可以用console表示。

当时写的不好，纠结在是封装个sleep函数还是用setTimeout，然后定义了三个Promise对象分别表示红、绿、黄灯亮的过程，自己感觉也挺不好的，所以有点畏首畏尾写不下去。回来在自己机器上几分钟就写出来了，还没有重复定义，内心真是。。那个悔啊，被别人看扁了，其实哥真不是不会啊。

```js
	function sleep(delay){
		var now = new Date().getTime();
		while(new Date().getTime() - now < delay){
		}
	}

	function led(color){
		console.log(color);
		sleep(3000);
		return new Promise(function(resolve,reject){
			resolve();
		});
	}

	led("green").then(function(){
		led("red");
	}).then(function(){
		led("yellow");
	});
```

###### 问题二

> 自己实现一个sort2，尽可能地模拟js原有的sort函数

这个我确实不会写，js原有的sort函数还可以接收函数参数的。不过让我写个排序的函数还是没问题的。

```js
function sort2(arr,option){
	for(var i=0,len=arr.length;i<len-1;i++){
		for(var j=i+1;j<len;j++){
			if(option && option == 1){
				//1为降序，默认或者0为升序
				if(arr[j] > arr[i]){
					var tmp = arr[j];
					arr[j] = arr[i];
					arr[i] = tmp;
				}
			}else {
				if(arr[j] < arr[i]){
					var tmp = arr[j];
					arr[j] = arr[i];
					arr[i] = tmp;
				}
			}
		}
	}
return arr;
}

//var arr = [9,4,6,2,1,3,5,8,7,0];
var arr = ['c','b','e','a'];

console.log(sort2(arr));

```
该函数支持正序，逆序，数字，字母排序。

现在还没有结果，如果因为这两道题挂了，你说我多么冤。我是带着作品去面试的，以为不会再让我当场写代码也没怎么准备，没想到人家也许都没怎么看过我的网站，反正没问到。考虑到当前面试白板编程还是普遍存在的，各位准备面试的，有机会还是多多练习下白板编程以及如何把面试官当做不存在提高应激情形下的编程能力吧。
