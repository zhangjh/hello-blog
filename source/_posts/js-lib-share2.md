title: 分享我收藏的小而美JS库[二] -- KeyPress
show: true
date: 2018-06-18 21:11:24
tags: [JS库]
categories: 技术人生
---
<i class="iconfont" style="color: #1296db">&#xe65d;</i>  17/53，每周一篇博，坚持！

这一篇博文是小而美的库分享第二篇，准备分享一个JS键盘事件捕获的库，名字就叫做[KeyPress](http://dmauro.github.io/Keypress/)。

#### 关于KeyPress
我们在web开发过程中，为了给用户带来良好的用户体验，通常就不仅仅需要响应用户的鼠标操作，更多的是需要响应用户的键盘操作。通常这时候我们总是需要各种搜索查询键盘上各个按键对应的键码。
这是一个很繁琐而又没什么技术含量的事。而"KeyPress"这个库基本上就让我们摆脱了查询键码的繁琐过程，托管了我们对键盘映射的响应。
"非常容易使用，大小合理(9kb)，没有任何依赖，健壮性良好的键盘输入捕获JS库"，这是KeyPress的自我评价。
<!--more-->

它能提供的功能特性包括：
1. 触发按键按下或释放
2. 任意的按键都可以作为触发按键
3. 特别地连击计算
4. 按键序列的组合
5. 其他的一些特性

什么意思？我们上例子看下

#### 使用方式
1. 首先需要下载它的库文件：[ZIP](https://github.com/dmauro/Keypress/zipball/master)
2. 在前端页面中引用该JS库文件
3. 初始化一个事件监听器
  ```js
  var listener = new window.keypress.Listener();
  ```
4. 接下来就可以注册相应按键的事件监听了，我们看几个例子，妙就妙在这里
  4.1 简单按键组合
    ```js
    listener.simple_combo("shift s",function(){
      console.log("You pressed shift and s");
    });
    ```
    simple_combo是库函数的API，第一个参数表示监听的是shift键和s键的按下，你可以写一系列的键，以空格分隔，这样是不是就脱离了查询键码组合了，直接识别键名称！
    第二个参数是回调函数，就不多解释了。

  4.2 计数
    ```js
   listener.counting_combo("tab space",function(e,count){
      console.log("You've pressed this " + count + "times.");
   });
    ```
    这段代码调用counting_combo API创建了一个计数器，可以统计tab space键按下的总次数。

  4.3 按键序列
  大家都玩过魂斗罗吧？我们都知道魂斗罗里面有个按键组合，如果正确按下了就会触发30条命。这种功能就可以使用按键序列事件来监听。
  ```js
  listener.sequence_combo("up up down down left right left right b a enter", function() {
    lives = 30;
  }, true);
  ```

 如上的一些已经完全够我们在web开发过程中自由发挥了，毕竟我们在开发过程中大部分都是用来监听用户的按键组合。

 KeyPress还有一些高级用法，这里仅举几个例子说明用法，虽然实际中可能不会存在这样的场景：
 register_combo：使用该API注册一系列事件动作。
 ```js
 listener.register_combo({
    // 按键组合，空格分隔或者字符数组
    "keys"              : null,
    // 按键按下时的回调函数（都针对keys设置的按键组合）
    "on_keydown"        : null,
    // 按键释放时的回调函数
    "on_keyup"          : null,
    // 等价于回调函数设置event.preventDefault()，而且如果是组合按键的话，针对每个按键都event.preventDefault()了
    "prevent_default"   : false,
    ... ...
  });
 ```

 这个库最方便的地方便在于不用记忆键码也可以写事件监听，并且支持任意的按键组合，让我们可以专心写事件回调逻辑，按键事件监听的事都交给库来解决。这会很大程度上提高我们编码的效率。

 更详细的用法大家可以查看官方文档。
