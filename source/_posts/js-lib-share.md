title: 分享我收藏的小而美JS库[一] -- notie
show: true
date: 2018-05-27 20:11:24
tags: [JS库]
categories: 技术人生
---
<i class="iconfont" style="color: #1296db">&#xe65d;</i>  14/53，每周一篇博，坚持！

每周一篇博文的目标还是比较艰巨的，有时候时间比较紧张的时候根本来不及想主题。。<img class="emoji" src="https://emojipedia-us.s3.amazonaws.com/thumbs/320/apple/129/face-with-tears-of-joy_1f602.png" align="absmiddle">

准备开一个系列，介绍下我收藏的那些小而美的JS开源库。这是第一篇，关于一个设计良好的美观实用PC、移动兼容良好的弹框库--[notie](https://github.com/jaredreich/notie)。

#### 关于notie
众所周知，浏览器默认的弹框--alert是异常丑陋的，我们在业务中通常是不会直接使用alert来显示应用弹框消息的，一般都会重新设计应用自己的弹框来替代之。
notie就是一款用来替代alert的消息弹框库。

<!--more-->

它的几项主要功能：
1. alert的功能：提醒用户
2. 弹出选项让用户确认
3. 允许用户输入信息
4. 允许用户选择选项
5. 允许用户选择日期

放一张官网的demo图看一下notie的效果，还是非常优雅的：
 ![](https://github.com/jaredreich/notie/blob/master/demo.gif?raw=true)
 
#### 使用方式
既然是小而美的库，使用起来也是相当方便的：
1. 安装
    在HTML内加载notie文件，并加载notie的样式文件
    ```html
    <head>
      ...
      <link rel="stylesheet" type="text/css" href="https://unpkg.com/notie/dist/notie.min.css">
      <style>
        /* override styles here */
        .notie-container {
          box-shadow: none;
        }
      </style>
    </head>
    <body>
      ...
      <!-- Bottom of body -->
      <script src="https://unpkg.com/notie"></script>
    </body>
    ```

2. 业务调用 
    在业务js中调用notie API：
    ```js
    notie.alert({
      type: Number|String, // optional, default = 4, enum: [1, 2, 3, 4, 5, 'success', 'warning', 'error', 'info', 'neutral']
      text: String,
      stay: Boolean, // optional, default = false
      time: Number, // optional, default = 3, minimum = 1,
      position: String // optional, default = 'top', enum: ['top', 'bottom']
    })
    
    notie.force({
      type: Number|String, // optional, default = 5, enum: [1, 2, 3, 4, 5, 'success', 'warning', 'error', 'info', 'neutral']
      text: String,
      buttonText: String, // optional, default = 'OK'
      position: String, // optional, default = 'top', enum: ['top', 'bottom']
      callback: Function // optional
    }, callbackOptional())
    
    notie.confirm({
      text: String,
      submitText: String, // optional, default = 'Yes'
      cancelText: String, // optional, default = 'Cancel'
      position: String, // optional, default = 'top', enum: ['top', 'bottom']
      submitCallback: Function, // optional
      cancelCallback: Function // optional
    }, submitCallbackOptional(), cancelCallbackOptional())
    
    notie.input({
      text: String,
      submitText: String, // optional, default = 'Submit'
      cancelText: String, // optional, default = 'Cancel'
      position: String, // optional, default = 'top', enum: ['top', 'bottom']
      submitCallback: Function(value), // optional
      cancelCallback: Function(value), // optional
      autocapitalize: 'words', // default: 'none'
      autocomplete: 'on', // default: 'off'
      autocorrect: 'off', // default: 'off'
      autofocus: 'true', // default: 'true'
      inputmode: 'latin', // default: 'verbatim'
      max: '10000',// default: ''
      maxlength: '10', // default: ''
      min: '5', // default: ''
      minlength: '1', // default: ''
      placeholder: 'Jane Smith', // default: ''
      spellcheck: 'false', // default: 'default'
      step: '5', // default: 'any'
      type: 'text', // default: 'text'
      allowed: ['an', 's'] // Default: null, 'an' = alphanumeric, 'a' = alpha, 'n' = numeric, 's' = spaces allowed. Can be custom RegExp, ex. allowed: new RegExp('[^0-9]', 'g')
    }, submitCallbackOptional(value), cancelCallbackOptional(value))
    
    notie.select({
      text: String,
      cancelText: String, // optional, default = 'Cancel'
      position: String, // optional, default = 'bottom', enum: ['top', 'bottom']
      choices: [
        {
          type: Number|String, // optional, default = 1
          text: String,
          handler: Function
        }
        ...
      ],
      cancelCallback: Function // optional
    }, cancelCallbackOptional())
    
    notie.date({
      value: Date,
      submitText: String, // optional, default = 'OK'
      cancelText: String, // optional, default = 'Cancel'
      position: String, // optional, default = 'top', enum: ['top', 'bottom']
      submitCallback: Function(date), // optional
      cancelCallback: Function(date) // optional
    }, submitCallbackOptional(date), cancelCallbackOptional(date))
    ```
    最常用的还是alert了。
    如果我们想弹出一个成功的提示消息给用户只需简单调用如下：
    ```js
       notie.alert({
           type: 1,
           text: "Success",
           stay: true
       });
    ```
    使用的时候可以多多尝试，看看哪个效果是自己需要的。
    
3. 在React等前端框架下使用
    在如今前端工程化的背景下，notie同样也支持在如React等前端框架下使用。
    首先要使用npm安装notie：
    ```js
       npm install notie
    ```
    然后引入notie并加载需要使用的notie组件:
    ```js
       // 加载全部
       import notie from 'notie';
       // 加载部分
       import {alert, force, confirm, input, selecct, date, setOptions, hideAlerts} from 'notie';
    ```
    调用API的方式和浏览器使用方式一致。