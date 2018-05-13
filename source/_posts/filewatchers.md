title: 使用IDEA自动编译less文件
show: true
date: 2018-05-13 07:39:45
tags: [filewatchers]
categories: 技术人生
---

<i class="iconfont" style="color: #1296db">&#xe65d;</i>  12/53，每周一篇博，坚持！

### 背景
我的工作性质是属于全栈的，也就是前后端都需要干的那种"全干工程师"。在阿里又会用到很多内部自研的框架，有的框架就不那么的好用。如工作中用到的这个前端框架，写的CSS文件不支持@import语法。。。这意味着，如果你想将不同页面间样式的公共部分抽取出来再@import的方式不可行，你只能不停的重复同样的样式代码，丑陋且不可维护。
好在框架支持less等CSS编译语言，而在less中写@import语句是没问题的。于是想到了一个可行的方式：项目维护less样式文件，抽取公共的部分，在需要的地方@import进来，唯一的问题就是需要将这些less文件编译成浏览器认识的CSS。我可不想每次自己来执行编译。

<!--more-->

### FileWatchers插件
IDEA下的FileWatchers插件可以帮助我实现自动编译的功能。它实际上就是一个文件监视器，当文件有所改动时，自动触发设置好的命令执行。
在说明FileWatchers使用之前，我们先具体的看一下，如何将less编译成可执行的CSS。

### 使用LESSC编译LESS文件
在动手之前，所需的前端依赖环境，如node.js、npm不再赘述。
首先使用npm安装lessc编译器：
```
npm i lessc -d -g
```
安装完之后就可以使用了。
如：
```css
/**1.less*/
@nice-blue: #5B83AD;
div {
    p {
        color: @nice-blue;
    }
}
```
运行命令：
`lessc 1.less > 1.css`
上述命令将生成：
```
div p {
	color: #5B83AD;
}
```
上述简单的例子可以看出，使用less来编写样式，给我们提供了一些CSS没有的功能，如嵌套和变量。这里不再赘述，less的详细使用可以参考[less手册](https://less.bootcss.com/)。

### IDEA下使用FileWatchers编译less文件
1. 安装FileWatchers插件
打开设置找到plugins，搜索FileWatchers并安装

2. 重启IDEA，打开设置搜索FileWatchers，通常是在Tools子菜单下

3. 设置FileWatchers
添加模板，这里我选择less
设置要监控的文件类型及文件变更后的操作如下：
![](http://wx3.sinaimg.cn/mw690/62d95157gy1fr9zdr0697j21ag0x8gs0.jpg)

配置完成后，当我一边写less样式时，FileWatchers将自动调用我的lessc编译器将less文件同步编译生成相应的css文件。

这篇博文只是利用FileWatchers来实现了自动编译less文件，其实它的作用远不止这个。只要是希望监视文件变动后自动触发一些操作的事情都可以交给FileWatchers帮忙实现。如当你想尝试某些ES6或更高版本JS的新功能，而又担心浏览器无法识别或者不想自己手动将文件转为低版本时，你可以借助FileWatchers和bable来实现自动的代码转译。
又或者，你可以利用它来自动压缩混淆代码等等，如果有更好的想法可以评论跟我分享。
