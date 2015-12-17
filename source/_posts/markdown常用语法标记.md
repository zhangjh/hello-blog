title: markdown常用语法标记
date: 2015-06-29 17:47:37
tags: markdown
categories: 技术人生
show: true
---
工欲善其事必先利其器，hexo博客的写作方式采用的是标准的markdown语法。
因此要想写出漂亮的格式，掌握好必要的markdown语法必不可少。
工作中也用到markdown写周报，在此顺便再总结一下markdown常用的语法格式，温故而知新。

<!--more-->

#标题
```plain
# 一级标题
## 二级标题
### 三级标题
......
###### 六级标题
```

#引用
```plain
> 引用的文字
```
eg：
> Talk is cheap，show me the code. -- Linus Torvalds

#链接
```plain
[this is link text](http://xxx)
```
eg:
[百度一下，你就知道](https://www.baidu.com)

#图片
图片跟链接类似，只是[]前面多一个!
```plain
![](http://xxx)
```
eg:
![](https://www.baidu.com/img/bd_logo1.png)

#列表
```plain
- ul1
- ul2
1. li1
2. li2
```
符号和文本之间注意留空
eg：
- 无序列表1
- 无序列表2
1. 有序列表1
2. 有序列表2

#代码&代码块
代码：
```plain
用`包裹语句
```
代码块：
```plain
用```包裹代码块
```
eg:
`console.log("hello world!");`
```js
function test(){
	console.log("hello world");
}
```

#字体
粗体用两个`**`包含
斜体用一个`*`包含
eg:
**粗体**
*斜体*



