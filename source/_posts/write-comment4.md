title: 从零开始，教你写留言板（四）
show: true
date: 2018-05-06 23:04:46
tags: [留言板,评论]
categories: 技术人生
---

<i class="iconfont" style="color: #1296db">&#xe65d;</i>  11/52，每周一篇博，坚持！

[续上篇](http://zhangjh.me/2018/04/30/write-comment3/)

前面几篇把如何搭建一个评论系统的后端描述了一下，这篇就主要讲一下如何把评论系统的前台搭起来。

## 第四部分 前端交互及页面UI的实现

前端不涉及应用，主要就是HTML、CSS、JS。
评论系统的前端部分主要包括：
1. 评论框主体
2. 用户登录
3. 评论提交动作
4. 消息提醒
5. 评论信息的渲染
6. 事件注册响应

主要是以上几个部分，还有一些细节部分。前端部分主要是仿造原来畅言的风格，具体的渲染方式，如HTML容器怎么放置，CSS样式怎么编写等细节，本篇就不再赘述，前端的实现“一千个人眼中有一千个哈姆雷特”，同样的效果可以有完全不同的实现方式。
<!--more-->

#### 评论框主体
评论框主体主要用来收集用户提交的评论信息，这其中需要注意的是，如果用户是回复的某条评论，则原评论的内容需要以引文的方式放置在评论内容之前，因此我们的评论框也要支持HTML格式的文本。

评论框主体为一个textarea，当用户回复某个评论时，先获取评论内容，将内容放置在`<blockquote><pre>`标签中，以形成引文效果。
当然，因为支持html语法了，后面在获取内容插入数据库时注意要防止xss注入安全问题。

#### 用户登录
用户提交评论前判断用户是否登录，如果还未登录则弹出登录框收集用户信息。与畅言等第三方登录系统相比，这里只收集必要的用户信息。
为了提供更好的体验，还可以提供记住用户信息功能，将用户信息以json格式存储在本地localStorage中。

由于只是作为评论信息的用户标识，其实不算一个严格意义上的登录系统，不需要进行用户信息校验。一个人可以以多个用户名来给网站评论。

一旦用户登录，则将登录框按钮替换成用户名称，并将用户信息写入localStorage供以后读取。
```js
// 以json格式存储在本地浏览器存储中的用户信息
email:"njhxzhangjihong@126.com"
name:"但丁"
url:"_2018_04_30_write-comment3_"
website:"//zhangjh.me"
```
后续该用户再次登录，将按照存储的用户信息去读取是否有评论被回复并显示提醒框。

从localStorage中解析用户信息：
```
// 解析用户信息
      const userInfoJson = JSON.parse(userInfo);
      comment.name = userInfoJson.name;
      comment.email = userInfoJson.email;
      comment.website = userInfoJson.website;
      //$(".modal-body input[name='name']").val(userInfoJson.name);
      //$(".modal-body input[name='email']").val(userInfoJson.email);
      //$(".modal-body input[name='website']").val(userInfoJson.website);
      $(".header-user").text(comment.name);
```

#### 评论提交
评论提交主要要注意的是一些合法性的校验，如不能提交空内容，不登录不能提交，非法注入字符内容不能提交等。
这里前端的提示消息的弹出我使用了一个第三方库叫[notie](https://github.com/jaredreich/notie).
效果非常优雅，比自带的alert不知道高到哪里去了。
![Alt text](https://raw.githubusercontent.com/jaredreich/notie/master/demo.gif?raw=true "Demo")

#### 评论信息的渲染
获取到评论信息后首先拿到总的条数，然后再循环每条消息渲染成评论列表。
这其中，每条评论信息还要处理评论者用户名的渲染，如果评论者提供了自己的网址，在渲染时用户名将带上该网址的超链。
并且，每条评论信息也要增加回复按钮。代码段如下：
```js
    const commentList = ret.data;
    let html = "";
    for(const item of commentList){
    let contentItem = "<div class='content-item'>";
    contentItem += "<div class='user-info'><span class='user' data-website='" + item.website + "'>" + item.name + "</span>"
                + "<span class='time'>" + parseTime(item.gmtCreate) + "</span></div>";
    contentItem += "<div class='content'>" + item.content + "</div>";
    contentItem += "<div class='operate' data-id='" + item["_id"] + "' data-content='" + item.content + "' data-name='" + item.name + "'>回复</div></div>";
    html += contentItem;
  }
  $(".comment-content").html(html);
  // 注册用户名点击事件
  $(".content-item .user").click(function(){
    const website = $(this).attr("data-website");
    if(website != "undefined"){
      window.open(website);
    }
  });
  // 注册回复点击事件
  $(".content-item .operate").click(function(){
    const replyId = $(this).attr("data-id");
    const content = $(this).attr("data-content");
    const name = $(this).attr("data-name");
    comment.replyId = replyId;
    $(".comment-body textarea").val("<blockquote><pre>引用" + name + "的发言:</pre>" + content + "</blockquote>");
    window.location.href = "#comment-text";
  });
```

#### 消息提醒
消息提醒功能是指前端页面上显示当前访问用户是否有未读的评论回复消息，并且点击可以跳转到对应的文章，相应的未读提示减少。
该消息提示框将绝对定在在页面的右上角。
实现起来也很简单，首先是要绝对定位放置一个HTML容器在页面的右上角，如：
```html
<style>
    #msg-tip {
      background-color: orangered;
      color: white;
      position: fixed;
      top: 50px;
      right: 10px;
      z-index: 2;
      display: none;
      cursor: pointer;
    }
    #msg-modal {
      position: fixed;
      top: 20%;
      left: 50%;
      width: 400px;
      margin-left: -200px;
      z-index: 2;
      -webkit-box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
      -moz-box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
      box-shadow: 0 5px 15px rgba(0, 0, 0, .5);
      padding: 5px 20px;
      background: white;
      display: none;
    }
    #msg-modal h5 {
      float: left;
    }
    #msg-modal .close {
      float: right;
    }
    #modal-body {
      clear: both;
    }
    #modal-body .item a {
      color: #219bde;
    }
  </style>
<div id="msg-tip">
    ❗️你有<span>0</span>条未读消息
  </div>

  <div id="msg-modal">
    <div id="modal-header">
      <h5>消息列表</h5>
      <span class="close">X</span>
    </div>
    <div id="modal-body">

    </div>
  </div>
```
然后根据用户信息读取接口获取其被回复的消息进行填充。如果没有则默认不展示，否则点击提示框后将弹出消息列表弹框，渲染逻辑代码段如下：
```js
let total = replyComments.length;
if(total > 0){
    $("#msg-tip span").text(total);
    $("#msg-tip").show();
    let html = "";
    for(let item of replyComments){
        let pageUrl = item.url;
        let name = item.name;
        html += '<div class="item"><a data-id="' + item._id + '" data-url="' + getUrl(pageUrl) + '">' + name + '回复你</a></div>';
    }
    $("#modal-body").html(html);
    msgClickReg();
}
```

详细的代码可以参考：
[comment.swig--评论容器及逻辑](https://github.com/zhangjh/hello-blog/blob/master/themes/nextNew/layout/_scripts/comments/comment.swig)
[custom.js--消息列表逻辑](https://github.com/zhangjh/hello-blog/blob/master/source/js/custom.js)

至此，一个自研评论系统就算完成了。