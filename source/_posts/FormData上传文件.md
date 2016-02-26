title: 使用HTML5 FormData上传文件
show: true
date: 2016-02-21 15:33:28
tags: ["HTML5","FormData","上传文件"]
categrories: 技术人生
---
前端开发中，每当遇到要写文件上传的功能的时候，第一时间就是去百度搜搜看有没有什么好用的插件。通常要么是用`iframe`，要么是用一些基于`jQuery`的插件。（实际也是利用`iframe`）
现在有了`HTML5`的`FormData`技术，无需插件就可以实现文件上传功能了，方便多了。本篇博文记录一下我使用`FormData`上传图片的功能实现。

#### FormData简介
> `XMLHttpRequest Level 2`添加了一个新的接口`FormData`.利用`FormData`对象,我们可以通过`JavaScript`用一些键值对来模拟一系列表单控件,我们还可以使用`XMLHttpRequest`的`send()`方法来异步的提交这个"表单".比起普通的`ajax`,使用`FormData`的最大优点就是我们可以异步上传一个二进制文件.      ----    [来自mozilla MDN](https://developer.mozilla.org/zh-CN/docs/Web/API/FormData)

`XMLHttpRequest`就是我们使用的`ajax`技术，简单来说`FormData`提供了一种直接异步上传文件的技术。
利用`FormData`对象，你可以使用一系列的键值对来模拟一个完整的表单，然后使用`XMLHttpRequest`发送这个"表单"。

"Talk is Cheap"，让我们直接来看使用实例吧。

<!--more-->

#### 实例
##### 1. 首先来看一下[MDN提供的用例](https://developer.mozilla.org/zh-CN/docs/Web/Guide/Using_FormData_Objects)
###### 1.1 创建FormData对象
```js
var oMyForm = new FormData();

oMyForm.append("username","Groucho");
oMyForm.append("accountnum",123456);

//fileInputElement中已经包含了用户所选择的文件
oMyForm.append("userfile",fileInputElement.files[0]);

var oFileBody = '<a id="a"><b id="b">hey!</b></a>';//Blob对象包含的文件内容
var oBlob = new Blob([oFileBody],{type:"text/xml"});

oMyForm.append("webmasterfile",oBlob);

var oReq = new XMLHttpRequest();
oReq.open("POST","http://foo.com/subnmitform.php");
oReq.send(oMyForm);
```
上例构造了一个`oMyForm`的`dataForm`对象，包含了`"username","accountnum","userfile"`以及`"webmasterfile"`的字段，然后用ajax将他们提交。

还可以使用表单来初始化一个FormData对象
###### 1.2 使用HTML表单来初始化对象
**只需要把这个form元素作为参数传入FormData的构造函数即可。**
```js
var formElement = document.getElementById("myForm");
var oReq = new XMLHttpRequest();
oReq.open("POST","submitform.php");
oReq.send(new FormData(formElement));
```
总体来说跟上述是一样的，只是上例是自己构造，该处是用form表单来构造对象。

##### 2.使用FormData上传文件
接下来看一下我的使用实例，上传图片。
首先，要有一个包含了文件输入框的form元素。
HTML容器部分如下：
```html
<div class="col-md-5">
    <span>身份证正面照片</span>
    <form method="post" action="javascript:;" id="idCardFace" enctype="multipart/form-data">
        <input type="file" class="form-control" name="pidCard" accept="image/gif,image/jpeg,image/png"/>
        <input type="submit" name="submit" value="点击上传" class="btn btn-default btn-primary">
    </form>
    <div class="preview">
        <img src="" alt="idCardFaceImg">
    </div>
</div>
```
这里需要注意，`form`表单的`enctype`属性需要设置为`multipart/form-data`才能提交二进制数据。
主要就是关注这一点，以及一个`type=file`的`input`控件，别的代码可以忽略。
JS部分：
```js
var formEle = $(btn).parent()[0];
var formData = new FormData(fileEle);
formData.append("userInfo",global.userInfo);
$.ajax({
    url: "xxxx",
    type: "POST",
    data: formData, 
    cache: false,
    contentType: false,           //告诉jquery不要设置content-type头部
    processData: false            //告诉jquery不要对参数进行处理
}).done(function(ret) {
    //上传成功处理流程
}).fail(function() {
    //上传失败处理流程
});
```
简单分析一下，首先根据FormData的使用方式，我们需要将HTML中的`form`传递给构造函数，因此首先要获取到form元素。
`btn`是上述`HTML`容器中的"点击上传"按钮，我们需要使用`$(btn).parent()[0]`来获取到`form`元素。
然后，在传递之前，我还利用`append`函数为对象插入了一个额外的字段，类似于普通表单传递时利用`type=hidden`的`input`来传递一些额外信息。
构造完毕之后就是调用ajax将对象发送出去了。

##### 3.结果示意图
![](http://ww4.sinaimg.cn/mw690/62d95157gw1f1719qma4nj20d5077wfe.jpg)
试了下，现今的几大主流浏览器`Chrome，firefox，IE11，Safari`都支持了，可以放心大胆的使用了。
