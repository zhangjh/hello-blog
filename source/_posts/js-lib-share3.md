title: 分享我收藏的小而美JS库[三] -- Vivid.js
show: true
date: 2018-07-01 19:00:00
tags: [JS库]
categories: 技术人生
---
<i class="iconfont" style="color: #1296db">&#xe65d;</i>  18/53，每周一篇博，坚持！

今天七月一号了，不知不觉2018年又已经过去了一半了，工作后压力大感觉时间都过的快了些。想来也是，上了年纪了，现在的一年占你所剩人生的比例越来越重了，不由得让人对时间的流逝关注起来。大家都加油，与诸君共勉。

这一篇博文是小而美的库分享第三篇，准备分享一个SVG图标的库，名字叫做[Vivid.js](https://webkul.github.io/vivid/)。

#### 关于Vivid.js
现如今，我们在web开发过程中，需要用到图标的时候已经很少直接插入一张图片了，更多的时候使用的都是SVG、iconfont形式的图标了。这种图标的好处就是可以自定义大小、颜色等样式。
这其中，国内有阿里开源的[阿里巴巴矢量图标库](http://iconfont.cn/home/index)，也有[bootstrap](https://v3.bootcss.com/)之类好用的图标库。
Vivid.js也是一款优秀的矢量图标库，可以作为备选之一。

<!--more-->

它有近百个自带的图标，自定义样式方式也非常方便，可以直接在元素上定义属性，使用起来也是相当轻量。

#### 使用方式
1. 首先在前端页面中依赖Vivid.js的库文件
    `<script src="https://cdn.jsdelivr.net/npm/vivid-icons" type="text/javascript"></script>`
2. 找到所需使用图标的名字，如'doc'
3. 加载图标
    `<i data-vi="doc"></i>`
  就会在页面中渲染一个书页的图标了。
  
4. 自定义图标样式
  有时候原生的样式并不能满足我们的需求，如何进行一些样式的自定义呢？
  
  4.1 自定义大小
  自定义图标的大小，只需要在图标上增加属性：`data-vi-size="number"`,number为要指定的像素大小值，如：
  `<i data-vi="doc" data-vi-size="96"></i>`
  
  4.2 自定义颜色
  每个Vivid图标由三种颜色构成：primary，accent，prop。每一种颜色构成都可以单独自定义。
  这就有点像画家可以通过自己调节红黄蓝三原色的组成形成新颜色似的。
  组合的方式为：
      ```html
        data-vi-primary="#hexcode"
        data-vi-accent="#hexcode"
        data-vi-prop="#hexcode"
      ```
  在元素上修改相应属性即可。这里我试验过不一定非要16进制的颜色代码，跟我们写css时一样，颜色代码如"red","green"等也是可以的。
  有点让人费解的就是，primary、accent、prop等控制的是图标的哪个部分，这个文档没有详细说明，primary和accent倒还是好"望文生义"，就是这个"prop"颜色成分是控制哪儿的不太能搞清，只能自己用的时候试下了。
  
5. 默认样式的自定义
  如果嫌每次重新定义图标的样式都要增加属性的方式比较麻烦，可以直接修改图标库文件。这个也是比较简单的。
  
  5.1 安装必备环境
    5.1.1 安装node，不再赘述
    5.1.2 安装npm-run-all
      `npm i npm-run-all --save-dev`
      一定要安装该库，官方文档里没有提到，不安装运行`npm run build`时必报错："sh: run-s: command not found"
    5.1.3 安装webpack-cli
      `npm i webpack-cli -g`
      全局安装webpack-cli，编译的时候需要用到，否则会报："It needs to be installed alongside webpack to use the CLI"
  5.2 下载图标库源码
    `npm install vivid-icons`
    安装前需要保证当前目录下存在package.json文件，所以先运行：
    `npm init`
    一路回车即可
  5.2 进入图标库目录并安装依赖
    `cd node_modules/vivid-icons && npm install`
  5.3 修改配置
    `cd src && vi config.js`
    配置文件的内容：
    ```
        export let iconConfig = { 
            size: "48", 
            primaryColor: "#FF6E6E", 
            accentColor: "#0C0058", 
            propColor: "#FFFFFF" 
         } 
    ```
    修改对应的属性值
  5.4 编译
    `npm run build`
  5.5 使用编译的源码库
    编译完成后项目会生成新的图标库资源，路径在"dist/vivid-icons.min.js"
    
6. 增加图标
  有时候官方的图标不够用，自己想要增加图标该如何做呢？
  继续上述第五步的操作，可以任意增删改icons目录下的图标文件，需要注意的是SVG图标文件的每个SVG元素都必须包含"vi-primary","vi-accent"类，以至于才可以在"src/config.js"里自定义颜色。
  如增加一个"chat"图标:
  ```html
     <svg id="chat" xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 48 48">
         <defs>
             <style>
             .vi-primary {
                 fill: #ffb400;
             }
     
             .vi-accent {
                 fill: #070c2b;
             }
             </style>
         </defs>
         <path class="vi-primary" d="M24,39.765A18.556,18.556,0,0,1,13.924,37.1L7,44V23.882l0.012,0.006C7.011,23.791,7,23.7,7,23.6,7,14.369,13.247,8,24,8s17,6.652,17,15.882S34.753,39.765,24,39.765Z"/>   
         <path class="vi-accent" d="M31.994,20.99a3,3,0,1,1-3,3A3,3,0,0,1,31.994,20.99ZM24,21a3,3,0,1,1-3,3A3,3,0,0,1,24,21Zm-8,0a3,3,0,1,1-3,3A3,3,0,0,1,16,21Z"/>   
      </svg>
  ```
  运行：`npm run build`，引入"dist/vivid-icons.min.js"文件后就可以使用新加的图标了。
    
