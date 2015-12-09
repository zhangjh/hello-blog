title: javascript中for..in循环获取对象属性顺序问题的探讨
date: 2015-07-13 13:58:37
tags: [javascript,for..in] 
categories: 技术人生
---
#背景
在项目开发过程中，有一个需求是这样的：
> 平台接受用户输入的一串JSON字符，然后解析JSON串的key-value展示到平台上，并支持用户修改value值再更新。

效果图如下：
![](http://ww3.sinaimg.cn/large/62d95157gw1eu1746ujtwj20km064gml.jpg)
在调试过程中发现，一旦提交更新展示的字段顺序就跟前一次不一样，再提交一次更新貌似又能恢复，这是咋回事呢？

<!--more-->

#原因
JSON对象本身是集合，而集合是无序的，因此for...in遍历对象属性时也是无序的，或者说是不可预期的。

#替代方式
正如我的需求一样，就是对对象的顺序有依赖，否则在更新value时就会出现key与value对应不上的问题。
因此只能将key事先遍历出来进行排序，后面在有需要用到key时不再用for...in遍历，而是直接使用预先遍历出来的key数组。

```
var keyArr = new Array();
for(var item in params){
	keyArr.push(item);
}
keyArr = keyArr.sort();
...
for(var i=0;i<keyArr.length;i++){
	params[keyArr]...
}
```

